import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'history_delegate.dart';
import 'history_view_model.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';
class HistoryService implements HistoryDelegate {
  final HistoryViewModel viewModel;
  final PredictionHistoryRepository historyRepository;
  final AuthRepository authRepository;
  final BuildContext context;

  HistoryService({
    required this.viewModel,
    required this.historyRepository,
    required this.authRepository,
    required this.context,
  });

  int? get _userId => authRepository.currentUser?.id;

  @override
  Future<void> loadHistory() async {
    if (_userId == null) {
      onError('Usuario nao autenticado');
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
      onError('Erro ao carregar historico: ${e.toString()}');
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
      onError('Erro ao carregar mais itens: ${e.toString()}');
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
      onError('Erro ao deletar predicao: ${e.toString()}');
    }
  }

  @override
  void navigateBack() {
    GoRouter.of(context).go('/diamond-home');
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Predicao removida com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
