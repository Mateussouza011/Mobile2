import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../multi_tenant/domain/entities/company_user.dart';

/// Estatísticas de um usuário para admin
class AdminUserStats extends Equatable {
  final User user;
  final List<CompanyUser> companies; // Empresas às quais o usuário pertence
  final int totalPredictions;
  final int predictionsThisMonth;
  final DateTime? lastActivity;
  final DateTime? lastLogin;
  final bool isActive;
  final DateTime createdAt;

  const AdminUserStats({
    required this.user,
    required this.companies,
    required this.totalPredictions,
    required this.predictionsThisMonth,
    this.lastActivity,
    this.lastLogin,
    required this.isActive,
    required this.createdAt,
  });

  String get statusDisplay {
    if (!isActive) return 'Desativado';
    if (lastLogin == null) return 'Nunca logou';
    
    final daysSinceLogin = DateTime.now().difference(lastLogin!).inDays;
    if (daysSinceLogin > 30) return 'Inativo';
    if (daysSinceLogin > 7) return 'Pouco ativo';
    return 'Ativo';
  }

  Color get statusColor {
    if (!isActive) return Colors.red;
    if (lastLogin == null) return Colors.grey;
    
    final daysSinceLogin = DateTime.now().difference(lastLogin!).inDays;
    if (daysSinceLogin > 30) return Colors.orange;
    if (daysSinceLogin > 7) return Colors.yellow.shade700;
    return Colors.green;
  }

  String get companiesDisplay {
    if (companies.isEmpty) return 'Nenhuma empresa';
    if (companies.length == 1) return companies.first.companyId;
    return '${companies.length} empresas';
  }

  String get rolesDisplay {
    if (companies.isEmpty) return '-';
    final roleIds = companies.map((c) => c.roleId).toSet();
    return roleIds.join(', ');
  }

  bool get needsAttention {
    if (!isActive) return true;
    if (lastLogin == null) return false; // Novo usuário, normal
    
    final daysSinceLogin = DateTime.now().difference(lastLogin!).inDays;
    return daysSinceLogin > 30; // Inativo por mais de 30 dias
  }

  @override
  List<Object?> get props => [
        user,
        companies,
        totalPredictions,
        predictionsThisMonth,
        lastActivity,
        lastLogin,
        isActive,
        createdAt,
      ];
}

/// Filtros para listagem de usuários
class UserFilters extends Equatable {
  final String? searchQuery; // Nome ou email
  final String? companyId; // Filtrar por empresa
  final String? role; // Filtrar por role
  final bool? isActive; // Ativo/desativado
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final UserSortBy sortBy;
  final bool ascending;

  const UserFilters({
    this.searchQuery,
    this.companyId,
    this.role,
    this.isActive,
    this.createdAfter,
    this.createdBefore,
    this.sortBy = UserSortBy.createdAt,
    this.ascending = false,
  });

  UserFilters copyWith({
    String? searchQuery,
    String? companyId,
    String? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
    UserSortBy? sortBy,
    bool? ascending,
  }) {
    return UserFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      companyId: companyId ?? this.companyId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAfter: createdAfter ?? this.createdAfter,
      createdBefore: createdBefore ?? this.createdBefore,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  bool get hasActiveFilters {
    return searchQuery != null ||
        companyId != null ||
        role != null ||
        isActive != null ||
        createdAfter != null ||
        createdBefore != null;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        companyId,
        role,
        isActive,
        createdAfter,
        createdBefore,
        sortBy,
        ascending,
      ];
}

enum UserSortBy {
  name,
  email,
  createdAt,
  lastLogin,
  totalPredictions,
}

extension UserSortByExtension on UserSortBy {
  String get displayName {
    switch (this) {
      case UserSortBy.name:
        return 'Nome';
      case UserSortBy.email:
        return 'Email';
      case UserSortBy.createdAt:
        return 'Data de criação';
      case UserSortBy.lastLogin:
        return 'Último login';
      case UserSortBy.totalPredictions:
        return 'Total de previsões';
    }
  }
}

/// Log de atividade do usuário
class UserActivityLog extends Equatable {
  final String id;
  final String userId;
  final String action; // login, logout, prediction, etc
  final String? details;
  final String? companyId;
  final DateTime timestamp;

  const UserActivityLog({
    required this.id,
    required this.userId,
    required this.action,
    this.details,
    this.companyId,
    required this.timestamp,
  });

  String get actionDisplay {
    switch (action.toLowerCase()) {
      case 'login':
        return 'Login';
      case 'logout':
        return 'Logout';
      case 'prediction':
        return 'Previsão criada';
      case 'company_join':
        return 'Entrou em empresa';
      case 'company_leave':
        return 'Saiu de empresa';
      case 'password_reset':
        return 'Senha redefinida';
      default:
        return action;
    }
  }

  IconData get actionIcon {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'prediction':
        return Icons.analytics;
      case 'company_join':
        return Icons.business;
      case 'company_leave':
        return Icons.exit_to_app;
      case 'password_reset':
        return Icons.lock_reset;
      default:
        return Icons.info;
    }
  }

  @override
  List<Object?> get props => [id, userId, action, details, companyId, timestamp];
}
