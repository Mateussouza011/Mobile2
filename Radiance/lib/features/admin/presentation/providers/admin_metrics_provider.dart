import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_metrics_stats.dart';
import '../../data/repositories/admin_metrics_repository.dart';

class AdminMetricsProvider with ChangeNotifier {
  final AdminMetricsRepository _repository;

  AdminMetricsProvider(this._repository);

  // State
  SystemMetrics? _systemMetrics;
  RevenueMetrics? _revenueMetrics;
  UserGrowthMetrics? _userGrowthMetrics;
  TierDistribution? _tierDistribution;
  UsageMetrics? _usageMetrics;
  SystemHealthMetrics? _healthMetrics;
  
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  // Getters
  SystemMetrics? get systemMetrics => _systemMetrics;
  RevenueMetrics? get revenueMetrics => _revenueMetrics;
  UserGrowthMetrics? get userGrowthMetrics => _userGrowthMetrics;
  TierDistribution? get tierDistribution => _tierDistribution;
  UsageMetrics? get usageMetrics => _usageMetrics;
  SystemHealthMetrics? get healthMetrics => _healthMetrics;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;

  // Computed getters
  bool get hasData => _systemMetrics != null;
  
  int get totalUsers => _systemMetrics?.totalUsers ?? 0;
  int get activeUsers => _systemMetrics?.activeUsers ?? 0;
  int get totalCompanies => _systemMetrics?.totalCompanies ?? 0;
  double get totalRevenue => _systemMetrics?.totalRevenue ?? 0;
  double get mrr => _systemMetrics?.monthlyRecurringRevenue ?? 0;
  double get arpu => _systemMetrics?.averageRevenuePerUser ?? 0;
  double get healthScore => _systemMetrics?.systemHealthScore ?? 0;
  
  int get criticalAlerts => _healthMetrics?.criticalIssues ?? 0;
  int get warnings => _healthMetrics?.warnings ?? 0;
  
  double get revenueGrowth => _revenueMetrics?.revenueGrowthRate ?? 0;
  double get userGrowth => _userGrowthMetrics?.signupGrowthRate ?? 0;
  double get usageGrowth => _usageMetrics?.predictionsGrowthRate ?? 0;

  // Load all metrics at once
  Future<void> loadAllMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all metrics in parallel
      final systemResult = await _repository.getSystemMetrics();
      final revenueResult = await _repository.getRevenueMetrics();
      final userGrowthResult = await _repository.getUserGrowthMetrics();
      final tierResult = await _repository.getTierDistribution();
      final usageResult = await _repository.getUsageMetrics();
      final healthResult = await _repository.getSystemHealthMetrics();

      // System metrics
      systemResult.fold(
        (failure) => throw Exception(failure.message),
        (metrics) => _systemMetrics = metrics,
      );

      // Revenue metrics
      revenueResult.fold(
        (failure) => throw Exception(failure.message),
        (metrics) => _revenueMetrics = metrics,
      );

      // User growth metrics
      userGrowthResult.fold(
        (failure) => throw Exception(failure.message),
        (metrics) => _userGrowthMetrics = metrics,
      );

      // Tier distribution
      tierResult.fold(
        (failure) => throw Exception(failure.message),
        (distribution) => _tierDistribution = distribution,
      );

      // Usage metrics
      usageResult.fold(
        (failure) => throw Exception(failure.message),
        (metrics) => _usageMetrics = metrics,
      );

      // Health metrics
      healthResult.fold(
        (failure) => throw Exception(failure.message),
        (metrics) => _healthMetrics = metrics,
      );

      _lastUpdated = DateTime.now();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load specific metric category
  Future<void> loadSystemMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getSystemMetrics();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (metrics) {
        _systemMetrics = metrics;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadRevenueMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getRevenueMetrics();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (metrics) {
        _revenueMetrics = metrics;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadUserGrowthMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getUserGrowthMetrics();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (metrics) {
        _userGrowthMetrics = metrics;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadTierDistribution() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getTierDistribution();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (distribution) {
        _tierDistribution = distribution;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadUsageMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getUsageMetrics();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (metrics) {
        _usageMetrics = metrics;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadHealthMetrics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getSystemHealthMetrics();
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (metrics) {
        _healthMetrics = metrics;
        _lastUpdated = DateTime.now();
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Refresh all data
  Future<void> refresh() async {
    await loadAllMetrics();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _systemMetrics = null;
    _revenueMetrics = null;
    _userGrowthMetrics = null;
    _tierDistribution = null;
    _usageMetrics = null;
    _healthMetrics = null;
    _error = null;
    _lastUpdated = null;
    notifyListeners();
  }
}
