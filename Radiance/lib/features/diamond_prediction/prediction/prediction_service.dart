import 'package:flutter/foundation.dart';
import 'prediction_delegate.dart';
import 'prediction_view_model.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/data/models/prediction_model.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';
import '../../../core/data/services/prediction_api_service.dart';

/// Service that handles prediction business logic.
/// Implements PredictionDelegate to respond to view events.
class PredictionService implements PredictionDelegate {
  final PredictionViewModel viewModel;
  final PredictionApiService apiService;
  final PredictionHistoryRepository historyRepository;
  final AuthRepository authRepository;
  final DiamondCoordinator _coordinator;

  PredictionService({
    required this.viewModel,
    required this.apiService,
    required this.historyRepository,
    required this.authRepository,
    required DiamondCoordinator coordinator,
  }) : _coordinator = coordinator;

  @override
  Future<void> predict() async {
    // Validate form before proceeding
    if (!viewModel.isFormValid) {
      onError('Please fill in all required fields (Cut, Color, and Clarity)');
      return;
    }
    
    viewModel.setLoading(true);
    viewModel.clearError();

    try {
      final request = viewModel.buildRequest();
      if (request == null) {
        onError('Invalid form data');
        return;
      }
      
      final result = await apiService.predictPrice(request);
      
      if (result.isSuccess && result.price != null) {
        final response = PredictionResponse(price: result.price!);
        onPredictionSuccess(response);
        await _saveToHistory(response);
      } else {
        onError(result.errorMessage ?? 'Unknown prediction error');
      }
    } catch (e) {
      onError('Error making prediction: ${e.toString()}');
    } finally {
      viewModel.setLoading(false);
    }
  }

  Future<void> _saveToHistory(PredictionResponse result) async {
    final user = authRepository.currentUser;
    if (user == null || user.id == null) return;
    
    // These should never be null at this point since we validated
    final cut = viewModel.cut;
    final color = viewModel.color;
    final clarity = viewModel.clarity;
    if (cut == null || color == null || clarity == null) return;

    try {
      final prediction = PredictionHistoryModel(
        userId: user.id!,
        carat: viewModel.carat,
        cut: cut,
        color: color,
        clarity: clarity,
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
      debugPrint('Error saving to history: $e');
    }
  }

  @override
  Future<void> savePrediction() async {
    final result = viewModel.result;
    if (result == null) {
      onError('No prediction to save');
      return;
    }

    final user = authRepository.currentUser;
    if (user == null || user.id == null) {
      onError('User not authenticated');
      return;
    }
    
    final cut = viewModel.cut;
    final color = viewModel.color;
    final clarity = viewModel.clarity;
    if (cut == null || color == null || clarity == null) {
      onError('Please fill in all required fields');
      return;
    }

    viewModel.setLoading(true);

    try {
      final prediction = PredictionHistoryModel(
        userId: user.id!,
        carat: viewModel.carat,
        cut: cut,
        color: color,
        clarity: clarity,
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
      onError('Error saving prediction: ${e.toString()}');
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
    _coordinator.goToHome();
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
    _coordinator.showSuccessMessage('Prediction saved successfully!');
  }
}
