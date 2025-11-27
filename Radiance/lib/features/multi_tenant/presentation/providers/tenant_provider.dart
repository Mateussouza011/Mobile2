import 'package:flutter/foundation.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/company_user.dart';
import '../../data/repositories/company_repository.dart';
import '../../../../core/error/failures.dart';

/// Provider que gerencia o contexto multi-tenant da aplicação
/// Mantém informações sobre a empresa atual, role do usuário e permissões
class TenantProvider extends ChangeNotifier {
  final CompanyRepository _companyRepository;

  Company? _currentCompany;
  Role? _currentRole;
  Subscription? _currentSubscription;
  CompanyUser? _currentCompanyUser;
  List<Company> _userCompanies = [];

  TenantProvider(this._companyRepository);

  // ============================================
  // Getters
  // ============================================

  Company? get currentCompany => _currentCompany;
  Role? get currentRole => _currentRole;
  Subscription? get currentSubscription => _currentSubscription;
  CompanyUser? get currentCompanyUser => _currentCompanyUser;
  List<Company> get userCompanies => _userCompanies;

  bool get hasActiveCompany => _currentCompany != null;
  bool get hasActiveSubscription => _currentSubscription?.canUseFeatures ?? false;
  
  String? get currentCompanyId => _currentCompany?.id;
  String? get currentRoleId => _currentRole?.id;

  /// Verifica se o usuário é owner da empresa atual
  bool get isOwner => _currentRole?.type == RoleType.owner;

  /// Verifica se o usuário é admin ou owner
  bool get isAdminOrOwner => 
      _currentRole?.type == RoleType.owner || 
      _currentRole?.type == RoleType.admin;

  // ============================================
  // Métodos de carregamento
  // ============================================

  /// Carrega as empresas do usuário
  Future<void> loadUserCompanies(String userId) async {
    final result = await _companyRepository.getUserCompanies(userId);
    
    result.fold(
      (failure) {
        debugPrint('Erro ao carregar empresas: ${failure.message}');
        _userCompanies = [];
      },
      (companies) {
        _userCompanies = companies;
      },
    );
    
    notifyListeners();
  }

  /// Define a empresa atual e carrega seus dados
  Future<Failure?> setCurrentCompany(
    String companyId,
    String userId,
  ) async {
    // Buscar empresa
    final companyResult = await _companyRepository.getCompanyById(companyId);
    if (companyResult.isLeft()) {
      return companyResult.fold((l) => l, (r) => null);
    }

    _currentCompany = companyResult.fold((l) => null, (r) => r);

    // Buscar assinatura
    final subscriptionResult = await _companyRepository.getCompanySubscription(companyId);
    _currentSubscription = subscriptionResult.fold((l) => null, (r) => r);

    // Buscar relação usuário-empresa
    final membersResult = await _companyRepository.getCompanyMembers(companyId);
    if (membersResult.isRight()) {
      _currentCompanyUser = membersResult.fold(
        (l) => null,
        (members) => members.firstWhere(
          (m) => m.userId == userId,
          orElse: () => members.first,
        ),
      );

      // Carregar role
      if (_currentCompanyUser != null) {
        _currentRole = _getRoleById(_currentCompanyUser!.roleId);
      }
    }

    notifyListeners();
    return null;
  }

  /// Limpa o contexto da empresa atual
  void clearCurrentCompany() {
    _currentCompany = null;
    _currentRole = null;
    _currentSubscription = null;
    _currentCompanyUser = null;
    notifyListeners();
  }

  /// Troca para outra empresa do usuário
  Future<Failure?> switchCompany(String companyId, String userId) async {
    return await setCurrentCompany(companyId, userId);
  }

  // ============================================
  // Verificações de permissão
  // ============================================

  /// Verifica se o usuário tem uma permissão específica
  bool hasPermission(Permission permission) {
    return _currentRole?.hasPermission(permission) ?? false;
  }

  /// Verifica se o usuário tem todas as permissões
  bool hasAllPermissions(List<Permission> permissions) {
    return _currentRole?.hasAllPermissions(permissions) ?? false;
  }

  /// Verifica se o usuário tem alguma das permissões
  bool hasAnyPermission(List<Permission> permissions) {
    return _currentRole?.hasAnyPermission(permissions) ?? false;
  }

  // ============================================
  // Verificações de limites de assinatura
  // ============================================

  /// Verifica se pode criar mais predições no mês
  bool canCreatePrediction(int currentMonthPredictions) {
    if (_currentSubscription == null) return false;
    
    final limits = _currentSubscription!.limits;
    if (limits.hasUnlimitedPredictions) return true;
    
    return currentMonthPredictions < limits.maxPredictionsPerMonth;
  }

  /// Verifica se pode adicionar mais usuários
  bool canAddUser(int currentUserCount) {
    if (_currentSubscription == null) return false;
    
    final limits = _currentSubscription!.limits;
    if (limits.hasUnlimitedUsers) return true;
    
    return currentUserCount < limits.maxUsers;
  }

  /// Verifica se tem acesso a feature baseada na assinatura
  bool hasFeatureAccess(String feature) {
    if (_currentSubscription == null) return false;
    
    final limits = _currentSubscription!.limits;
    
    switch (feature) {
      case 'api':
        return limits.hasApiAccess;
      case 'export':
        return limits.hasExportFeatures;
      case 'analytics':
        return limits.hasAdvancedAnalytics;
      case 'whitelabel':
        return limits.hasWhiteLabel;
      case 'priority_support':
        return limits.hasPrioritySupport;
      default:
        return false;
    }
  }

  /// Retorna informações sobre o limite de predições
  Map<String, dynamic> getPredictionLimitInfo(int currentMonthPredictions) {
    if (_currentSubscription == null) {
      return {
        'canCreate': false,
        'current': 0,
        'max': 0,
        'remaining': 0,
        'unlimited': false,
        'percentage': 0.0,
      };
    }

    final limits = _currentSubscription!.limits;
    final unlimited = limits.hasUnlimitedPredictions;
    final max = limits.maxPredictionsPerMonth;
    final remaining = unlimited ? -1 : (max - currentMonthPredictions);
    final percentage = unlimited ? 0.0 : (currentMonthPredictions / max);

    return {
      'canCreate': unlimited || remaining > 0,
      'current': currentMonthPredictions,
      'max': max,
      'remaining': remaining,
      'unlimited': unlimited,
      'percentage': percentage,
    };
  }

  // ============================================
  // Métodos auxiliares
  // ============================================

  Role _getRoleById(String roleId) {
    // Buscar em roles padrão
    final defaultRole = Role.defaultRoles.where((r) => r.id == roleId).firstOrNull;
    if (defaultRole != null) return defaultRole;

    // Se não encontrar, retornar viewer como fallback
    return Role.viewer;
  }

  /// Atualiza a assinatura (útil após mudança de plano)
  Future<void> refreshSubscription() async {
    if (_currentCompany == null) return;

    final result = await _companyRepository.getCompanySubscription(_currentCompany!.id);
    _currentSubscription = result.fold((l) => null, (r) => r);
    notifyListeners();
  }

  /// Atualiza os dados da empresa atual
  Future<void> refreshCompany() async {
    if (_currentCompany == null) return;

    final result = await _companyRepository.getCompanyById(_currentCompany!.id);
    _currentCompany = result.fold((l) => null, (r) => r);
    notifyListeners();
  }
}
