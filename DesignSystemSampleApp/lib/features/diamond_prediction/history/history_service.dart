import '../home/home_service.dart';

/// HistoryService - Serviço para gerenciar histórico de predições
/// 
/// Utiliza o HomeService como fonte de dados compartilhada.
class HistoryService {
  final HomeService homeService;
  
  HistoryService({required this.homeService});
  
  /// Retorna todas as predições do histórico
  Future<List<Map<String, dynamic>>> getPredictions() async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 300));
    return homeService.getPredictions();
  }
  
  /// Remove uma predição do histórico por índice
  Future<void> removePrediction(int index) async {
    final predictions = homeService.getPredictions();
    if (index >= 0 && index < predictions.length) {
      predictions.removeAt(index);
    }
  }
  
  /// Limpa todo o histórico
  Future<void> clearHistory() async {
    homeService.clearData();
  }
}
