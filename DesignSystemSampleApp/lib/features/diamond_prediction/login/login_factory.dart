import 'package:flutter/material.dart';
import '../../../application/app_coordinator.dart';
import 'login_service.dart';
import 'login_view_model.dart';
import 'login_view.dart';

/// LoginFactory - Factory para criação da tela de Login
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// Service → ViewModel → View
/// 
/// Garante a injeção correta de dependências e mantém
/// a separação de responsabilidades.
class LoginFactory {
  /// Cria uma instância completa da tela de Login
  /// 
  /// [coordinator] - AppCoordinator para navegação
  static Widget make({required AppCoordinator coordinator}) {
    // Cria o serviço
    final service = LoginService();
    
    // Cria o ViewModel com as dependências
    final viewModel = LoginViewModel(
      service: service,
      coordinator: coordinator,
    );
    
    // Retorna a View com o ViewModel injetado
    return LoginView(viewModel: viewModel);
  }
}
