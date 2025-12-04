import 'package:flutter/material.dart';
import 'login_view_model.dart';
import 'login_service.dart';
import 'login_view.dart';
import '../navigation/auth_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';

class LoginFactory {
  LoginFactory._();

  static Widget create(BuildContext context) {
    final viewModel = LoginViewModel();
    final appCoordinator = AppCoordinatorImpl(context);
    final authCoordinator = AuthCoordinatorImpl(appCoordinator);
    final service = LoginService(coordinator: authCoordinator);
    
    return LoginView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}

