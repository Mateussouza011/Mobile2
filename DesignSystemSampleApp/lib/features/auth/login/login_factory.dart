import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'login_view_model.dart';
import 'login_view.dart';

/// Factory para criar a tela de Login
class LoginFactory {
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        delegate: _LoginDelegateImpl(context),
      ),
      child: const LoginView(),
    );
  }
}

/// Implementação do Delegate
class _LoginDelegateImpl implements LoginDelegate {
  final BuildContext context;
  
  _LoginDelegateImpl(this.context);
  
  @override
  void onLoginSuccess() {
    context.go('/diamond-home');
  }
  
  @override
  void onNavigateToRegister() {
    context.push('/auth/register');
  }
  
  @override
  void onNavigateToForgotPassword() {
    context.push('/auth/forgot-password');
  }
  
  @override
  void onShowError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  @override
  void onShowSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
