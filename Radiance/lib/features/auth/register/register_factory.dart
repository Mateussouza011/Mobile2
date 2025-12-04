import 'package:flutter/material.dart';
import 'register_view_model.dart';
import 'register_service.dart';
import 'register_view.dart';
import '../navigation/auth_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';

class RegisterFactory {
  RegisterFactory._();

  static Widget create({required BuildContext context}) {
    final appCoordinator = AppCoordinatorImpl(context);
    final authCoordinator = AuthCoordinatorImpl(appCoordinator);
    
    final viewModel = RegisterViewModel();
    final service = RegisterService(coordinator: authCoordinator);
    
    return RegisterView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
