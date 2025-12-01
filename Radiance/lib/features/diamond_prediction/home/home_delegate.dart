import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/models/user_model.dart';
abstract class HomeDelegate {
  Future<void> loadStats();
  void navigateToPrediction();
  void navigateToHistory();
  Future<void> logout();
  void onStatsLoaded({
    required int totalPredictions,
    required double averagePrice,
    PredictionHistoryModel? lastPrediction,
  });
  void onError(String message);
  UserModel? getCurrentUser();
}
