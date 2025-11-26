import 'package:flutter/material.dart';
import 'forgot_password_view_model.dart';
import 'forgot_password_service.dart';
import 'forgot_password_view.dart';

class ForgotPasswordFactory {
  ForgotPasswordFactory._();

  static Widget create({
    required BuildContext context,
    required VoidCallback onRecoverySuccess,
    required VoidCallback onGoToLogin,
  }) {
    final viewModel = ForgotPasswordViewModel();
    final service = ForgotPasswordService(
      onRecoverySuccess: onRecoverySuccess,
      onGoToLogin: onGoToLogin,
    );
    
    return ForgotPasswordView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
