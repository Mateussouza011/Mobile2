import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/subscription_data.dart';
import '../../data/services/abacate_pay_service.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../../../core/error/failures.dart';

/// Provider para gerenciar estado e operações de pagamento
class PaymentProvider extends ChangeNotifier {
  final AbacatePayService _paymentService;
  final SubscriptionRepository _subscriptionRepository;
  final TenantProvider _tenantProvider;

  // Estado
  Subscription? _currentSubscription;
  List<PaymentMethod> _paymentMethods = [];
  List<PaymentHistory> _paymentHistory = [];
  bool _isLoading = false;
  String? _error;
  AbacatePayCustomer? _customer;

  PaymentProvider({
    required AbacatePayService paymentService,
    required SubscriptionRepository subscriptionRepository,
    required TenantProvider tenantProvider,
  })  : _paymentService = paymentService,
        _subscriptionRepository = subscriptionRepository,
        _tenantProvider = tenantProvider {
    _initialize();
  }

  // Getters
  Subscription? get currentSubscription => _currentSubscription;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  List<PaymentHistory> get paymentHistory => _paymentHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AbacatePayCustomer? get customer => _customer;
  
  bool get hasActiveSubscription => 
      _currentSubscription != null && _currentSubscription!.canUseFeatures;
  
  bool get canUpgrade => 
      _currentSubscription != null && 
      _currentSubscription!.tier != SubscriptionTier.enterprise;
  
  bool get canDowngrade =>
      _currentSubscription != null &&
      _currentSubscription!.tier != SubscriptionTier.free;

  SubscriptionTier? get currentTier => _currentSubscription?.tier;

  // ============================================
  // Initialization
  // ============================================

  Future<void> _initialize() async {
    final company = _tenantProvider.currentCompany;
    if (company != null) {
      await loadCurrentSubscription();
      await loadCustomer();
      await loadPaymentMethods();
    }
  }

  // ============================================
  // Subscription Management
  // ============================================

