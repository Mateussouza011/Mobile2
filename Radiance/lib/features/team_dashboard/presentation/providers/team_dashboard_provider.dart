import 'package:flutter/foundation.dart';
import '../../domain/entities/team_stats.dart';
import '../../data/repositories/team_stats_repository.dart';
import '../../../multi_tenant/presentation/providers/tenant_provider.dart';
import '../../../../core/error/failures.dart';

/// Provider para dashboard da equipe
class TeamDashboardProvider extends ChangeNotifier {
  final TeamStatsRepository _repository;
  final TenantProvider _tenantProvider;

  TeamStats? _teamStats;
  List<MemberActivity> _memberActivities = [];
  ResourceUsage? _resourceUsage;
  bool _isLoading = false;
  String? _error;
  int _selectedDays = 30;

  TeamDashboardProvider({
    required TeamStatsRepository repository,
    required TenantProvider tenantProvider,
  })  : _repository = repository,
        _tenantProvider = tenantProvider {
    _initialize();
  }

  // Getters
  TeamStats? get teamStats => _teamStats;
  List<MemberActivity> get memberActivities => _memberActivities;
  ResourceUsage? get resourceUsage => _resourceUsage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedDays => _selectedDays;

  List<MemberActivity> get topPerformers =>
      _memberActivities.take(5).toList();

  Future<void> _initialize() async {
    if (_tenantProvider.currentCompany != null) {
      await loadDashboard();
    }
  }

  /// Carrega todos os dados do dashboard
  Future<void> loadDashboard() async {
    final company = _tenantProvider.currentCompany;
    if (company == null) {
      _error = 'Nenhuma empresa selecionada';
      notifyListeners();
      return;
    }

    _setLoading(true);

    // Carregar em paralelo
    await Future.wait([
      _loadTeamStats(company.id),
      _loadMemberActivities(company.id),
      _loadResourceUsage(company.id),
    ]);

    _setLoading(false);
  }

  Future<void> _loadTeamStats(String companyId) async {
    final result = await _repository.getTeamStats(companyId);
    
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (stats) {
        _teamStats = stats;
        _error = null;
      },
    );
  }

  Future<void> _loadMemberActivities(String companyId) async {
    final result = await _repository.getMemberActivities(
      companyId,
      days: _selectedDays,
    );
    
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (activities) {
        _memberActivities = activities;
        _error = null;
      },
    );
  }

  Future<void> _loadResourceUsage(String companyId) async {
    final result = await _repository.getResourceUsage(companyId);
    
    result.fold(
      (failure) => _error = _getErrorMessage(failure),
      (usage) {
        _resourceUsage = usage;
        _error = null;
      },
    );
  }

  /// Muda o período de análise
  Future<void> changePeriod(int days) async {
    if (_selectedDays == days) return;
    
    _selectedDays = days;
    notifyListeners();

    final company = _tenantProvider.currentCompany;
    if (company != null) {
      await _loadMemberActivities(company.id);
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
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
    return 'Erro desconhecido';
  }
}
