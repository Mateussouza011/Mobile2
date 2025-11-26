import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppCoordinator - Responsável pela navegação centralizada do app
/// 
/// Implementa o Coordinator Pattern para gerenciar toda a navegação
/// de forma centralizada, seguindo os princípios de Clean Architecture.
/// 
/// Uso:
/// - Injetar o coordinator nos ViewModels via Factory
/// - ViewModels chamam métodos do coordinator para navegar
/// - Nenhuma View deve usar Navigator ou GoRouter diretamente
class AppCoordinator {
  final BuildContext context;
  
  AppCoordinator({required this.context});
  
  /// Inicia o app - navega para a tela de login
  void startApp() {
    context.go('/diamond-login');
  }
  
  /// Navega para a tela de login
  void goToLogin() {
    context.go('/diamond-login');
  }
  
  /// Navega para a Home/Dashboard após login bem-sucedido
  /// 
  /// [name] - Nome do usuário logado
  /// [email] - Email do usuário logado
  void goToHome({required String name, required String email}) {
    context.go('/diamond-home', extra: {
      'name': name,
      'email': email,
    });
  }
  
  /// Navega para a tela de nova predição
  void goToPrediction() {
    context.push('/diamond-prediction');
  }
  
  /// Navega para a tela de histórico de predições
  void goToHistory() {
    context.push('/diamond-history');
  }
  
  /// Volta para a tela anterior
  void goBack() {
    if (context.canPop()) {
      context.pop();
    }
  }
  
  /// Faz logout e volta para a tela de login
  void logout() {
    context.go('/diamond-login');
  }
  
  /// Mostra uma mensagem de sucesso (SnackBar)
  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Mostra uma mensagem de erro (SnackBar)
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Mostra uma mensagem informativa (SnackBar)
  void showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
