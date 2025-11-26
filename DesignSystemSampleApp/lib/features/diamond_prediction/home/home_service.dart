/// HomeService - Serviço para dados do Dashboard
/// 
/// Responsável por buscar estatísticas e dados do dashboard.
/// Em produção, faria chamadas HTTP para uma API de backend.
class HomeService {
  // Armazena predições em memória para simulação
  final List<Map<String, dynamic>> _predictions = [];
  
  /// Adiciona uma predição ao histórico
  void addPrediction(Map<String, dynamic> prediction) {
    _predictions.insert(0, prediction);
  }
  
  /// Retorna todas as predições
  List<Map<String, dynamic>> getPredictions() {
    return List.from(_predictions);
  }
  
  /// Busca dados do dashboard
  /// 
  /// Retorna estatísticas como total de predições, preço médio, etc.
  Future<Map<String, dynamic>> loadDashboardData() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Calcula estatísticas
    final total = _predictions.length;
    double averagePrice = 0;
    Map<String, dynamic>? lastPrediction;
    
    if (_predictions.isNotEmpty) {
      final prices = _predictions
          .map((p) => (p['predicted_price'] as num?)?.toDouble() ?? 0.0)
          .toList();
      averagePrice = prices.reduce((a, b) => a + b) / prices.length;
      lastPrediction = _predictions.first;
    }
    
    return {
      'total_predictions': total,
      'average_price': averagePrice,
      'last_prediction': lastPrediction,
      'predictions': _predictions,
    };
  }
  
  /// Limpa todos os dados (logout)
  void clearData() {
    _predictions.clear();
  }
}

/// Singleton para manter o estado entre telas
class HomeServiceProvider {
  static final HomeServiceProvider _instance = HomeServiceProvider._internal();
  factory HomeServiceProvider() => _instance;
  HomeServiceProvider._internal();
  
  final HomeService service = HomeService();
}
