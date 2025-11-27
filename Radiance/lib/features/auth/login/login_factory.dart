import 'package:flutter/material.dart';
import 'login_view_model.dart';
import 'login_service.dart';
import 'login_view.dart';

/// Factory para criar a tela de Login
/// Monta a cadeia: Repository -> Service -> ViewModel -> View
class LoginFactory {
  LoginFactory._();

  /// Cria a tela de Login com todas as dependências
  static Widget create(BuildContext context) {
    final viewModel = LoginViewModel();
    final service = LoginService(context: context);
    
    return LoginView(
      viewModel: viewModel,
      delegate: service,
    );
  }
}
