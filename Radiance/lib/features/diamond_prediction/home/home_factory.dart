import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';
import 'home_service.dart';
import 'home_view.dart';
import '../navigation/diamond_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

class HomeFactory {
  static Widget create(BuildContext context) {
    final viewModel = HomeViewModel();
    final appCoordinator = AppCoordinatorImpl(context);
    final diamondCoordinator = DiamondCoordinatorImpl(appCoordinator);
    
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          final service = HomeService(
            viewModel: viewModel,
            authRepository: AuthRepository(),
            historyRepository: PredictionHistoryRepository(),
            coordinator: diamondCoordinator,
          );
          viewModel.setCurrentUser(service.getCurrentUser());
          
          return HomeView(delegate: service);
        },
      ),
    );
  }
}

