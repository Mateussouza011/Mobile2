import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'prediction_delegate.dart';
import 'prediction_view_model.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';
import '../../../core/data/services/prediction_api_service.dart';

/// Implementacao do PredictionDelegate - conecta View aos Services
class PredictionService implements PredictionDelegate {
  final PredictionViewModel viewModel;
  final PredictionApiService apiService;
  final PredictionHistoryRepository historyRepository;
  final AuthRepository authRepository;
  final BuildContext context;

  PredictionService({
    required this.viewModel,
    required this.apiService,
    required this.historyRepository,
    required this.authRepository,
    required this.context,
  });

  @override
  Future<void> predict() async {
    viewModel.setLoading(true);
    viewModel.clearError();

    try {
      final request = viewModel.buildRequest();
      final result = await apiService.predictPrice(request);
      
      if (result.isSuccess && result.price != null) {
        final response = PredictionResponse(price: result.price!);
        onPredictionSuccess(response);
        
        // Salvar automaticamente no histórico
        await _saveToHistory(response);
      } else {
        onError(result.errorMessage ?? 'Erro desconhecido na predicao');
      }
    } catch (e) {
      onError('Erro ao fazer predicao: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  /// Salva a predição no histórico automaticamente
  Future<void> _saveToHistory(PredictionResponse result) async {
    final user = authRepository.currentUser;
    if (user == null || user.id == null) return;

    try {
      final prediction = PredictionHistoryModel(
        userId: user.id!,
        carat: viewModel.carat,
        cut: viewModel.cut,
        color: viewModel.color,
        clarity: viewModel.clarity,
        depth: viewModel.depth,
        table: viewModel.table,
        x: viewModel.x,
        y: viewModel.y,
        z: viewModel.z,
        predictedPrice: result.price,
        createdAt: DateTime.now(),
      );

      await historyRepository.savePrediction(prediction);
    } catch (e) {
      // Silently fail - não queremos interromper a experiência do usuário
      debugPrint('Erro ao salvar histórico: $e');
    }
  }

  @override
  Future<void> savePrediction() async {
    final result = viewModel.result;
    if (result == null) {
      onError('Nenhuma predicao para salvar');
      return;
    }

    final user = authRepository.currentUser;
    if (user == null || user.id == null) {
      onError('Usuario nao autenticado');
      return;
    }

    viewModel.setLoading(true);

    try {
      final prediction = PredictionHistoryModel(
        userId: user.id!,
        carat: viewModel.carat,
        cut: viewModel.cut,
        color: viewModel.color,
        clarity: viewModel.clarity,
        depth: viewModel.depth,
        table: viewModel.table,
        x: viewModel.x,
        y: viewModel.y,
        z: viewModel.z,
        predictedPrice: result.price,
        createdAt: DateTime.now(),
      );

      await historyRepository.savePrediction(prediction);
      onPredictionSaved();
    } catch (e) {
      onError('Erro ao salvar predicao: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void clearResult() {
    viewModel.clearResult();
  }

  @override
  void resetForm() {
    viewModel.reset();
  }

  @override
  void navigateBack() {
    GoRouter.of(context).go('/diamond-home');
  }

  @override
  void onPredictionSuccess(PredictionResponse response) {
    viewModel.setResult(response);
  }

  @override
  void onError(String message) {
    viewModel.setError(message);
  }

  @override
  void onPredictionSaved() {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Predicao salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
