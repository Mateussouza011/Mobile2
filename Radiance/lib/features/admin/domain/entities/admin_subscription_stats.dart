import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../multi_tenant/domain/entities/company.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';

/// Estatísticas de assinatura para admin com histórico de pagamentos
class AdminSubscriptionStats extends Equatable {
  final Subscription subscription;
  final Company company;
  final List<PaymentRecord> paymentHistory;
  final double totalRevenue;
  final double monthlyRecurringRevenue; // MRR
  final int daysUntilRenewal;
  final bool isOverdue;
  final DateTime? lastPaymentDate;
  final DateTime? nextBillingDate;

  const AdminSubscriptionStats({
    required this.subscription,
    required this.company,
    required this.paymentHistory,
    required this.totalRevenue,
    required this.monthlyRecurringRevenue,
    required this.daysUntilRenewal,
    required this.isOverdue,
    this.lastPaymentDate,
    this.nextBillingDate,
  });

  String get statusDisplay {
    switch (subscription.status) {
      case SubscriptionStatus.active:
        return 'Ativa';
      case SubscriptionStatus.pastDue:
        return 'Vencida';
      case SubscriptionStatus.canceled:
        return 'Cancelada';
      case SubscriptionStatus.suspended:
        return 'Suspensa';
      case SubscriptionStatus.trial:
        return 'Trial';
      default:
        return subscription.status.toString();
    }
  }

