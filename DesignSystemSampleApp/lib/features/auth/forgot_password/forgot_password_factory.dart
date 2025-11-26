import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forgot_password_view_model.dart';
import 'forgot_password_view.dart';

/// Factory para criar a tela de recuperação de senha
class ForgotPasswordFactory {
  /// Cria a tela de recuperação de senha com todas as dependências
  static Widget create({
    required BuildContext context,
    required VoidCallback onRecoverySuccess,
    required VoidCallback onGoToLogin,
  }) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(
        delegate: _ForgotPasswordDelegateImpl(
          context: context,
          onRecoverySuccess: onRecoverySuccess,
          onGoToLogin: onGoToLogin,
        ),
      ),
      child: const ForgotPasswordView(),
    );
  }
}

/// Implementação do delegate de recuperação de senha
class _ForgotPasswordDelegateImpl implements ForgotPasswordDelegate {
  final BuildContext context;
  final VoidCallback _onRecoverySuccess;
  final VoidCallback _onGoToLogin;

  _ForgotPasswordDelegateImpl({
    required this.context,
    required VoidCallback onRecoverySuccess,
    required VoidCallback onGoToLogin,
  })  : _onRecoverySuccess = onRecoverySuccess,
        _onGoToLogin = onGoToLogin;

  @override
  void onRecoverySuccess() {
    _onRecoverySuccess();
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
