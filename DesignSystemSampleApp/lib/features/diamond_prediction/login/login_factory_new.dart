import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'login_view_model_new.dart';
import 'login_view_new.dart';

/// Factory para criar a tela de Login
/// 
/// Responsável por montar a tela com todas as dependências
/// seguindo o padrão Factory + MVVM + Delegate.
class LoginFactory {
  /// Cria a tela de Login completa com ViewModel injetado
  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        delegate: _LoginDelegateImpl(context),
      ),
      child: const LoginView(),
    );
  }
}

/// Implementação do Delegate do Login
class _LoginDelegateImpl implements LoginViewDelegate {
  final BuildContext context;
  
  _LoginDelegateImpl(this.context);
  
  @override
  void onLoginSuccess() {
    context.go('/diamond-home');
  }
  
  @override
  void onLoginError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  @override
  void onForgotPasswordTapped() {
    _showBottomSheet(
      title: 'Recuperar Senha',
      message: 'Digite seu email para receber as instruções de recuperação.',
      buttonText: 'Enviar',
    );
  }
  
  @override
  void onCreateAccountTapped() {
    _showBottomSheet(
      title: 'Criar Conta',
      message: 'Use demo@email.com e senha 123456 para acessar a demonstração.',
      buttonText: 'Entendi',
    );
  }
  
  void _showBottomSheet({
    required String title,
    required String message,
    required String buttonText,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E4E7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF71717A),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18181B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
