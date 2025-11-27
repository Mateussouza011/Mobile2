import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_subscription_stats.dart';
import '../../data/repositories/admin_subscription_repository.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';

class AdminSubscriptionProvider extends ChangeNotifier {
  final AdminSubscriptionRepository _repository;

  List<AdminSubscriptionStats> _subscriptions = [];
  AdminSubscriptionStats? _selectedSubscription;
  SubscriptionFilters _filters = const SubscriptionFilters();
  Map<String, dynamic>? _systemStats;
  bool _isLoading = false;
  String? _error;

  AdminSubscriptionProvider(this._repository);

  // Getters
  List<AdminSubscriptionStats> get subscriptions => _subscriptions;
  AdminSubscriptionStats? get selectedSubscription => _selectedSubscription;
  SubscriptionFilters get filters => _filters;
  Map<String, dynamic>? get systemStats => _systemStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalSubscriptions => _subscriptions.length;
  int get activeSubscriptions => 
      _subscriptions.where((s) => s.subscription.status == SubscriptionStatus.active).length;
  int get overdueSubscriptions =>
      _subscriptions.where((s) => s.isOverdue).length;
  int get subscriptionsNeedingAttention =>
      _subscriptions.where((s) => s.needsAttention).length;

  double get totalMRR =>
      _subscriptions.fold(0.0, (sum, s) => sum + s.monthlyRecurringRevenue);

  double get totalRevenue =>
      _subscriptions.fold(0.0, (sum, s) => sum + s.totalRevenue);

  // Agrupar por tier
  Map<SubscriptionTier, List<AdminSubscriptionStats>> get subscriptionsByTier {
    final grouped = <SubscriptionTier, List<AdminSubscriptionStats>>{};
    for (final tier in SubscriptionTier.values) {
      grouped[tier] = _subscriptions
          .where((s) => s.subscription.tier == tier)
          .toList();
    }
    return grouped;
  }

  // Agrupar por status
  Map<SubscriptionStatus, List<AdminSubscriptionStats>> get subscriptionsByStatus {
    final grouped = <SubscriptionStatus, List<AdminSubscriptionStats>>{};
    for (final status in SubscriptionStatus.values) {
      grouped[status] = _subscriptions
          .where((s) => s.subscription.status == status)
          .toList();
    }
    return grouped;
  }

