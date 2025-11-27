import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_user_stats.dart';
import '../../data/repositories/admin_user_repository.dart';

class AdminUserProvider extends ChangeNotifier {
  final AdminUserRepository _repository;

  List<AdminUserStats> _users = [];
  AdminUserStats? _selectedUser;
  UserFilters _filters = const UserFilters();
  Map<String, dynamic>? _systemStats;
  List<UserActivityLog> _activityLogs = [];
  bool _isLoading = false;
  String? _error;

  AdminUserProvider(this._repository);

  // Getters
  List<AdminUserStats> get users => _users;
  AdminUserStats? get selectedUser => _selectedUser;
  UserFilters get filters => _filters;
  Map<String, dynamic>? get systemStats => _systemStats;
  List<UserActivityLog> get activityLogs => _activityLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalUsers => _users.length;
  int get activeUsers => _users.where((u) => u.isActive).length;
  int get disabledUsers => _users.where((u) => !u.isActive).length;
  int get usersNeedingAttention => _users.where((u) => u.needsAttention).length;

  // Agrupar por empresa
  Map<String, List<AdminUserStats>> get usersByCompany {
    final grouped = <String, List<AdminUserStats>>{};
    for (final user in _users) {
      for (final company in user.companies) {
        if (!grouped.containsKey(company.companyId)) {
          grouped[company.companyId] = [];
        }
        grouped[company.companyId]!.add(user);
      }
    }
    return grouped;
  }

  /// Carrega todos os usuários
  Future<void> loadUsers() async {
    _setLoading(true);
    _error = null;

    final result = await _repository.getAllUsers(_filters);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _users = [];
      },
      (users) {
        _users = users;
      },
    );

    _setLoading(false);
  }

  /// Busca usuários por texto
  Future<void> searchUsers(String query) async {
    _filters = _filters.copyWith(searchQuery: query.isEmpty ? null : query);
    await loadUsers();
  }

  /// Aplica filtros
  Future<void> applyFilters(UserFilters filters) async {
    _filters = filters;
    await loadUsers();
  }

  /// Limpa filtros
  Future<void> clearFilters() async {
    _filters = const UserFilters();
    await loadUsers();
  }

  /// Carrega detalhes de um usuário
  Future<void> loadUserDetails(String userId) async {
    _setLoading(true);
    _error = null;

    final result = await _repository.getUserDetails(userId);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _selectedUser = null;
      },
      (user) {
        _selectedUser = user;
      },
    );

    _setLoading(false);
  }

  /// Desativa usuário
  Future<bool> disableUser(String userId) async {
    _error = null;

    final result = await _repository.disableUser(userId);

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Atualizar localmente
        final index = _users.indexWhere((u) => u.user.id == userId);
        if (index != -1) {
          _users[index] = AdminUserStats(
            user: _users[index].user.copyWith(isActive: false),
            companies: _users[index].companies,
            totalPredictions: _users[index].totalPredictions,
            predictionsThisMonth: _users[index].predictionsThisMonth,
            lastActivity: _users[index].lastActivity,
            lastLogin: _users[index].lastLogin,
            isActive: false,
            createdAt: _users[index].createdAt,
          );
        }

        if (_selectedUser?.user.id == userId) {
          _selectedUser = _users[index];
        }

        notifyListeners();
        return true;
      },
    );
  }

  /// Reativa usuário
  Future<bool> enableUser(String userId) async {
    _error = null;

    final result = await _repository.enableUser(userId);

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Atualizar localmente
        final index = _users.indexWhere((u) => u.user.id == userId);
        if (index != -1) {
          _users[index] = AdminUserStats(
            user: _users[index].user.copyWith(isActive: true),
            companies: _users[index].companies,
            totalPredictions: _users[index].totalPredictions,
            predictionsThisMonth: _users[index].predictionsThisMonth,
            lastActivity: _users[index].lastActivity,
            lastLogin: _users[index].lastLogin,
            isActive: true,
            createdAt: _users[index].createdAt,
          );
        }

        if (_selectedUser?.user.id == userId) {
          _selectedUser = _users[index];
        }

        notifyListeners();
        return true;
      },
    );
  }

  /// Reseta senha
  Future<String?> resetPassword(String userId) async {
    _error = null;

    final result = await _repository.resetPassword(userId);

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return null;
      },
      (tempPassword) {
        notifyListeners();
        return tempPassword;
      },
    );
  }

  /// Carrega logs de atividade
  Future<void> loadActivityLogs(String userId, {int days = 30}) async {
    _setLoading(true);
    _error = null;

    final result = await _repository.getUserActivityLogs(userId, days: days);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _activityLogs = [];
      },
      (logs) {
        _activityLogs = logs;
      },
    );

    _setLoading(false);
  }

  /// Carrega estatísticas do sistema
  Future<void> loadSystemStats() async {
    final result = await _repository.getSystemUserStats();

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _systemStats = null;
      },
      (stats) {
        _systemStats = stats;
      },
    );

    notifyListeners();
  }

  /// Limpa erro
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Limpa usuário selecionado
  void clearSelectedUser() {
    _selectedUser = null;
    _activityLogs = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapFailureToMessage(dynamic failure) {
    return failure.toString();
  }
}
