import '../../../core/data/models/prediction_model.dart';
abstract class HistoryDelegate {
  Future<void> loadHistory();
  Future<void> loadMore();
  Future<void> refresh();
  Future<void> deletePrediction(int id);
  void navigateBack();
  void onHistoryLoaded(List<PredictionHistoryModel> predictions, {bool hasMore});
  void onError(String message);
  void onPredictionDeleted(int id);
}
