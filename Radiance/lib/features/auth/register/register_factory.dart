import 'package:flutter/material.dart';
import 'register_view_model.dart';
import 'register_service.dart';
import 'register_view.dart';

class RegisterFactory {
  RegisterFactory._();

  static Widget create({
    required BuildContext context,
    required VoidCallback onRegisterSuccess,
    required VoidCallback onGoToLogin,
  }) {
    final viewModel = RegisterViewModel();
    final service = RegisterService(
      onRegisterSuccess: onRegisterSuccess,
      onGoToLogin: onGoToLogin,
    );
    
    return RegisterView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
