import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_audit_log.dart';
import '../../data/repositories/admin_audit_repository.dart';

class AdminAuditProvider with ChangeNotifier {
  final AdminAuditRepository _repository;

  AdminAuditProvider(this._repository);

  // State
  List<AdminAuditLog> _logs = [];
  AdminAuditLog? _selectedLog;
  AuditLogFilters _filters = const AuditLogFilters();
  AuditLogStats? _stats;
  
  bool _isLoading = false;
  String? _error;
  
  int _currentPage = 0;
  final int _pageSize = 50;
  bool _hasMoreLogs = true;
  int _totalLogs = 0;

  // Getters
  List<AdminAuditLog> get logs => _logs;
  AdminAuditLog? get selectedLog => _selectedLog;
  AuditLogFilters get filters => _filters;
  AuditLogStats? get stats => _stats;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreLogs => _hasMoreLogs;
  int get totalLogs => _totalLogs;
  int get currentPage => _currentPage;

  // Computed getters
  int get infoCount => _stats?.infoCount ?? 0;
  int get warningCount => _stats?.warningCount ?? 0;
  int get criticalCount => _stats?.criticalCount ?? 0;
  
  Map<AuditLogCategory, int> get logsByCategory => _stats?.logsByCategory ?? {};
  Map<String, int> get topUsers => _stats?.topUsers ?? {};
  Map<String, int> get topActions => _stats?.topActions ?? {};

  // Load logs with pagination
  Future<void> loadLogs({bool reset = false}) async {
    if (reset) {
      _currentPage = 0;
      _logs = [];
      _hasMoreLogs = true;
    }

    if (_isLoading || !_hasMoreLogs) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load logs
      final result = await _repository.getAuditLogs(
        filters: _filters,
        limit: _pageSize,
        offset: _currentPage * _pageSize,
      );

      result.fold(
        (failure) => throw Exception(failure.message),
        (newLogs) {
          if (reset) {
            _logs = newLogs;
          } else {
            _logs.addAll(newLogs);
          }
          
          _hasMoreLogs = newLogs.length == _pageSize;
          _currentPage++;
        },
      );

      // Load total count
      final countResult = await _repository.countLogs(filters: _filters);
      countResult.fold(
        (failure) => _totalLogs = _logs.length,
        (count) => _totalLogs = count,
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search logs
  Future<void> searchLogs(String query) async {
    _filters = _filters.copyWith(searchQuery: query);
    await loadLogs(reset: true);
  }

  // Apply filters
  Future<void> applyFilters(AuditLogFilters filters) async {
    _filters = filters;
    await loadLogs(reset: true);
  }

  // Clear specific filter
  Future<void> clearFilter(String filterName) async {
    _filters = _filters.clearFilter(filterName);
    await loadLogs(reset: true);
  }

  // Clear all filters
  Future<void> clearFilters() async {
    _filters = const AuditLogFilters();
    await loadLogs(reset: true);
  }

  // Load log details
  Future<void> loadLogDetails(String logId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getAuditLogById(logId);
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (log) {
        _selectedLog = log;
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load statistics
  Future<void> loadStats({DateTime? startDate, DateTime? endDate}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getAuditLogStats(
      startDate: startDate,
      endDate: endDate,
    );
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (stats) {
        _stats = stats;
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Export to CSV
  Future<String?> exportToCSV() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.exportToCSV(filters: _filters);
    
    return result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (csv) {
        _isLoading = false;
        notifyListeners();
        return csv;
      },
    );
  }

  // Delete old logs
  Future<int?> deleteOldLogs(DateTime beforeDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.deleteOldLogs(beforeDate);
    
    return result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (count) {
        _isLoading = false;
        notifyListeners();
        return count;
      },
    );
  }

  // Refresh
  Future<void> refresh() async {
    await Future.wait([
      loadLogs(reset: true),
      loadStats(),
    ]);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected log
  void clearSelectedLog() {
    _selectedLog = null;
    notifyListeners();
  }

  // Load more logs (pagination)
  Future<void> loadMore() async {
    if (!_isLoading && _hasMoreLogs) {
      await loadLogs(reset: false);
    }
  }
}
