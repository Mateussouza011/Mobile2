import 'package:equatable/equatable.dart';

/// Representa um registro de auditoria no sistema
class AdminAuditLog extends Equatable {
  final String id;
  final String action;
  final AuditLogCategory category;
  final String? userId;
  final String? userName;
  final String? targetId;
  final String? targetType;
  final String? targetName;
  final Map<String, dynamic>? metadata;
  final String? ipAddress;
  final String? userAgent;
  final AuditLogSeverity severity;
  final DateTime createdAt;

  const AdminAuditLog({
    required this.id,
    required this.action,
    required this.category,
    this.userId,
    this.userName,
    this.targetId,
    this.targetType,
    this.targetName,
    this.metadata,
    this.ipAddress,
    this.userAgent,
    required this.severity,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        action,
        category,
        userId,
        userName,
        targetId,
        targetType,
        targetName,
        metadata,
        ipAddress,
        userAgent,
        severity,
        createdAt,
      ];

  String get formattedMetadata {
    if (metadata == null || metadata!.isEmpty) return '';
    return metadata!.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
  }

  String get actionDescription {
    switch (category) {
      case AuditLogCategory.user:
        return 'Usuário: $action';
      case AuditLogCategory.company:
        return 'Empresa: $action';
      case AuditLogCategory.subscription:
        return 'Assinatura: $action';
      case AuditLogCategory.payment:
        return 'Pagamento: $action';
      case AuditLogCategory.auth:
        return 'Autenticação: $action';
      case AuditLogCategory.system:
        return 'Sistema: $action';
      case AuditLogCategory.security:
        return 'Segurança: $action';
    }
  }
}

/// Categoria do log de auditoria
enum AuditLogCategory {
  user,
  company,
  subscription,
  payment,
  auth,
  system,
  security,
}

/// Severidade do log de auditoria
enum AuditLogSeverity {
  info,
  warning,
  critical,
}

/// Filtros para logs de auditoria
class AuditLogFilters extends Equatable {
  final String? searchQuery;
  final AuditLogCategory? category;
  final AuditLogSeverity? severity;
  final String? userId;
  final String? targetType;
  final DateTime? startDate;
  final DateTime? endDate;
  final AuditLogSortBy sortBy;
  final bool ascending;

  const AuditLogFilters({
    this.searchQuery,
    this.category,
    this.severity,
    this.userId,
    this.targetType,
    this.startDate,
    this.endDate,
    this.sortBy = AuditLogSortBy.createdAt,
    this.ascending = false,
  });

  AuditLogFilters copyWith({
    String? searchQuery,
    AuditLogCategory? category,
    AuditLogSeverity? severity,
    String? userId,
    String? targetType,
    DateTime? startDate,
    DateTime? endDate,
    AuditLogSortBy? sortBy,
    bool? ascending,
  }) {
    return AuditLogFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      userId: userId ?? this.userId,
      targetType: targetType ?? this.targetType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  AuditLogFilters clearFilter(String filterName) {
    switch (filterName) {
      case 'searchQuery':
        return copyWith(searchQuery: '');
      case 'category':
        return AuditLogFilters(
          searchQuery: searchQuery,
          severity: severity,
          userId: userId,
          targetType: targetType,
          startDate: startDate,
          endDate: endDate,
          sortBy: sortBy,
          ascending: ascending,
        );
      case 'severity':
        return AuditLogFilters(
          searchQuery: searchQuery,
          category: category,
          userId: userId,
          targetType: targetType,
          startDate: startDate,
          endDate: endDate,
          sortBy: sortBy,
          ascending: ascending,
        );
      case 'userId':
        return copyWith(userId: '');
      case 'targetType':
        return copyWith(targetType: '');
      case 'dateRange':
        return AuditLogFilters(
          searchQuery: searchQuery,
          category: category,
          severity: severity,
          userId: userId,
          targetType: targetType,
          sortBy: sortBy,
          ascending: ascending,
        );
      default:
        return this;
    }
  }

  bool get hasActiveFilters {
    return searchQuery?.isNotEmpty == true ||
        category != null ||
        severity != null ||
        userId?.isNotEmpty == true ||
        targetType?.isNotEmpty == true ||
        startDate != null ||
        endDate != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (searchQuery?.isNotEmpty == true) count++;
    if (category != null) count++;
    if (severity != null) count++;
    if (userId?.isNotEmpty == true) count++;
    if (targetType?.isNotEmpty == true) count++;
    if (startDate != null || endDate != null) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        category,
        severity,
        userId,
        targetType,
        startDate,
        endDate,
        sortBy,
        ascending,
      ];
}

/// Ordenação de logs de auditoria
enum AuditLogSortBy {
  createdAt,
  action,
  category,
  severity,
  userName,
}

/// Estatísticas de logs de auditoria
class AuditLogStats extends Equatable {
  final int totalLogs;
  final int infoCount;
  final int warningCount;
  final int criticalCount;
  final Map<AuditLogCategory, int> logsByCategory;
  final Map<String, int> topUsers;
  final Map<String, int> topActions;

  const AuditLogStats({
    required this.totalLogs,
    required this.infoCount,
    required this.warningCount,
    required this.criticalCount,
    required this.logsByCategory,
    required this.topUsers,
    required this.topActions,
  });

  @override
  List<Object?> get props => [
        totalLogs,
        infoCount,
        warningCount,
        criticalCount,
        logsByCategory,
        topUsers,
        topActions,
      ];
}
