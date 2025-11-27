import 'package:equatable/equatable.dart';

/// Dados para criar uma nova assinatura
class CreateSubscriptionData extends Equatable {
  final String companyId;
  final String customerId;
  final String tier; // free, pro, enterprise
  final String billingInterval; // monthly, yearly
  final String? paymentMethodId;
  final bool startTrial;
  final int? trialDays;

  const CreateSubscriptionData({
    required this.companyId,
    required this.customerId,
    required this.tier,
    this.billingInterval = 'monthly',
    this.paymentMethodId,
    this.startTrial = false,
    this.trialDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'customer_id': customerId,
      'tier': tier,
      'billing_interval': billingInterval,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      'start_trial': startTrial,
      if (trialDays != null) 'trial_days': trialDays,
    };
  }

  @override
  List<Object?> get props => [
        companyId,
        customerId,
        tier,
        billingInterval,
        paymentMethodId,
        startTrial,
        trialDays,
      ];
}

/// Dados para atualizar uma assinatura
class UpdateSubscriptionData extends Equatable {
  final String subscriptionId;
  final String? newTier;
  final String? newBillingInterval;
  final String? newPaymentMethodId;
  final bool? cancelAtPeriodEnd;

  const UpdateSubscriptionData({
    required this.subscriptionId,
    this.newTier,
    this.newBillingInterval,
    this.newPaymentMethodId,
    this.cancelAtPeriodEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': subscriptionId,
      if (newTier != null) 'tier': newTier,
      if (newBillingInterval != null) 'billing_interval': newBillingInterval,
      if (newPaymentMethodId != null) 'payment_method_id': newPaymentMethodId,
      if (cancelAtPeriodEnd != null) 'cancel_at_period_end': cancelAtPeriodEnd,
    };
  }

  @override
  List<Object?> get props => [
        subscriptionId,
        newTier,
        newBillingInterval,
        newPaymentMethodId,
        cancelAtPeriodEnd,
      ];
}

/// Preços dos planos (em centavos)
class SubscriptionPricing extends Equatable {
  final String tier;
  final int monthlyPrice; // em centavos (R$ 49.90 = 4990)
  final int yearlyPrice; // em centavos
  final String currency;

  const SubscriptionPricing({
    required this.tier,
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.currency = 'BRL',
  });

  double get monthlyPriceInReais => monthlyPrice / 100;
  double get yearlyPriceInReais => yearlyPrice / 100;
  double get monthlySavingsWithYearly => (monthlyPrice * 12 - yearlyPrice) / 100;
  int get savingsPercentage => ((1 - (yearlyPrice / (monthlyPrice * 12))) * 100).round();

  // Preços padrão dos planos
  static const SubscriptionPricing free = SubscriptionPricing(
    tier: 'free',
    monthlyPrice: 0,
    yearlyPrice: 0,
  );

  static const SubscriptionPricing pro = SubscriptionPricing(
    tier: 'pro',
    monthlyPrice: 4990, // R$ 49.90
    yearlyPrice: 49900, // R$ 499.00 (2 meses grátis)
  );

  static const SubscriptionPricing enterprise = SubscriptionPricing(
    tier: 'enterprise',
    monthlyPrice: 29990, // R$ 299.90
    yearlyPrice: 299900, // R$ 2,999.00 (2 meses grátis)
  );

  static List<SubscriptionPricing> get allPlans => [free, pro, enterprise];

  static SubscriptionPricing? getByTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return free;
      case 'pro':
        return pro;
      case 'enterprise':
        return enterprise;
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [tier, monthlyPrice, yearlyPrice, currency];
}

/// Histórico de pagamentos
class PaymentHistory extends Equatable {
  final String id;
  final String subscriptionId;
  final String companyId;
  final double amount;
  final String currency;
  final String status; // succeeded, failed, pending, refunded
  final String? paymentMethod;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime? paidAt;

  const PaymentHistory({
    required this.id,
    required this.subscriptionId,
    required this.companyId,
    required this.amount,
    this.currency = 'BRL',
    required this.status,
    this.paymentMethod,
    this.failureReason,
    required this.createdAt,
    this.paidAt,
  });

  bool get isSucceeded => status == 'succeeded';
  bool get isFailed => status == 'failed';
  bool get isPending => status == 'pending';
  bool get isRefunded => status == 'refunded';

  @override
  List<Object?> get props => [
        id,
        subscriptionId,
        companyId,
        amount,
        currency,
        status,
        paymentMethod,
        failureReason,
        createdAt,
        paidAt,
      ];
}
