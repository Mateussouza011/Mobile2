import 'package:flutter/material.dart';

/// Delegate para a Landing Page
abstract class LandingDelegate {
  void onGetStartedTapped();
  void onLearnMoreTapped();
}

/// ViewModel para a Landing Page
/// 
/// Gerencia o estado e a lógica da landing page
/// seguindo o padrão MVVM com Delegate.
class LandingViewModel extends ChangeNotifier {
  final LandingDelegate delegate;
  
  LandingViewModel({required this.delegate});
  
  // Estado de animação
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  
  // Features para exibição
  final List<FeatureItem> features = const [
    FeatureItem(
      icon: Icons.auto_awesome_outlined,
      title: 'Precisão com IA',
      subtitle: 'Modelos avançados de ML',
    ),
    FeatureItem(
      icon: Icons.bolt_outlined,
      title: 'Instantâneo',
      subtitle: 'Resultados em segundos',
    ),
    FeatureItem(
      icon: Icons.shield_outlined,
      title: 'Confiável',
      subtitle: 'Dados seguros',
    ),
  ];
  
  /// Inicializa as animações
  void initialize() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _isLoaded = true;
      notifyListeners();
    });
  }
  
  /// Ação do botão principal
  void getStarted() {
    delegate.onGetStartedTapped();
  }
  
  /// Ação do link secundário
  void learnMore() {
    delegate.onLearnMoreTapped();
  }
}

/// Modelo para os itens de feature
class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
