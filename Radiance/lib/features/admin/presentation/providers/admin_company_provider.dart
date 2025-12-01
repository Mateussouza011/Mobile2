import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_company_stats.dart';
import '../../data/repositories/admin_company_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';

/// Provider para administração de empresas
class AdminCompanyProvider extends ChangeNotifier {
  final AdminCompanyRepository _repository;

  List<AdminCompanyStats> _companies = [];
  AdminCompanyStats? _selectedCompany;
  CompanyFilters _filters = const CompanyFilters();
  Map<String, dynamic>? _systemStats;
  bool _isLoading = false;
  String? _error;

  AdminCompanyProvider({required AdminCompanyRepository repository})
      : _repository = repository;

  // Getters
  List<AdminCompanyStats> get companies => _companies;
  AdminCompanyStats? get selectedCompany => _selectedCompany;
  CompanyFilters get filters => _filters;
  Map<String, dynamic>? get systemStats => _systemStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalCompanies => _companies.length;
  int get activeCompanies =>
      _companies.where((c) => c.company.isActive).length;
  int get suspendedCompanies =>
      _companies.where((c) => !c.company.isActive).length;
  int get companiesNeedingAttention =>
      _companies.where((c) => c.needsAttention).length;

  List<AdminCompanyStats> get companiesByTier {
    final sorted = List<AdminCompanyStats>.from(_companies);
    sorted.sort((a, b) {
      final aTier = a.subscription?.tier ?? SubscriptionTier.free;
      final bTier = b.subscription?.tier ?? SubscriptionTier.free;
      return bTier.index.compareTo(aTier.index);
    });
    return sorted;
  }

  /// Carrega todas as empresas
  Future<void> loadCompanies() async {
    _setLoading(true);

    final result = await _repository.getAllCompanies(filters: _filters);

    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _companies = [];
      },
      (companies) {
        _companies = companies;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Aplica filtros
  Future<void> applyFilters(CompanyFilters filters) async {
    _filters = filters;
    await loadCompanies();
  }

  /// Limpa filtros
  Future<void> clearFilters() async {
    _filters = const CompanyFilters();
    await loadCompanies();
  }

  /// Pesquisa empresas por texto
  Future<void> searchCompanies(String query) async {
    _filters = _filters.copyWith(searchQuery: query);
    await loadCompanies();
  }

  /// Carrega detalhes de uma empresa
  Future<void> loadCompanyDetails(String companyId) async {
    _setLoading(true);

    final result = await _repository.getCompanyDetails(companyId);

    result.fold(
      (failure) {
        _error = _getErrorMessage(failure);
        _selectedCompany = null;
      },
      (company) {
        _selectedCompany = company;
        _error = null;
      },
    );

    _setLoading(false);
  }

  /// Suspende uma empresa
  Future<bool> suspendCompany(String companyId) async {
    _setLoading(true);

    final result = await _repository.suspendCompany(companyId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        // Atualizar lista local
        final index = _companies.indexWhere((c) => c.company.id == companyId);
        if (index != -1) {
          final updated = _companies[index].company.copyWith(isActive: false);
          _companies[index] = AdminCompanyStats(
            company: updated,
            subscription: _companies[index].subscription,
            totalMembers: _companies[index].totalMembers,
            activeMembers: _companies[index].activeMembers,
            totalPredictions: _companies[index].totalPredictions,
            predictionsThisMonth: _companies[index].predictionsThisMonth,
            lastActivity: _companies[index].lastActivity,
            totalRevenue: _companies[index].totalRevenue,
            createdAt: _companies[index].createdAt,
          );
        }

        if (_selectedCompany?.company.id == companyId) {
          _selectedCompany = null;
        }

        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Ativa uma empresa
  Future<bool> activateCompany(String companyId) async {
    _setLoading(true);

    final result = await _repository.activateCompany(companyId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        // Atualizar lista local
        final index = _companies.indexWhere((c) => c.company.id == companyId);
        if (index != -1) {
          final updated = _companies[index].company.copyWith(isActive: true);
          _companies[index] = AdminCompanyStats(
            company: updated,
            subscription: _companies[index].subscription,
            totalMembers: _companies[index].totalMembers,
            activeMembers: _companies[index].activeMembers,
            totalPredictions: _companies[index].totalPredictions,
            predictionsThisMonth: _companies[index].predictionsThisMonth,
            lastActivity: _companies[index].lastActivity,
            totalRevenue: _companies[index].totalRevenue,
            createdAt: _companies[index].createdAt,
          );
        }

        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Exclui uma empresa
  Future<bool> deleteCompany(String companyId) async {
    _setLoading(true);

    final result = await _repository.deleteCompany(companyId);

    bool success = false;
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (_) {
        _companies.removeWhere((c) => c.company.id == companyId);
        
        if (_selectedCompany?.company.id == companyId) {
          _selectedCompany = null;
        }

        _error = null;
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Carrega estatísticas gerais do sistema
  Future<void> loadSystemStats() async {
    final result = await _repository.getSystemStats();

    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (stats) {
        _systemStats = stats;
        _error = null;
      },
    );

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedCompany() {
    _selectedCompany = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is NetworkFailure) return 'Erro de conexão';
    if (failure is DatabaseFailure) return failure.message;
    if (failure is ValidationFailure) return failure.message;
    return 'Erro desconhecido';
  }
}
