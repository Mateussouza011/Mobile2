import '../../../core/data/models/prediction_model.dart';
abstract class PredictionDelegate {
  Future<void> predict();
  Future<void> savePrediction();
  void clearResult();
  void resetForm();
  void navigateBack();
  void onPredictionSuccess(PredictionResponse response);
  void onError(String message);
  void onPredictionSaved();
}
