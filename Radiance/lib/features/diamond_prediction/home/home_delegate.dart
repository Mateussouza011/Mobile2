import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/models/user_model.dart';

/// Delegate para a tela Home - define as ações que a View pode solicitar
abstract class HomeDelegate {
  /// Carrega as estatísticas do usuário
  Future<void> loadStats();
  
  /// Navega para a tela de nova predição
  void navigateToPrediction();
  
  /// Navega para o histórico
  void navigateToHistory();
  
  /// Faz logout do usuário
  Future<void> logout();
  
  /// Callback quando as estatísticas são carregadas
  void onStatsLoaded({
    required int totalPredictions,
    required double averagePrice,
    PredictionHistoryModel? lastPrediction,
  });
  
  /// Callback quando ocorre erro
  void onError(String message);
  
  /// Retorna o usuário atual
  UserModel? getCurrentUser();
}
