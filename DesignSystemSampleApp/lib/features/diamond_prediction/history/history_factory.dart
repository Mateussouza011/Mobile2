import 'package:flutter/material.dart';
import '../../../application/app_coordinator.dart';
import '../home/home_service.dart';
import 'history_service.dart';
import 'history_view_model.dart';
import 'history_view.dart';

/// HistoryFactory - Factory para criação da tela de Histórico
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// Service → ViewModel → View
class HistoryFactory {
  /// Cria uma instância completa da tela de Histórico
  /// 
  /// [coordinator] - AppCoordinator para navegação
  static Widget make({required AppCoordinator coordinator}) {
    // Usa o singleton do home service como fonte de dados
    final homeService = HomeServiceProvider().service;
    
    // Cria o serviço de histórico
    final historyService = HistoryService(homeService: homeService);
    
    // Cria o ViewModel com as dependências
    final viewModel = HistoryViewModel(
      service: historyService,
      coordinator: coordinator,
    );
    
    // Retorna a View com o ViewModel injetado
    return HistoryView(viewModel: viewModel);
  }
}
