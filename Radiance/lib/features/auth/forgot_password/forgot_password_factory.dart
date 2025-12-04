import 'package:flutter/material.dart';
import 'forgot_password_view_model.dart';
import 'forgot_password_service.dart';
import 'forgot_password_view.dart';
import '../navigation/auth_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';

/// Factory for creating the ForgotPassword feature with all dependencies.
class ForgotPasswordFactory {
  ForgotPasswordFactory._();

  static Widget create({required BuildContext context}) {
    // Create coordinators
    final appCoordinator = AppCoordinatorImpl(context);
    final authCoordinator = AuthCoordinatorImpl(appCoordinator);
    
    final viewModel = ForgotPasswordViewModel();
    final service = ForgotPasswordService(coordinator: authCoordinator);
    
    return ForgotPasswordView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