  /// Carrega a assinatura atual da empresa
  Future<void> loadCurrentSubscription() async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      _error = 'Nenhuma empresa selecionada';
      notifyListeners();
      return;
    }

    _setLoading(true);
    
    final result = await _subscriptionRepository.getCompanySubscription(company.id);
    
    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _currentSubscription = null;
      },
      (subscription) {
        _currentSubscription = subscription;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Cria uma nova assinatura
  Future<Either<Failure, Subscription>> createSubscription({
    required SubscriptionTier tier,
    required BillingInterval billingInterval,
    String? paymentMethodId,
    bool startTrial = false,
    int? trialDays,
  }) async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      return Left(ValidationFailure('Nenhuma empresa selecionada'));
    }

    if (_customer == null) {
      return Left(ValidationFailure('Cliente não encontrado. Crie um cliente primeiro.'));
    }

    _setLoading(true);

    try {
      // 1. Criar assinatura no Abacate Pay
      final createData = CreateSubscriptionData(
        companyId: company.id,
        customerId: _customer!.id,
        tier: tier.name,
        billingInterval: billingInterval.name,
        paymentMethodId: paymentMethodId,
        startTrial: startTrial,
        trialDays: trialDays,
      );

      final subscriptionIdResult = await _paymentService.createSubscription(createData);

      if (subscriptionIdResult.isLeft()) {
        _setLoading(false);
        return Left((subscriptionIdResult as Left).value);
      }

      final abacatePaySubscriptionId = (subscriptionIdResult as Right).value;

      // 2. Criar entidade de assinatura local
      final pricing = SubscriptionPricing.getByTier(tier.name);
      if (pricing == null) {
        _setLoading(false);
        return Left(ValidationFailure('Tier inválido'));
      }

      final amount = billingInterval == BillingInterval.yearly
          ? pricing.yearlyPrice
          : pricing.monthlyPrice;

      final now = DateTime.now();
      final periodEnd = billingInterval == BillingInterval.yearly
          ? now.add(const Duration(days: 365))
          : now.add(const Duration(days: 30));

      final subscription = Subscription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        companyId: company.id,
        tier: tier,
        status: startTrial ? SubscriptionStatus.trialing : SubscriptionStatus.active,
        amount: amount,
        billingInterval: billingInterval,
        startDate: now,
        currentPeriodStart: now,
        currentPeriodEnd: periodEnd,
        trialEndsAt: startTrial && trialDays != null
            ? now.add(Duration(days: trialDays))
            : null,
        nextBillingDate: periodEnd,
        limits: _getLimitsForTier(tier),
        abacatePaySubscriptionId: abacatePaySubscriptionId,
        abacatePayCustomerId: _customer!.id,
        createdAt: now,
        updatedAt: now,
      );

      // 3. Salvar localmente
      final saveResult = await _subscriptionRepository.saveSubscription(subscription);

      if (saveResult.isLeft()) {
        _setLoading(false);
        return Left((saveResult as Left).value);
      }

      // 4. Atualizar estado
      _currentSubscription = subscription;
      _error = null;
      _setLoading(false);
      
      // Atualizar tenant provider
      await _tenantProvider.loadUserCompanies();

      return Right(subscription);
    } catch (e) {
      _setLoading(false);
      return Left(ServerFailure('Erro ao criar assinatura: $e'));
    }
  }

  /// Faz upgrade do plano
  Future<Either<Failure, void>> upgradePlan({
    required SubscriptionTier newTier,
    BillingInterval? newBillingInterval,
  }) async {
    if (_currentSubscription == null) {
      return Left(ValidationFailure('Nenhuma assinatura ativa'));
    }

    if (newTier.index <= _currentSubscription!.tier.index) {
      return Left(ValidationFailure('O novo tier deve ser superior ao atual'));
    }

    _setLoading(true);

    final updateData = UpdateSubscriptionData(
      subscriptionId: _currentSubscription!.abacatePaySubscriptionId!,
      newTier: newTier.name,
      newBillingInterval: newBillingInterval?.name,
    );

    final result = await _paymentService.updateSubscription(updateData);

    if (result.isLeft()) {
      _setLoading(false);
      return Left((result as Left).value);
    }

    // Atualizar localmente
    final pricing = SubscriptionPricing.getByTier(newTier.name);
    if (pricing != null) {
      final interval = newBillingInterval ?? _currentSubscription!.billingInterval;
      final amount = interval == BillingInterval.yearly
          ? pricing.yearlyPrice
          : pricing.monthlyPrice;

      await _subscriptionRepository.updateSubscriptionTier(
        subscriptionId: _currentSubscription!.id,
        newTier: newTier.name,
        monthlyPrice: pricing.monthlyPrice,
        yearlyPrice: pricing.yearlyPrice,
        billingInterval: interval.name,
        limits: _getLimitsForTier(newTier),
      );
    }

    await loadCurrentSubscription();
    _setLoading(false);

    return const Right(null);
  }

  /// Faz downgrade do plano
  Future<Either<Failure, void>> downgradePlan({
    required SubscriptionTier newTier,
  }) async {
    if (_currentSubscription == null) {
      return Left(ValidationFailure('Nenhuma assinatura ativa'));
    }

    if (newTier.index >= _currentSubscription!.tier.index) {
      return Left(ValidationFailure('O novo tier deve ser inferior ao atual'));
    }

    _setLoading(true);

    // Downgrade acontece no final do período
    final updateData = UpdateSubscriptionData(
      subscriptionId: _currentSubscription!.abacatePaySubscriptionId!,
      newTier: newTier.name,
      cancelAtPeriodEnd: false, // Trocar no final do período
    );

    final result = await _paymentService.updateSubscription(updateData);

    if (result.isLeft()) {
      _setLoading(false);
      return Left((result as Left).value);
    }

    await loadCurrentSubscription();
    _setLoading(false);

    return const Right(null);
  }

  /// Cancela a assinatura
  Future<Either<Failure, void>> cancelSubscription({
    bool immediate = false,
  }) async {
    if (_currentSubscription == null) {
      return Left(ValidationFailure('Nenhuma assinatura ativa'));
    }

    if (_currentSubscription!.abacatePaySubscriptionId == null) {
      return Left(ValidationFailure('ID da assinatura não encontrado'));
    }

    _setLoading(true);

    final result = await _paymentService.cancelSubscription(
      _currentSubscription!.abacatePaySubscriptionId!,
      immediate: immediate,
    );

    if (result.isLeft()) {
      _setLoading(false);
      return Left((result as Left).value);
    }

    await _subscriptionRepository.updateSubscriptionStatus(
      subscriptionId: _currentSubscription!.id,
      status: immediate ? 'cancelled' : 'active',
      canceledAt: immediate ? DateTime.now() : null,
      cancelAtPeriodEnd: !immediate,
    );

    await loadCurrentSubscription();
    _setLoading(false);

    return const Right(null);
  }

  // ============================================
  // Customer Management
  // ============================================

  /// Carrega o cliente do Abacate Pay
  Future<void> loadCustomer() async {
    if (_currentSubscription?.abacatePayCustomerId != null) {
      final result = await _paymentService.getCustomer(
        _currentSubscription!.abacatePayCustomerId!,
      );

      result.fold(
        (failure) => _error = _getErrorMessage(failure),
        (customer) => _customer = customer,
      );

      notifyListeners();
    }
  }

  /// Cria um cliente no Abacate Pay
  Future<Either<Failure, AbacatePayCustomer>> createCustomer({
    required String email,
    required String name,
    String? phone,
    String? documentNumber,
  }) async {
    _setLoading(true);

    final result = await _paymentService.createCustomer(
      email: email,
      name: name,
      phone: phone,
      documentNumber: documentNumber,
      metadata: {
        'company_id': _tenantProvider.currentCompany?.id ?? '',
      },
    );

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (customer) {
        _customer = customer;
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  // ============================================
  // Payment Methods
  // ============================================

  /// Carrega métodos de pagamento do cliente
  Future<void> loadPaymentMethods() async {
    if (_customer == null) return;

    _setLoading(true);

    final result = await _paymentService.listPaymentMethods(_customer!.id);

    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _paymentMethods = [];
      },
      (methods) {
        _paymentMethods = methods;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Adiciona um método de pagamento
  Future<Either<Failure, PaymentMethod>> addPaymentMethod({
    required String token,
    bool setAsDefault = false,
  }) async {
    if (_customer == null) {
      return Left(ValidationFailure('Cliente não encontrado'));
    }

    _setLoading(true);

    final result = await _paymentService.addPaymentMethod(
      customerId: _customer!.id,
      token: token,
      setAsDefault: setAsDefault,
    );

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (method) {
        _paymentMethods.add(method);
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  /// Remove um método de pagamento
  Future<Either<Failure, void>> removePaymentMethod(String paymentMethodId) async {
    _setLoading(true);

    final result = await _paymentService.removePaymentMethod(paymentMethodId);

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        _paymentMethods.removeWhere((m) => m.id == paymentMethodId);
        _error = null;
      },
    );

    _setLoading(false);

    return result;
  }

  // ============================================
  // Payment History
  // ============================================

  /// Carrega histórico de pagamentos
  Future<void> loadPaymentHistory() async {
    final company = _tenantProvider.currentCompany;
    if (company == null) return;

    _setLoading(true);

    final result = await _subscriptionRepository.getPaymentHistory(
      companyId: company.id,
      limit: 50,
    );

    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _paymentHistory = [];
      },
      (history) {
        _paymentHistory = history;
        _error = null;
      },
    );

    _setLoading(false);
  }

  // ============================================
  // Helpers
  // ============================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return 'Erro de conexão';
    if (failure is ValidationFailure) return failure.message;
    if (failure is NotFoundFailure) return failure.message;
    if (failure is UnauthorizedFailure) return 'Não autorizado';
    return 'Erro desconhecido';
  }

  SubscriptionLimits _getLimitsForTier(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return SubscriptionLimits.free;
      case SubscriptionTier.pro:
        return SubscriptionLimits.pro;
      case SubscriptionTier.enterprise:
        return SubscriptionLimits.enterprise;
    }
  }
}
