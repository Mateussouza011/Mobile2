import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prediction_view_model.dart';
import 'prediction_service.dart';
import 'prediction_view.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';
import '../../../core/data/services/prediction_api_service.dart';

/// Factory for creating the Prediction feature with all dependencies.
class PredictionFactory {
  static Widget create(BuildContext context) {
    final viewModel = PredictionViewModel();
    
    // Create coordinators
    final appCoordinator = AppCoordinatorImpl(context);
    final diamondCoordinator = DiamondCoordinatorImpl(appCoordinator);
    
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          final service = PredictionService(
            viewModel: viewModel,
            apiService: PredictionApiService(),
            historyRepository: PredictionHistoryRepository(),
            authRepository: AuthRepository(),
            coordinator: diamondCoordinator,
          );
          
          return PredictionView(delegate: service);
        },
      ),
    );
  }
}
