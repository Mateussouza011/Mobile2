import 'package:flutter/material.dart';
import '../../../application/app_coordinator.dart';
import 'home_service.dart';
import 'home_view_model.dart';
import 'home_view.dart';

/// HomeFactory - Factory para criação da tela Home/Dashboard
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// Service → ViewModel → View
class HomeFactory {
  /// Cria uma instância completa da tela Home
  /// 
  /// [coordinator] - AppCoordinator para navegação
  /// [name] - Nome do usuário logado
  /// [email] - Email do usuário logado
  static Widget make({
    required AppCoordinator coordinator,
    required String name,
    required String email,
  }) {
    // Usa o singleton do serviço para manter estado
    final service = HomeServiceProvider().service;
    
    // Cria o ViewModel com as dependências
    final viewModel = HomeViewModel(
      service: service,
      coordinator: coordinator,
      userName: name,
      userEmail: email,
    );
    
    // Retorna a View com o ViewModel injetado
    return HomeView(viewModel: viewModel);
  }
}
