/// Aplicação principal Flutter com shadcn/ui Design System
/// Configura providers, tema e navegação
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/theme/app_theme.dart';
import 'app_coordinator.dart';

/// Widget principal da aplicação
class Application extends StatelessWidget {
  /// Coordenador de navegação
  final AppCoordinator coordinator;

  /// Construtor
  const Application({super.key, required this.coordinator});

  @override
  Widget build(BuildContext context) {
    // Obtém o provider de tema
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'shadcn/ui Flutter Design System',
      navigatorKey: coordinator.navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: coordinator.startApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
