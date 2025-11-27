import 'package:equatable/equatable.dart';

/// Tiers de assinatura disponíveis
enum SubscriptionTier {
  free,
  pro,
  enterprise,
}

/// Status da assinatura
enum SubscriptionStatus {
  active,      // Ativa e paga
  trialing,    // Em período de teste
  pastDue,     // Pagamento atrasado
  cancelled,   // Cancelada pelo usuário
  expired,     // Expirada
  suspended,   // Suspensa por inadimplência
}

/// Intervalo de cobrança
enum BillingInterval {
  monthly,
  yearly,
}

/// Entidade que representa uma assinatura de empresa
class Subscription extends Equatable {
  final String id;
  final String companyId;
  final SubscriptionTier tier;
  final SubscriptionStatus status;
  final BillingInterval billingInterval;
  final double amount; // Valor em centavos (R$ 49.90 = 4990)
  final String currency;
  
  // Datas
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? trialEndsAt;
  final DateTime? cancelledAt;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? nextBillingDate;
  
  // Limites do plano
  final SubscriptionLimits limits;
  
  // Integração com Abacate Pay
  final String? abacatePaySubscriptionId;
  final String? abacatePayCustomerId;
  
  // Metadados
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.companyId,
    required this.tier,
    required this.status,
    this.billingInterval = BillingInterval.monthly,
    required this.amount,
    this.currency = 'BRL',
    required this.startDate,
    this.endDate,
    this.trialEndsAt,
    this.cancelledAt,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.nextBillingDate,
    required this.limits,
    this.abacatePaySubscriptionId,
    this.abacatePayCustomerId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == SubscriptionStatus.active;
  bool get isTrialing => status == SubscriptionStatus.trialing;
  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get isExpired => status == SubscriptionStatus.expired;
  bool get isPastDue => status == SubscriptionStatus.pastDue;
  
  bool get canUseFeatures => isActive || isTrialing;
  bool get needsPayment => isPastDue || isExpired;

  Subscription copyWith({
    String? id,
    String? companyId,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    BillingInterval? billingInterval,
    double? amount,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? trialEndsAt,
    DateTime? cancelledAt,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
    DateTime? nextBillingDate,
    SubscriptionLimits? limits,
    String? abacatePaySubscriptionId,
    String? abacatePayCustomerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      billingInterval: billingInterval ?? this.billingInterval,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      limits: limits ?? this.limits,
      abacatePaySubscriptionId: abacatePaySubscriptionId ?? this.abacatePaySubscriptionId,
      abacatePayCustomerId: abacatePayCustomerId ?? this.abacatePayCustomerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyId,
        tier,
        status,
        billingInterval,
        amount,
        currency,
        startDate,
        endDate,
        trialEndsAt,
        cancelledAt,
        currentPeriodStart,
        currentPeriodEnd,
        nextBillingDate,
        limits,
        abacatePaySubscriptionId,
        abacatePayCustomerId,
        createdAt,
        updatedAt,
      ];
}

/// Limites de uso baseados no tier da assinatura
class SubscriptionLimits extends Equatable {
  final int maxPredictionsPerMonth;
  final int maxUsers;
  final bool hasApiAccess;
  final bool hasExportFeatures;
  final bool hasAdvancedAnalytics;
  final bool hasWhiteLabel;
  final bool hasPrioritySupport;

  const SubscriptionLimits({
    required this.maxPredictionsPerMonth,
    required this.maxUsers,
    this.hasApiAccess = false,
    this.hasExportFeatures = false,
    this.hasAdvancedAnalytics = false,
    this.hasWhiteLabel = false,
    this.hasPrioritySupport = false,
  });

  // Limites predefinidos por tier
  static const SubscriptionLimits free = SubscriptionLimits(
    maxPredictionsPerMonth: 10,
    maxUsers: 1,
    hasApiAccess: false,
    hasExportFeatures: false,
    hasAdvancedAnalytics: false,
    hasWhiteLabel: false,
    hasPrioritySupport: false,
  );

  static const SubscriptionLimits pro = SubscriptionLimits(
    maxPredictionsPerMonth: 100,
    maxUsers: 5,
    hasApiAccess: false,
    hasExportFeatures: true,
    hasAdvancedAnalytics: true,
    hasWhiteLabel: false,
    hasPrioritySupport: false,
  );

  static const SubscriptionLimits enterprise = SubscriptionLimits(
    maxPredictionsPerMonth: -1, // Ilimitado
    maxUsers: -1, // Ilimitado
    hasApiAccess: true,
    hasExportFeatures: true,
    hasAdvancedAnalytics: true,
    hasWhiteLabel: true,
    hasPrioritySupport: true,
  );

  bool get hasUnlimitedPredictions => maxPredictionsPerMonth == -1;
  bool get hasUnlimitedUsers => maxUsers == -1;

  @override
  List<Object?> get props => [
        maxPredictionsPerMonth,
        maxUsers,
        hasApiAccess,
        hasExportFeatures,
        hasAdvancedAnalytics,
        hasWhiteLabel,
        hasPrioritySupport,
      ];
}
