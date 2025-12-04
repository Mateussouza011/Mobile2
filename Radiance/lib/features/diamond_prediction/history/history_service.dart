import 'history_delegate.dart';
import 'history_view_model.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

class HistoryService implements HistoryDelegate {
  final HistoryViewModel viewModel;
  final PredictionHistoryRepository historyRepository;
  final AuthRepository authRepository;
  final DiamondCoordinator _coordinator;

  HistoryService({
    required this.viewModel,
    required this.historyRepository,
    required this.authRepository,
    required DiamondCoordinator coordinator,
  }) : _coordinator = coordinator;

  int? get _userId => authRepository.currentUser?.id;

  @override
  Future<void> loadHistory() async {
    if (_userId == null) {
      onError('User not authenticated');
      return;
    }

    viewModel.setLoading(true);
    viewModel.clearError();
    viewModel.setCurrentPage(1);

    try {
      final predictions = await historyRepository.getPaginatedPredictions(
        userId: _userId!,
        page: 1,
        pageSize: viewModel.pageSize,
      );

      final hasMore = predictions.length >= viewModel.pageSize;
      onHistoryLoaded(predictions, hasMore: hasMore);
    } catch (e) {
      onError('Error loading history: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  Future<void> loadMore() async {
    if (_userId == null || !viewModel.hasMore || viewModel.isLoading) return;

    viewModel.setLoading(true);

    try {
      final nextPage = viewModel.currentPage + 1;
      final predictions = await historyRepository.getPaginatedPredictions(
        userId: _userId!,
        page: nextPage,
        pageSize: viewModel.pageSize,
      );

      if (predictions.isNotEmpty) {
        viewModel.setCurrentPage(nextPage);
        viewModel.setPredictions(predictions, append: true);
        viewModel.setHasMore(predictions.length >= viewModel.pageSize);
      } else {
        viewModel.setHasMore(false);
      }
    } catch (e) {
      onError('Error loading more items: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  Future<void> refresh() async {
    viewModel.reset();
    await loadHistory();
  }

  @override
  Future<void> deletePrediction(int id) async {
    try {
      await historyRepository.deletePrediction(id);
      onPredictionDeleted(id);
    } catch (e) {
      onError('Error deleting prediction: ${e.toString()}');
    }
  }

  @override
  void navigateBack() {
    _coordinator.goToHome();
  }

  @override
  void onHistoryLoaded(List<PredictionHistoryModel> predictions, {bool hasMore = true}) {
    viewModel.setPredictions(predictions);
    viewModel.setHasMore(hasMore);
  }

  @override
  void onError(String message) {
    viewModel.setError(message);
  }

  @override
  void onPredictionDeleted(int id) {
    viewModel.removePrediction(id);
    _coordinator.showSuccessMessage('Prediction removed successfully!');
  }
}
