import 'package:flutter/material.dart';
import 'login_view_model.dart';
import 'login_service.dart';
import 'login_view.dart';
class LoginFactory {
  LoginFactory._();
  static Widget create(BuildContext context) {
    final viewModel = LoginViewModel();
    final service = LoginService(context: context);
    
    return LoginView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
