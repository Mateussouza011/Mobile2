import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../multi_tenant/domain/entities/company.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';

/// Estatísticas de uma empresa para admin
class AdminCompanyStats extends Equatable {
  final Company company;
  final Subscription? subscription;
  final int totalMembers;
  final int activeMembers;
  final int totalPredictions;
  final int predictionsThisMonth;
  final DateTime? lastActivity;
  final double totalRevenue;
  final DateTime createdAt;

  const AdminCompanyStats({
    required this.company,
    this.subscription,
    required this.totalMembers,
    required this.activeMembers,
    required this.totalPredictions,
    required this.predictionsThisMonth,
    this.lastActivity,
    required this.totalRevenue,
    required this.createdAt,
  });

  String get statusDisplay {
    if (!company.isActive) return 'Suspensa';
    if (subscription == null) return 'Sem assinatura';
    return _getStatusName(subscription!.status);
  }
  
  String _getStatusName(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Ativa';
      case SubscriptionStatus.trialing:
        return 'Trial';
      case SubscriptionStatus.pastDue:
        return 'Pagamento Atrasado';
      case SubscriptionStatus.cancelled:
        return 'Cancelada';
      case SubscriptionStatus.expired:
        return 'Expirada';
      case SubscriptionStatus.suspended:
        return 'Suspensa';
    }
  }

  Color get statusColor {
    if (!company.isActive) return Colors.red;
    if (subscription == null) return Colors.grey;
    
    switch (subscription!.status) {
      case SubscriptionStatus.active:
      case SubscriptionStatus.trialing:
        return Colors.green;
      case SubscriptionStatus.pastDue:
        return Colors.orange;
      case SubscriptionStatus.cancelled:
      case SubscriptionStatus.expired:
        return Colors.red;
      case SubscriptionStatus.suspended:
        return Colors.grey;
    }
  }

  String get tierDisplay {
    if (subscription == null) return 'Free';
    switch (subscription!.tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.pro:
        return 'Pro';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
    }
  }

  bool get needsAttention {
    if (!company.isActive) return true;
    if (subscription?.status == SubscriptionStatus.pastDue) return true;
    if (subscription?.status == SubscriptionStatus.suspended) return true;
    return false;
  }

  @override
  List<Object?> get props => [
        company,
        subscription,
        totalMembers,
        activeMembers,
        totalPredictions,
        predictionsThisMonth,
        lastActivity,
        totalRevenue,
        createdAt,
      ];
}

/// Filtros para listagem de empresas
class CompanyFilters extends Equatable {
  final String? searchQuery;
  final SubscriptionTier? tier;
  final SubscriptionStatus? status;
  final bool? isActive;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final CompanySortBy sortBy;
  final bool ascending;

  const CompanyFilters({
    this.searchQuery,
    this.tier,
    this.status,
    this.isActive,
    this.createdAfter,
    this.createdBefore,
    this.sortBy = CompanySortBy.createdAt,
    this.ascending = false,
  });

  CompanyFilters copyWith({
    String? searchQuery,
    SubscriptionTier? tier,
    SubscriptionStatus? status,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
    CompanySortBy? sortBy,
    bool? ascending,
  }) {
    return CompanyFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
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
        isActive != null ||
        createdAfter != null ||
        createdBefore != null;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        tier,
        status,
        isActive,
        createdAfter,
        createdBefore,
        sortBy,
        ascending,
      ];
}

enum CompanySortBy {
  name,
  createdAt,
  totalMembers,
  totalPredictions,
  revenue,
}

extension CompanySortByExtension on CompanySortBy {
  String get displayName {
    switch (this) {
      case CompanySortBy.name:
        return 'Nome';
      case CompanySortBy.createdAt:
        return 'Data de criação';
      case CompanySortBy.totalMembers:
        return 'Total de membros';
      case CompanySortBy.totalPredictions:
        return 'Total de previsões';
      case CompanySortBy.revenue:
        return 'Receita';
    }
  }
}
