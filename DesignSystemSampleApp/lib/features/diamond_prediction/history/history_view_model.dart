import '../../../application/app_coordinator.dart';
import 'history_service.dart';

/// HistoryDelegate - Interface para eventos da tela de histórico
abstract class HistoryDelegate {
  /// Chamado quando usuário quer voltar
  void onBackRequested({required HistoryViewModel sender});
  
  /// Chamado para recarregar o histórico
  void onRefreshRequested({required HistoryViewModel sender});
  
  /// Chamado para limpar todo o histórico
  void onClearHistoryRequested({required HistoryViewModel sender});
  
  /// Chamado quando usuário toca em uma predição
  void onPredictionTapped({
    required HistoryViewModel sender,
    required Map<String, dynamic> prediction,
  });
}

/// HistoryViewModel - ViewModel para a tela de histórico
/// 
/// Gerencia o estado e exibição do histórico de predições.
class HistoryViewModel implements HistoryDelegate {
  final HistoryService service;
  final AppCoordinator coordinator;
  
  // Estado
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Callback para atualização da UI
  void Function()? onStateChanged;
  
  HistoryViewModel({
    required this.service,
    required this.coordinator,
  });
  
  // Getters
  List<Map<String, dynamic>> get predictions => _predictions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _predictions.isEmpty;
  int get count => _predictions.length;
  
  /// Carrega o histórico de predições
  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    _notifyStateChanged();
    
    try {
      _predictions = await service.getPredictions();
      _isLoading = false;
      _notifyStateChanged();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao carregar histórico: ${e.toString()}';
      _notifyStateChanged();
    }
  }
  
  /// Limpa todo o histórico
  Future<void> clearHistory() async {
    await service.clearHistory();
    _predictions = [];
    _notifyStateChanged();
    coordinator.showSuccess('Histórico limpo com sucesso');
  }
  
  // Implementação do HistoryDelegate
  
  @override
  void onBackRequested({required HistoryViewModel sender}) {
    coordinator.goBack();
  }
  
  @override
  void onRefreshRequested({required HistoryViewModel sender}) {
    loadHistory();
  }
  
  @override
  void onClearHistoryRequested({required HistoryViewModel sender}) {
    clearHistory();
  }
  
  @override
  void onPredictionTapped({
    required HistoryViewModel sender,
    required Map<String, dynamic> prediction,
  }) {
    // Pode expandir para mostrar detalhes
    final price = (prediction['predicted_price'] as num?)?.toDouble() ?? 0.0;
    coordinator.showInfo('Preço: \$${price.toStringAsFixed(2)}');
  }
  
  void _notifyStateChanged() {
    onStateChanged?.call();
  }
  
  /// Formata preço para exibição
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
  
  /// Formata data para exibição
  String formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }
  
  /// Limpa recursos
  void dispose() {
    onStateChanged = null;
  }
}
