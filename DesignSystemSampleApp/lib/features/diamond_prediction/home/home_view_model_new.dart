import 'package:flutter/material.dart';

/// Delegate para a Home/Dashboard
abstract class HomeViewDelegate {
  void onNewPredictionTapped();
  void onHistoryTapped();
  void onProfileTapped();
  void onLogoutTapped();
  void onRecentPredictionTapped(PredictionSummary prediction);
}

/// ViewModel para a Home/Dashboard
/// 
/// Gerencia estado e lógica da home seguindo MVVM + Delegate
class HomeViewModel extends ChangeNotifier {
  final HomeViewDelegate delegate;
  
  HomeViewModel({required this.delegate}) {
    _loadData();
  }
  
  // Estado
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  String _userName = 'Usuário';
  String get userName => _userName;
  
  // Estatísticas
  int _totalPredictions = 0;
  int get totalPredictions => _totalPredictions;
  
  double _averagePrice = 0;
  double get averagePrice => _averagePrice;
  
  double _highestPrice = 0;
  double get highestPrice => _highestPrice;
  
  // Predições recentes
  List<PredictionSummary> _recentPredictions = [];
  List<PredictionSummary> get recentPredictions => _recentPredictions;
  
  /// Carrega dados iniciais
  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    _userName = 'Demo';
    _totalPredictions = 12;
    _averagePrice = 4250.00;
    _highestPrice = 15890.00;
    
    _recentPredictions = [
      PredictionSummary(
        id: '1',
        carat: 1.2,
        cut: 'Ideal',
        predictedPrice: 8450.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PredictionSummary(
        id: '2',
        carat: 0.8,
        cut: 'Premium',
        predictedPrice: 4200.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      PredictionSummary(
        id: '3',
        carat: 2.1,
        cut: 'Very Good',
        predictedPrice: 15890.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Atualiza dados
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _loadData();
  }
  
  // Ações de navegação
  void newPrediction() => delegate.onNewPredictionTapped();
  void viewHistory() => delegate.onHistoryTapped();
  void openProfile() => delegate.onProfileTapped();
  void logout() => delegate.onLogoutTapped();
  void openPrediction(PredictionSummary prediction) => 
      delegate.onRecentPredictionTapped(prediction);
  
  /// Formata valor em moeda
  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }
  
  /// Formata data relativa
  String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Modelo para resumo de predição
class PredictionSummary {
  final String id;
  final double carat;
  final String cut;
  final double predictedPrice;
  final DateTime date;
  
  const PredictionSummary({
    required this.id,
    required this.carat,
    required this.cut,
    required this.predictedPrice,
    required this.date,
  });
}
