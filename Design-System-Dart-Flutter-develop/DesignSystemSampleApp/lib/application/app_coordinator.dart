/// Coordenador de navegação da aplicação
/// Gerencia toda a navegação entre telas usando NavigatorKey
library;

import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';

/// Classe responsável por gerenciar a navegação global da aplicação
class AppCoordinator {
  /// Chave global de navegação
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Retorna o contexto atual de navegação
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Inicia o aplicativo retornando a tela inicial
  Widget startApp() {
    return goToHome();
  }

  /// Navega para a tela Home
  Widget goToHome() {
    return HomeScreen(coordinator: this);
  }

  /// Navega para a showcase de componentes de formulário
  void navigateToFormsShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Forms Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de exibição de dados
  void navigateToDataDisplayShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Data Display Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de navegação
  void navigateToNavigationShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Navigation Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de overlay
  void navigateToOverlaysShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Overlays Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de feedback
  void navigateToFeedbackShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Feedback Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de layout
  void navigateToLayoutShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Layout Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Navega para a showcase de componentes de tipografia
  void navigateToTypographyShowcase() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Typography Showcase - Em construção')),
        ),
      ),
    );
  }

  /// Volta para a tela anterior
  void goBack() {
    navigatorKey.currentState?.pop();
  }

  /// Verifica se pode voltar
  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  /// Volta para a home (remove todas as telas da pilha)
  void goBackToHome() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
