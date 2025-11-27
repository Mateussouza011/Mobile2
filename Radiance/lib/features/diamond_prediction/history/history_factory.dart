import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_view_model.dart';
import 'history_service.dart';
import 'history_view.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/data/repositories/prediction_history_repository.dart';

/// Factory para criar a tela de History com todas as dependencias
class HistoryFactory {
  static Widget create(BuildContext context) {
    final viewModel = HistoryViewModel();
    
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Builder(
        builder: (context) {
          final service = HistoryService(
            viewModel: viewModel,
            historyRepository: PredictionHistoryRepository(),
            authRepository: AuthRepository(),
            context: context,
          );
          
          return HistoryView(delegate: service);
        },
      ),
    );
  }
}
