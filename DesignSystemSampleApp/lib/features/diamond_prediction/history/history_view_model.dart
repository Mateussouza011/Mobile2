import 'package:flutter/material.dart';

/// Delegate para a tela de History
abstract class HistoryViewDelegate {
  void onBackTapped();
  void onPredictionTapped(HistoryItem item);
  void onDeleteTapped(HistoryItem item);
  void onClearAllTapped();
}

/// ViewModel para a tela de History
/// 
/// Gerencia estado e lógica do histórico seguindo MVVM + Delegate
class HistoryViewModel extends ChangeNotifier {
  final HistoryViewDelegate delegate;
  
  HistoryViewModel({required this.delegate}) {
    _loadHistory();
  }
  
  // Estado
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  List<HistoryItem> _items = [];
  List<HistoryItem> get items => _items;
  
  bool get isEmpty => _items.isEmpty;
  
  // Filtro
  String _filter = 'all';
  String get filter => _filter;
  
  List<HistoryItem> get filteredItems {
    if (_filter == 'all') return _items;
    
    final now = DateTime.now();
    return _items.where((item) {
      final difference = now.difference(item.date);
      switch (_filter) {
        case 'today':
          return difference.inDays == 0;
        case 'week':
          return difference.inDays <= 7;
        case 'month':
          return difference.inDays <= 30;
        default:
          return true;
      }
    }).toList();
  }
  
  /// Carrega histórico
  Future<void> _loadHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    _items = [
      HistoryItem(
        id: '1',
        carat: 1.21,
        cut: 'Ideal',
        color: 'D',
        clarity: 'IF',
        predictedPrice: 12450.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      HistoryItem(
        id: '2',
        carat: 0.82,
        cut: 'Premium',
        color: 'E',
        clarity: 'VVS1',
        predictedPrice: 4200.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      HistoryItem(
        id: '3',
        carat: 2.15,
        cut: 'Very Good',
        color: 'F',
        clarity: 'VS1',
        predictedPrice: 15890.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      HistoryItem(
        id: '4',
        carat: 0.55,
        cut: 'Good',
        color: 'G',
        clarity: 'SI1',
        predictedPrice: 1850.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      HistoryItem(
        id: '5',
        carat: 1.75,
        cut: 'Ideal',
        color: 'D',
        clarity: 'VVS2',
        predictedPrice: 18500.00,
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Atualiza filtro
  void updateFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }
  
  /// Remove item
  void deleteItem(HistoryItem item) {
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }
  
  /// Limpa todo histórico
  void clearAll() {
    _items.clear();
    notifyListeners();
  }
  
  // Ações de navegação
  void goBack() => delegate.onBackTapped();
  void openItem(HistoryItem item) => delegate.onPredictionTapped(item);
  void confirmDelete(HistoryItem item) => delegate.onDeleteTapped(item);
  void confirmClearAll() => delegate.onClearAllTapped();
  
  /// Formata preço
  String formatPrice(double value) {
    return '\$${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }
  
  /// Formata data
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}

/// Modelo de item do histórico
class HistoryItem {
  final String id;
  final double carat;
  final String cut;
  final String color;
  final String clarity;
  final double predictedPrice;
  final DateTime date;
  
  const HistoryItem({
    required this.id,
    required this.carat,
    required this.cut,
    required this.color,
    required this.clarity,
    required this.predictedPrice,
    required this.date,
  });
}
