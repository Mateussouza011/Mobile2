import 'home_delegate.dart';
import 'home_view_model.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

class HomeService implements HomeDelegate {
  final HomeViewModel viewModel;
  final AuthRepository authRepository;
  final PredictionHistoryRepository historyRepository;
  final DiamondCoordinator coordinator;

  HomeService({
    required this.viewModel,
    required this.authRepository,
    required this.historyRepository,
    required this.coordinator,
  });

  @override
  Future<void> loadStats() async {
    viewModel.setLoading(true);
    viewModel.clearError();

    try {
      final user = getCurrentUser();
      if (user == null || user.id == null) {
        onError('User not authenticated');
        return;
      }

      final userId = user.id!;
      final results = await Future.wait([
        historyRepository.countPredictionsForUser(userId),
        historyRepository.getAveragePrice(userId),
        historyRepository.getLastPrediction(userId),
      ]);

      onStatsLoaded(
        totalPredictions: results[0] as int,
        averagePrice: results[1] as double,
        lastPrediction: results[2] as PredictionHistoryModel?,
      );
    } catch (e) {
      onError('Failed to load statistics: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void navigateToPrediction() {
    coordinator.goToPrediction();
  }

  @override
  void navigateToHistory() {
    coordinator.goToHistory();
  }

  @override
  Future<void> logout() async {
    try {
      await authRepository.logout();
      coordinator.goToLogin();
    } catch (e) {
      onError('Failed to logout: ${e.toString()}');
    }
  }

  @override
  void onStatsLoaded({
    required int totalPredictions,
    required double averagePrice,
    PredictionHistoryModel? lastPrediction,
  }) {
    viewModel.setStats(
      totalPredictions: totalPredictions,
      averagePrice: averagePrice,
      lastPrediction: lastPrediction,
    );
  }

  @override
  void onError(String message) {
    viewModel.setError(message);
  }

  @override
  UserModel? getCurrentUser() {
    return authRepository.currentUser;
  }
}
