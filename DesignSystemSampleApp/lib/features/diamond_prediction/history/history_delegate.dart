import '../../../core/data/models/prediction_model.dart';

/// Delegate para a tela History - define as acoes que a View pode solicitar
abstract class HistoryDelegate {
  /// Carrega o historico (primeira pagina)
  Future<void> loadHistory();
  
  /// Carrega mais itens (proxima pagina)
  Future<void> loadMore();
  
  /// Atualiza o historico
  Future<void> refresh();
  
  /// Deleta uma predicao do historico
  Future<void> deletePrediction(int id);
  
  /// Volta para a tela anterior
  void navigateBack();
  
  /// Callback quando o historico foi carregado
  void onHistoryLoaded(List<PredictionHistoryModel> predictions, {bool hasMore});
  
  /// Callback quando ocorre erro
  void onError(String message);
  
  /// Callback quando uma predicao foi deletada
  void onPredictionDeleted(int id);
}
