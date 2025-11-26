import 'package:flutter/material.dart';
import '../../../application/app_coordinator.dart';
import '../home/home_service.dart';
import 'prediction_service.dart';
import 'prediction_view_model.dart';
import 'prediction_view.dart';

/// PredictionFactory - Factory para criação da tela de Predição
/// 
/// Implementa o Factory Pattern para criar e conectar:
/// Service → ViewModel → View
class PredictionFactory {
  /// Cria uma instância completa da tela de Predição via rota
  static Widget create(BuildContext context) {
    // Cria o serviço de predição
    final predictionService = PredictionService();
    
    // Usa o singleton do home service para salvar histórico
    final homeService = HomeServiceProvider().service;
    
    // Cria o coordinator
    final coordinator = AppCoordinator(context: context);
    
    // Cria o ViewModel com as dependências
    final viewModel = PredictionViewModel(
      service: predictionService,
      coordinator: coordinator,
      homeService: homeService,
    );
    
    // Retorna a View com o ViewModel injetado
    return PredictionView(viewModel: viewModel);
  }
  
  /// Cria uma instância completa da tela de Predição
  /// 
  /// [coordinator] - AppCoordinator para navegação
  static Widget make({required AppCoordinator coordinator}) {
    // Cria o serviço de predição
    final predictionService = PredictionService();
    
    // Usa o singleton do home service para salvar histórico
    final homeService = HomeServiceProvider().service;
    
    // Cria o ViewModel com as dependências
    final viewModel = PredictionViewModel(
      service: predictionService,
      coordinator: coordinator,
      homeService: homeService,
    );
    
    // Retorna a View com o ViewModel injetado
    return PredictionView(viewModel: viewModel);
  }
}
