import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_view_model.dart';
import 'history_service.dart';
import 'history_view.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

class HistoryFactory {
  static Widget create(BuildContext context) {
    final viewModel = HistoryViewModel();
    
    final appCoordinator = AppCoordinatorImpl(context);
    final diamondCoordinator = DiamondCoordinatorImpl(appCoordinator);
    
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          final service = HistoryService(
            viewModel: viewModel,
            historyRepository: PredictionHistoryRepository(),
            authRepository: AuthRepository(),
            coordinator: diamondCoordinator,
          );
          
          return HistoryView(delegate: service);
        },
      ),
    );
  }
}
