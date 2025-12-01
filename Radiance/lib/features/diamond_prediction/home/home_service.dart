import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'home_delegate.dart';
import 'home_view_model.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/models/user_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';
class HomeService implements HomeDelegate {
  final HomeViewModel viewModel;
  final AuthRepository authRepository;
  final PredictionHistoryRepository historyRepository;
  final BuildContext context;

  HomeService({
    required this.viewModel,
    required this.authRepository,
    required this.historyRepository,
    required this.context,
  });

  @override
  Future<void> loadStats() async {
    viewModel.setLoading(true);
    viewModel.clearError();

    try {
      final user = getCurrentUser();
      if (user == null || user.id == null) {
        onError('Usuário não autenticado');
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
      onError('Erro ao carregar estatísticas: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void navigateToPrediction() {
    GoRouter.of(context).go('/diamond-prediction');
  }

  @override
  void navigateToHistory() {
    GoRouter.of(context).go('/diamond-history');
  }

  @override
  Future<void> logout() async {
    try {
      await authRepository.logout();
      if (context.mounted) {
        GoRouter.of(context).go('/diamond-login');
      }
    } catch (e) {
      onError('Erro ao fazer logout: ${e.toString()}');
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
