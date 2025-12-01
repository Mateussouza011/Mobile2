import 'package:dartz/dartz.dart';
import '../entities/role.dart';
import '../entities/company_user.dart';
import '../../../../core/error/failures.dart';

/// Serviço de autorização baseado em roles (RBAC)
class AuthorizationService {
  /// Verifica se o usuário tem uma permissão específica
  bool hasPermission(
    Role role,
    Permission permission,
  ) {
    return role.hasPermission(permission);
  }

  /// Verifica se o usuário tem todas as permissões especificadas
  bool hasAllPermissions(
    Role role,
    List<Permission> permissions,
  ) {
    return role.hasAllPermissions(permissions);
  }

  /// Verifica se o usuário tem alguma das permissões especificadas
  bool hasAnyPermission(
    Role role,
    List<Permission> permissions,
  ) {
    return role.hasAnyPermission(permissions);
  }

  /// Verifica se o usuário é proprietário da empresa
  bool isOwner(Role role) {
    return role.type == RoleType.owner;
  }

  /// Verifica se o usuário é admin ou proprietário
  bool isAdminOrOwner(Role role) {
    return role.type == RoleType.owner || role.type == RoleType.admin;
  }

  /// Verifica se o usuário pode executar uma ação
  Either<Failure, bool> canPerform(
    Role role,
    Permission permission,
  ) {
    if (!role.hasPermission(permission)) {
      return Left(
        ForbiddenFailure(
          'Você não tem permissão para executar esta ação. '
          'Permissão necessária: ${permission.name}',
        ),
      );
    }
    return const Right(true);
  }

  /// Verifica se o usuário pode gerenciar outro usuário
  bool canManageUser(Role currentUserRole, Role targetUserRole) {
    // Owner pode gerenciar todos
    if (currentUserRole.type == RoleType.owner) return true;

    // Admin pode gerenciar todos exceto Owner
    if (currentUserRole.type == RoleType.admin) {
      return targetUserRole.type != RoleType.owner;
    }

    // Manager pode gerenciar apenas Analyst e Viewer
    if (currentUserRole.type == RoleType.manager) {
      return targetUserRole.type == RoleType.analyst ||
          targetUserRole.type == RoleType.viewer;
    }

    // Outros não podem gerenciar
    return false;
  }

  /// Valida se o usuário pode acessar recursos da empresa
  Either<Failure, bool> validateCompanyAccess(
    String userId,
    String companyId,
    CompanyUser? companyUser,
  ) {
    if (companyUser == null) {
      return const Left(
        ForbiddenFailure(
          'Você não tem acesso a esta empresa',
        ),
      );
    }

    if (companyUser.userId != userId || companyUser.companyId != companyId) {
      return const Left(
        ForbiddenFailure(
          'Acesso negado',
        ),
      );
    }

    if (companyUser.status != CompanyUserStatus.active) {
      return Left(
        ForbiddenFailure(
          'Sua conta nesta empresa está ${companyUser.status.name}',
        ),
      );
    }

    return const Right(true);
  }

  /// Retorna as permissões de um role como lista legível
  List<String> getPermissionNames(Role role) {
    return role.permissions.map((p) => _formatPermissionName(p)).toList();
  }

  /// Formata o nome da permissão para exibição
  String _formatPermissionName(Permission permission) {
    final names = {
      Permission.manageCompany: 'Gerenciar Empresa',
      Permission.updateCompanySettings: 'Atualizar Configurações',
      Permission.deleteCompany: 'Deletar Empresa',
      Permission.inviteUsers: 'Convidar Usuários',
      Permission.removeUsers: 'Remover Usuários',
      Permission.updateUserRoles: 'Atualizar Cargos',
      Permission.viewUsers: 'Visualizar Usuários',
      Permission.createPredictions: 'Criar Predições',
      Permission.viewPredictions: 'Visualizar Predições',
      Permission.deletePredictions: 'Deletar Predições',
      Permission.exportPredictions: 'Exportar Predições',
      Permission.manageSubscription: 'Gerenciar Assinatura',
      Permission.viewBilling: 'Visualizar Faturamento',
      Permission.updatePaymentMethod: 'Atualizar Método de Pagamento',
      Permission.manageApiKeys: 'Gerenciar Chaves API',
      Permission.viewApiKeys: 'Visualizar Chaves API',
      Permission.viewReports: 'Visualizar Relatórios',
      Permission.exportReports: 'Exportar Relatórios',
      Permission.viewAnalytics: 'Visualizar Analytics',
    };
    return names[permission] ?? permission.name;
  }
}

/// Extensão para facilitar verificações de permissão
extension RoleExtensions on Role {
  bool canManageCompany() => hasPermission(Permission.manageCompany);
  bool canInviteUsers() => hasPermission(Permission.inviteUsers);
  bool canRemoveUsers() => hasPermission(Permission.removeUsers);
  bool canCreatePredictions() => hasPermission(Permission.createPredictions);
  bool canExportData() => hasPermission(Permission.exportPredictions);
  bool canManageSubscription() => hasPermission(Permission.manageSubscription);
  bool canViewAnalytics() => hasPermission(Permission.viewAnalytics);
  bool canManageApiKeys() => hasPermission(Permission.manageApiKeys);
}
