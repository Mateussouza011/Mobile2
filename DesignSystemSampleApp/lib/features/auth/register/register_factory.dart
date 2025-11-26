import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'register_view_model.dart';
import 'register_view.dart';

/// Factory para criar a tela de registro
class RegisterFactory {
  /// Cria a tela de registro com todas as dependências
  static Widget create({
    required BuildContext context,
    required VoidCallback onRegisterSuccess,
    required VoidCallback onGoToLogin,
  }) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(
        delegate: _RegisterDelegateImpl(
          context: context,
          onRegisterSuccess: onRegisterSuccess,
          onGoToLogin: onGoToLogin,
        ),
      ),
      child: const RegisterView(),
    );
  }
}

/// Implementação do delegate de registro
class _RegisterDelegateImpl implements RegisterDelegate {
  final BuildContext context;
  final VoidCallback _onRegisterSuccess;
  final VoidCallback _onGoToLogin;

  _RegisterDelegateImpl({
    required this.context,
    required VoidCallback onRegisterSuccess,
    required VoidCallback onGoToLogin,
  })  : _onRegisterSuccess = onRegisterSuccess,
        _onGoToLogin = onGoToLogin;

  @override
  void onRegisterSuccess() {
    _onRegisterSuccess();
  }

  @override
  void onNavigateToLogin() {
    _onGoToLogin();
  }

  @override
  void onShowError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void onShowSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
