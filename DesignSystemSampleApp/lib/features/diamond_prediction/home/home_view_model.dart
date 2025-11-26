import '../../../application/app_coordinator.dart';
import 'home_service.dart';

/// HomeDelegate - Interface para eventos do Dashboard
/// 
/// Implementa o Delegate Pattern para capturar eventos da View.
abstract class HomeDelegate {
  /// Chamado quando usuário quer fazer nova predição
  void onNewPredictionRequested({required HomeViewModel sender});
  
  /// Chamado quando usuário quer ver histórico
  void onHistoryRequested({required HomeViewModel sender});
  
  /// Chamado quando usuário quer fazer logout
  void onLogoutRequested({required HomeViewModel sender});
  
  /// Chamado para recarregar dados do dashboard
  void onRefreshRequested({required HomeViewModel sender});
}

/// HomeViewModel - ViewModel para a tela Home/Dashboard
/// 
/// Gerencia o estado e lógica de apresentação do dashboard.
/// Implementa HomeDelegate para responder aos eventos.
class HomeViewModel implements HomeDelegate {
  final HomeService service;
  final AppCoordinator coordinator;
  
  // Dados do usuário
  final String userName;
  final String userEmail;
  
  // Estado do dashboard
  int _totalPredictions = 0;
  double _averagePrice = 0.0;
  Map<String, dynamic>? _lastPrediction;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Callback para atualização da UI
  void Function()? onStateChanged;
  
  HomeViewModel({
    required this.service,
    required this.coordinator,
    required this.userName,
    required this.userEmail,
  });
  
  // Getters
  int get totalPredictions => _totalPredictions;
  double get averagePrice => _averagePrice;
  Map<String, dynamic>? get lastPrediction => _lastPrediction;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _totalPredictions > 0;
  
  /// Carrega os dados do dashboard
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    _notifyStateChanged();
    
    try {
      final data = await service.loadDashboardData();
      
      _totalPredictions = data['total_predictions'] as int;
      _averagePrice = data['average_price'] as double;
      _lastPrediction = data['last_prediction'] as Map<String, dynamic>?;
      _isLoading = false;
      
      _notifyStateChanged();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
      _notifyStateChanged();
    }
  }
  
  // Implementação do HomeDelegate
  
  @override
  void onNewPredictionRequested({required HomeViewModel sender}) {
    coordinator.goToPrediction();
  }
  
  @override
  void onHistoryRequested({required HomeViewModel sender}) {
    coordinator.goToHistory();
  }
  
  @override
  void onLogoutRequested({required HomeViewModel sender}) {
    service.clearData();
    coordinator.logout();
  }
  
  @override
  void onRefreshRequested({required HomeViewModel sender}) {
    loadDashboardData();
  }
  
  void _notifyStateChanged() {
    onStateChanged?.call();
  }
  
  /// Formata preço para exibição
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
  
  /// Limpa recursos
  void dispose() {
    onStateChanged = null;
  }
}
