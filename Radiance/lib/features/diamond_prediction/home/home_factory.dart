import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';
import 'home_service.dart';
import 'home_view.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

/// Factory para criar a tela Home com todas as dependencias
class HomeFactory {
  static Widget create(BuildContext context) {
    final viewModel = HomeViewModel();
    
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          final service = HomeService(
            viewModel: viewModel,
            authRepository: AuthRepository(),
            historyRepository: PredictionHistoryRepository(),
            context: context,
          );
          
          // Carregar usuario atual
          viewModel.setCurrentUser(service.getCurrentUser());
          
          return HomeView(delegate: service);
        },
      ),
    );
  }
}
