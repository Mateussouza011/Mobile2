import 'package:flutter/material.dart';

/// Delegate para customizar o comportamento do ShadcnCard
/// 
/// Este delegate permite centralizar toda a lógica de interação
/// do card (toque, hover, expansão, seleção), seguindo o
/// padrão Delegate para desacoplamento e reutilização.
abstract class ShadcnCardDelegate {
  /// Chamado quando o card é tocado
  void onCardTapped() {}
  
  /// Chamado quando o card é pressionado longamente
  void onCardLongPressed() {}
  
  /// Chamado quando o estado de hover muda
  /// 
  /// [isHovered] true quando o mouse está sobre o card
  void onCardHoverChanged(bool isHovered) {}
  
  /// Chamado quando o card expande ou colapsa
  /// 
  /// [isExpanded] true quando o card está expandido
  void onCardExpandChanged(bool isExpanded) {}
  
  /// Chamado quando o card é selecionado ou desselecionado
  /// 
  /// [isSelected] true quando o card está selecionado
  void onCardSelected(bool isSelected) {}
  
  /// Define se o card pode ser expandido
  bool canExpand() {
    return false;
  }
  
  /// Define se o card pode ser selecionado
  bool canSelect() {
    return false;
  }
  
  /// Retorna a duração da animação de expansão
  Duration getExpandAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  
  /// Retorna a elevação do card baseado no estado
  /// 
  /// [isHovered] true quando o mouse está sobre o card
  /// [isSelected] true quando o card está selecionado
  double getCardElevation(bool isHovered, bool isSelected) {
    if (isSelected) return 4.0;
    if (isHovered) return 2.0;
    return 0.0;
  }
  
  /// Retorna a cor da borda baseado no estado
  /// 
  /// [isHovered] true quando o mouse está sobre o card
  /// [isSelected] true quando o card está selecionado
  Color? getBorderColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (isHovered) return colorScheme.outline;
    return colorScheme.outline.withValues(alpha: 0.2);
  }
  
  /// Retorna a cor de fundo baseado no estado
  /// 
  /// [isHovered] true quando o mouse está sobre o card
  /// [isSelected] true quando o card está selecionado
  Color? getBackgroundColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primaryContainer.withValues(alpha: 0.1);
    if (isHovered) return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    return colorScheme.surface;
  }
}

/// Implementação padrão do ShadcnCardDelegate
/// 
/// Fornece comportamento básico sem interatividade.
class DefaultShadcnCardDelegate implements ShadcnCardDelegate {
  @override
  void onCardTapped() {}
  
  @override
  void onCardLongPressed() {}
  
  @override
  void onCardHoverChanged(bool isHovered) {}
  
  @override
  void onCardExpandChanged(bool isExpanded) {}
  
  @override
  void onCardSelected(bool isSelected) {}
  
  @override
  bool canExpand() => false;
  
  @override
  bool canSelect() => false;
  
  @override
  Duration getExpandAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  
  @override
  double getCardElevation(bool isHovered, bool isSelected) {
    if (isSelected) return 4.0;
    if (isHovered) return 2.0;
    return 0.0;
  }
  
  @override
  Color? getBorderColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (isHovered) return colorScheme.outline;
    return colorScheme.outline.withValues(alpha: 0.2);
  }
  
  @override
  Color? getBackgroundColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primaryContainer.withValues(alpha: 0.1);
    if (isHovered) return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    return colorScheme.surface;
  }
}

/// Delegate para cards selecionáveis
/// 
/// Permite criar cards que podem ser selecionados/desselecionados.
class SelectableCardDelegate extends DefaultShadcnCardDelegate {
  final Function(bool isSelected)? onSelectionChanged;
  
  SelectableCardDelegate({this.onSelectionChanged});
  
  @override
  bool canSelect() => true;
  
  @override
  void onCardSelected(bool isSelected) {
    onSelectionChanged?.call(isSelected);
  }
  
  @override
  void onCardTapped() {
    // Implementação será feita pelo componente que gerencia o estado
  }
}

/// Delegate para cards expansíveis
/// 
/// Permite criar cards que podem expandir para mostrar mais conteúdo.
class ExpandableCardDelegate extends DefaultShadcnCardDelegate {
  final Function(bool isExpanded)? onExpansionChanged;
  final Duration? customAnimationDuration;
  
  ExpandableCardDelegate({
    this.onExpansionChanged,
    this.customAnimationDuration,
  });
  
  @override
  bool canExpand() => true;
  
  @override
  void onCardExpandChanged(bool isExpanded) {
    onExpansionChanged?.call(isExpanded);
  }
  
  @override
  Duration getExpandAnimationDuration() {
    return customAnimationDuration ?? const Duration(milliseconds: 300);
  }
  
  @override
  void onCardTapped() {
    // Implementação será feita pelo componente que gerencia o estado
  }
}

/// Delegate para cards com analytics tracking
/// 
/// Rastreia interações do usuário com o card.
class TrackedCardDelegate extends DefaultShadcnCardDelegate {
  final String cardId;
  final Function(String event, Map<String, dynamic> data)? onAnalyticsEvent;
  
  TrackedCardDelegate({
    required this.cardId,
    this.onAnalyticsEvent,
  });
  
  @override
  void onCardTapped() {
    onAnalyticsEvent?.call('card_tapped', {
      'card_id': cardId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  @override
  void onCardLongPressed() {
    onAnalyticsEvent?.call('card_long_pressed', {
      'card_id': cardId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  @override
  void onCardHoverChanged(bool isHovered) {
    if (isHovered) {
      onAnalyticsEvent?.call('card_hovered', {
        'card_id': cardId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
}

/// Delegate para cards navegáveis
/// 
/// Navega para outra tela ao tocar no card.
class NavigableCardDelegate extends DefaultShadcnCardDelegate {
  final VoidCallback onNavigate;
  
  NavigableCardDelegate({required this.onNavigate});
  
  @override
  void onCardTapped() {
    onNavigate();
  }
  
  @override
  double getCardElevation(bool isHovered, bool isSelected) {
    return isHovered ? 3.0 : 1.0;
  }
}

/// Delegate para cards com múltiplas funcionalidades
/// 
/// Combina seleção, expansão e navegação.
class InteractiveCardDelegate extends DefaultShadcnCardDelegate {
  final Function(bool isSelected)? onSelectionChanged;
  final Function(bool isExpanded)? onExpansionChanged;
  final VoidCallback? onNavigate;
  final bool allowSelection;
  final bool allowExpansion;
  
  InteractiveCardDelegate({
    this.onSelectionChanged,
    this.onExpansionChanged,
    this.onNavigate,
    this.allowSelection = false,
    this.allowExpansion = false,
  });
  
  @override
  bool canSelect() => allowSelection;
  
  @override
  bool canExpand() => allowExpansion;
  
  @override
  void onCardTapped() {
    onNavigate?.call();
  }
  
  @override
  void onCardSelected(bool isSelected) {
    onSelectionChanged?.call(isSelected);
  }
  
  @override
  void onCardExpandChanged(bool isExpanded) {
    onExpansionChanged?.call(isExpanded);
  }
}