  Color get statusColor {
    switch (subscription.status) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.pastDue:
        return Colors.orange;
      case SubscriptionStatus.canceled:
        return Colors.red;
      case SubscriptionStatus.suspended:
        return Colors.red.shade700;
      case SubscriptionStatus.trial:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get tierDisplay {
    switch (subscription.tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.pro:
        return 'Pro';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
      default:
        return subscription.tier.toString();
    }
  }

  Color get tierColor {
    switch (subscription.tier) {
      case SubscriptionTier.free:
        return Colors.grey;
      case SubscriptionTier.pro:
        return Colors.blue;
      case SubscriptionTier.enterprise:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String get renewalStatus {
    if (subscription.status == SubscriptionStatus.canceled) {
      return 'Cancelada';
    }
    if (isOverdue) {
      return '$daysUntilRenewal dias em atraso';
    }
    if (daysUntilRenewal < 0) {
      return 'Vencida';
    }
    if (daysUntilRenewal == 0) {
      return 'Vence hoje';
    }
    if (daysUntilRenewal <= 7) {
      return 'Vence em $daysUntilRenewal dias';
    }
    return 'Renovação em $daysUntilRenewal dias';
  }

  bool get needsAttention {
    return isOverdue || 
           subscription.status == SubscriptionStatus.pastDue ||
           subscription.status == SubscriptionStatus.suspended ||
           (daysUntilRenewal <= 3 && daysUntilRenewal >= 0);
  }

  int get successfulPayments {
    return paymentHistory.where((p) => p.status == PaymentStatus.success).length;
  }

  int get failedPayments {
    return paymentHistory.where((p) => p.status == PaymentStatus.failed).length;
  }

  double get averagePaymentAmount {
    final successful = paymentHistory.where((p) => p.status == PaymentStatus.success);
    if (successful.isEmpty) return 0;
    return successful.map((p) => p.amount).reduce((a, b) => a + b) / successful.length;
  }

  @override
  List<Object?> get props => [
        subscription,
        company,
        paymentHistory,
        totalRevenue,
        monthlyRecurringRevenue,
        daysUntilRenewal,
        isOverdue,
        lastPaymentDate,
        nextBillingDate,
      ];
}

/// Registro de pagamento
class PaymentRecord extends Equatable {
  final String id;
  final String subscriptionId;
  final double amount;
  final PaymentStatus status;
  final String? transactionId; // ID externo (Stripe, etc)
  final String? paymentMethod; // credit_card, boleto, pix, etc
  final String? failureReason;
  final DateTime createdAt;
  final DateTime? processedAt;

  const PaymentRecord({
    required this.id,
    required this.subscriptionId,
    required this.amount,
    required this.status,
    this.transactionId,
    this.paymentMethod,
    this.failureReason,
    required this.createdAt,
    this.processedAt,
  });

  String get statusDisplay {
    switch (status) {
      case PaymentStatus.success:
        return 'Aprovado';
      case PaymentStatus.failed:
        return 'Falhou';
      case PaymentStatus.pending:
        return 'Pendente';
      case PaymentStatus.refunded:
        return 'Reembolsado';
      default:
        return status.toString();
    }
  }

  Color get statusColor {
    switch (status) {
      case PaymentStatus.success:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.refunded:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get paymentMethodDisplay {
    if (paymentMethod == null) return 'N/A';
    switch (paymentMethod) {
      case 'credit_card':
        return 'Cartão de Crédito';
      case 'boleto':
        return 'Boleto';
      case 'pix':
        return 'PIX';
      case 'bank_transfer':
        return 'Transferência';
      default:
        return paymentMethod!;
    }
  }

  @override
  List<Object?> get props => [
        id,
        subscriptionId,
        amount,
        status,
        transactionId,
        paymentMethod,
        failureReason,
        createdAt,
        processedAt,
      ];
}

enum PaymentStatus {
  success,
  failed,
  pending,
  refunded,
}

/// Filtros para listagem de assinaturas
class SubscriptionFilters extends Equatable {
  final String? searchQuery; // Nome da empresa
  final SubscriptionTier? tier;
  final SubscriptionStatus? status;
  final bool? isOverdue;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final SubscriptionSortBy sortBy;
  final bool ascending;

  const SubscriptionFilters({
    this.searchQuery,
    this.tier,
    this.status,
    this.isOverdue,
    this.createdAfter,
    this.createdBefore,
    this.sortBy = SubscriptionSortBy.createdAt,
    this.ascending = false,
  });

  SubscriptionFilters copyWith({
    String? searchQuery,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    bool? isOverdue,
    DateTime? createdAfter,
    DateTime? createdBefore,
    SubscriptionSortBy? sortBy,
    bool? ascending,
  }) {
    return SubscriptionFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      isOverdue: isOverdue ?? this.isOverdue,
      createdAfter: createdAfter ?? this.createdAfter,
      createdBefore: createdBefore ?? this.createdBefore,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  bool get hasActiveFilters {
    return searchQuery != null ||
        tier != null ||
        status != null ||
        isOverdue != null ||
        createdAfter != null ||
        createdBefore != null;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        tier,
        status,
        isOverdue,
        createdAfter,
        createdBefore,
        sortBy,
        ascending,
      ];
}

enum SubscriptionSortBy {
  companyName,
  tier,
  status,
  createdAt,
  revenue,
  nextBilling,
}

extension SubscriptionSortByExtension on SubscriptionSortBy {
  String get displayName {
    switch (this) {
      case SubscriptionSortBy.companyName:
        return 'Nome da empresa';
      case SubscriptionSortBy.tier:
        return 'Plano';
      case SubscriptionSortBy.status:
        return 'Status';
      case SubscriptionSortBy.createdAt:
        return 'Data de criação';
      case SubscriptionSortBy.revenue:
        return 'Receita';
      case SubscriptionSortBy.nextBilling:
        return 'Próxima cobrança';
    }
  }
}

/// Ação de alteração de assinatura
class SubscriptionAction extends Equatable {
  final String subscriptionId;
  final SubscriptionActionType type;
  final SubscriptionTier? newTier;
  final String? reason;
  final DateTime timestamp;
  final String performedBy; // Admin user ID

  const SubscriptionAction({
    required this.subscriptionId,
    required this.type,
    this.newTier,
    this.reason,
    required this.timestamp,
    required this.performedBy,
  });

  String get typeDisplay {
    switch (type) {
      case SubscriptionActionType.upgrade:
        return 'Upgrade';
      case SubscriptionActionType.downgrade:
        return 'Downgrade';
      case SubscriptionActionType.cancel:
        return 'Cancelamento';
      case SubscriptionActionType.reactivate:
        return 'Reativação';
      case SubscriptionActionType.suspend:
        return 'Suspensão';
      case SubscriptionActionType.refund:
        return 'Reembolso';
    }
  }

  @override
  List<Object?> get props => [
        subscriptionId,
        type,
        newTier,
        reason,
        timestamp,
        performedBy,
      ];
}

enum SubscriptionActionType {
  upgrade,
  downgrade,
  cancel,
  reactivate,
  suspend,
  refund,
}