  /// Carrega todas as assinaturas
  Future<void> loadSubscriptions() async {
    _setLoading(true);
    _error = null;

    final result = await _repository.getAllSubscriptions(_filters);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _subscriptions = [];
      },
      (subscriptions) {
        _subscriptions = subscriptions;
      },
    );

    _setLoading(false);
  }

  /// Busca assinaturas por texto
  Future<void> searchSubscriptions(String query) async {
    _filters = _filters.copyWith(searchQuery: query.isEmpty ? null : query);
    await loadSubscriptions();
  }

  /// Aplica filtros
  Future<void> applyFilters(SubscriptionFilters filters) async {
    _filters = filters;
    await loadSubscriptions();
  }

  /// Limpa filtros
  Future<void> clearFilters() async {
    _filters = const SubscriptionFilters();
    await loadSubscriptions();
  }

  /// Carrega detalhes de uma assinatura
  Future<void> loadSubscriptionDetails(String subscriptionId) async {
    _setLoading(true);
    _error = null;

    final result = await _repository.getSubscriptionDetails(subscriptionId);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _selectedSubscription = null;
      },
      (subscription) {
        _selectedSubscription = subscription;
      },
    );

    _setLoading(false);
  }

  /// Atualiza tier da assinatura (upgrade/downgrade)
  Future<bool> updateSubscriptionTier(
    String subscriptionId,
    SubscriptionTier newTier,
    String adminUserId,
    String? reason,
  ) async {
    _error = null;

    final result = await _repository.updateSubscriptionTier(
      subscriptionId,
      newTier,
      adminUserId,
      reason,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Atualizar localmente
        final index = _subscriptions.indexWhere(
          (s) => s.subscription.id == subscriptionId,
        );
        if (index != -1) {
          _subscriptions[index] = AdminSubscriptionStats(
            subscription: _subscriptions[index].subscription.copyWith(tier: newTier),
            company: _subscriptions[index].company,
            paymentHistory: _subscriptions[index].paymentHistory,
            totalRevenue: _subscriptions[index].totalRevenue,
            monthlyRecurringRevenue: _subscriptions[index].monthlyRecurringRevenue,
            daysUntilRenewal: _subscriptions[index].daysUntilRenewal,
            isOverdue: _subscriptions[index].isOverdue,
            lastPaymentDate: _subscriptions[index].lastPaymentDate,
            nextBillingDate: _subscriptions[index].nextBillingDate,
          );
        }

        if (_selectedSubscription?.subscription.id == subscriptionId) {
          _selectedSubscription = _subscriptions[index];
        }

        notifyListeners();
        return true;
      },
    );
  }

  /// Cancela uma assinatura
  Future<bool> cancelSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    _error = null;

    final result = await _repository.cancelSubscription(
      subscriptionId,
      adminUserId,
      reason,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Atualizar localmente
        final index = _subscriptions.indexWhere(
          (s) => s.subscription.id == subscriptionId,
        );
        if (index != -1) {
          _subscriptions[index] = AdminSubscriptionStats(
            subscription: _subscriptions[index].subscription.copyWith(
              status: SubscriptionStatus.cancelled,
              cancelledAt: DateTime.now(),
            ),
            company: _subscriptions[index].company,
            paymentHistory: _subscriptions[index].paymentHistory,
            totalRevenue: _subscriptions[index].totalRevenue,
            monthlyRecurringRevenue: 0.0, // MRR = 0 após cancelamento
            daysUntilRenewal: _subscriptions[index].daysUntilRenewal,
            isOverdue: _subscriptions[index].isOverdue,
            lastPaymentDate: _subscriptions[index].lastPaymentDate,
            nextBillingDate: _subscriptions[index].nextBillingDate,
          );
        }

        if (_selectedSubscription?.subscription.id == subscriptionId) {
          _selectedSubscription = _subscriptions[index];
        }

        notifyListeners();
        return true;
      },
    );
  }

  /// Reativa uma assinatura
  Future<bool> reactivateSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    _error = null;

    final result = await _repository.reactivateSubscription(
      subscriptionId,
      adminUserId,
      reason,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Recarregar para pegar valores corretos
        loadSubscriptions();
        return true;
      },
    );
  }

  /// Suspende uma assinatura
  Future<bool> suspendSubscription(
    String subscriptionId,
    String adminUserId,
    String? reason,
  ) async {
    _error = null;

    final result = await _repository.suspendSubscription(
      subscriptionId,
      adminUserId,
      reason,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Atualizar localmente
        final index = _subscriptions.indexWhere(
          (s) => s.subscription.id == subscriptionId,
        );
        if (index != -1) {
          _subscriptions[index] = AdminSubscriptionStats(
            subscription: _subscriptions[index].subscription.copyWith(
              status: SubscriptionStatus.suspended,
            ),
            company: _subscriptions[index].company,
            paymentHistory: _subscriptions[index].paymentHistory,
            totalRevenue: _subscriptions[index].totalRevenue,
            monthlyRecurringRevenue: 0.0,
            daysUntilRenewal: _subscriptions[index].daysUntilRenewal,
            isOverdue: _subscriptions[index].isOverdue,
            lastPaymentDate: _subscriptions[index].lastPaymentDate,
            nextBillingDate: _subscriptions[index].nextBillingDate,
          );
        }

        if (_selectedSubscription?.subscription.id == subscriptionId) {
          _selectedSubscription = _subscriptions[index];
        }

        notifyListeners();
        return true;
      },
    );
  }

  /// Processa reembolso
  Future<bool> processRefund(
    String paymentId,
    String adminUserId,
    String? reason,
  ) async {
    _error = null;

    final result = await _repository.processRefund(
      paymentId,
      adminUserId,
      reason,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Recarregar assinatura selecionada se houver
        if (_selectedSubscription != null) {
          loadSubscriptionDetails(_selectedSubscription!.subscription.id);
        }
        notifyListeners();
        return true;
      },
    );
  }

  /// Carrega estatísticas do sistema
  Future<void> loadSystemStats() async {
    final result = await _repository.getSystemSubscriptionStats();

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _systemStats = null;
      },
      (stats) {
        _systemStats = stats;
      },
    );

    notifyListeners();
  }

  /// Limpa erro
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Limpa assinatura selecionada
  void clearSelectedSubscription() {
    _selectedSubscription = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFailureToMessage(dynamic failure) {
    return failure.toString();
  }
}
