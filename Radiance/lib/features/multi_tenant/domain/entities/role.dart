import 'package:equatable/equatable.dart';

/// Tipos de roles predefinidos no sistema
enum RoleType {
  owner,      // Proprietário - acesso total
  admin,      // Administrador - acesso quase total
  manager,    // Gerente - pode gerenciar usuários e ver relatórios
  analyst,    // Analista - pode fazer predições e ver histórico
  viewer,     // Visualizador - apenas leitura
}

/// Permissões específicas no sistema
enum Permission {
  // Company Management
  manageCompany,
  updateCompanySettings,
  deleteCompany,
  
  // User Management
  inviteUsers,
  removeUsers,
  updateUserRoles,
  viewUsers,
  
  // Predictions
  createPredictions,
  viewPredictions,
  deletePredictions,
  exportPredictions,
  
  // Subscription
  manageSubscription,
  viewBilling,
  updatePaymentMethod,
  
  // API
  manageApiKeys,
  viewApiKeys,
  
  // Reports & Analytics
  viewReports,
  exportReports,
  viewAnalytics,
}

/// Entidade que representa um Role/Cargo no sistema
class Role extends Equatable {
  final String id;
  final String name;
  final RoleType type;
  final String? description;
  final List<Permission> permissions;
  final bool isCustom; // true se foi criado pelo usuário, false se é padrão
  final String? companyId; // null para roles padrão do sistema
  final DateTime createdAt;
  final DateTime updatedAt;

  const Role({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.permissions,
    this.isCustom = false,
    this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Verifica se o role tem uma permissão específica
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  /// Verifica se o role tem todas as permissões especificadas
  bool hasAllPermissions(List<Permission> requiredPermissions) {
    return requiredPermissions.every((p) => permissions.contains(p));
  }

  /// Verifica se o role tem alguma das permissões especificadas
  bool hasAnyPermission(List<Permission> requiredPermissions) {
    return requiredPermissions.any((p) => permissions.contains(p));
  }

  Role copyWith({
    String? id,
    String? name,
    RoleType? type,
    String? description,
    List<Permission>? permissions,
    bool? isCustom,
    String? companyId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      isCustom: isCustom ?? this.isCustom,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        permissions,
        isCustom,
        companyId,
        createdAt,
        updatedAt,
      ];

  // Roles padrão do sistema
  static final Role owner = Role(
    id: 'owner',
    name: 'Proprietário',
    type: RoleType.owner,
    description: 'Acesso total ao sistema',
    permissions: Permission.values, // Todas as permissões
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static final Role admin = Role(
    id: 'admin',
    name: 'Administrador',
    type: RoleType.admin,
    description: 'Gerencia usuários e configurações',
    permissions: const [
      Permission.updateCompanySettings,
      Permission.inviteUsers,
      Permission.removeUsers,
      Permission.updateUserRoles,
      Permission.viewUsers,
      Permission.createPredictions,
      Permission.viewPredictions,
      Permission.deletePredictions,
      Permission.exportPredictions,
      Permission.viewBilling,
      Permission.viewReports,
      Permission.exportReports,
      Permission.viewAnalytics,
      Permission.viewApiKeys,
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static final Role manager = Role(
    id: 'manager',
    name: 'Gerente',
    type: RoleType.manager,
    description: 'Gerencia equipe e visualiza relatórios',
    permissions: const [
      Permission.inviteUsers,
      Permission.viewUsers,
      Permission.createPredictions,
      Permission.viewPredictions,
      Permission.exportPredictions,
      Permission.viewReports,
      Permission.exportReports,
      Permission.viewAnalytics,
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static final Role analyst = Role(
    id: 'analyst',
    name: 'Analista',
    type: RoleType.analyst,
    description: 'Cria predições e visualiza histórico',
    permissions: const [
      Permission.createPredictions,
      Permission.viewPredictions,
      Permission.exportPredictions,
      Permission.viewReports,
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static final Role viewer = Role(
    id: 'viewer',
    name: 'Visualizador',
    type: RoleType.viewer,
    description: 'Apenas visualiza dados',
    permissions: const [
      Permission.viewPredictions,
      Permission.viewReports,
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static List<Role> get defaultRoles => [
        owner,
        admin,
        manager,
        analyst,
        viewer,
      ];
}
