/// Aplicação principal - shadcn/ui Flutter Design System
/// Implementa padrões MVVM, Delegate e Clean Architecture

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'application/app.dart';
import 'application/app_coordinator.dart';
import 'core/theme/theme_provider.dart';

/// Ponto de entrada da aplicação
void main() {
  // Criar o coordenador de navegação
  final coordinator = AppCoordinator();

  // Executar aplicação com Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Application(coordinator: coordinator),
    ),
  );
}