import '../../../core/data/models/prediction_model.dart';

/// Delegate para a tela de Prediction - define as acoes que a View pode solicitar
abstract class PredictionDelegate {
  /// Executa a predicao chamando a API
  Future<void> predict();
  
  /// Salva a predicao no historico local
  Future<void> savePrediction();
  
  /// Limpa o resultado e volta para o formulario
  void clearResult();
  
  /// Reseta o formulario para os valores padrao
  void resetForm();
  
  /// Volta para a tela anterior
  void navigateBack();
  
  /// Callback quando a predicao foi bem sucedida
  void onPredictionSuccess(PredictionResponse response);
  
  /// Callback quando ocorre erro
  void onError(String message);
  
  /// Callback quando a predicao foi salva
  void onPredictionSaved();
}
