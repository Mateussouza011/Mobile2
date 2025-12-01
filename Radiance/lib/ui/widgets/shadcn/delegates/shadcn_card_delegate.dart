import 'package:flutter/material.dart';
abstract class ShadcnCardDelegate {
  void onCardTapped() {}
  void onCardLongPressed() {}
  void onCardHoverChanged(bool isHovered) {}
  void onCardExpandChanged(bool isExpanded) {}
  void onCardSelected(bool isSelected) {}
  bool canExpand() {
    return false;
  }
  bool canSelect() {
    return false;
  }
  Duration getExpandAnimationDuration() {
    return const Duration(milliseconds: 300);
  }
  double getCardElevation(bool isHovered, bool isSelected) {
    if (isSelected) return 4.0;
    if (isHovered) return 2.0;
    return 0.0;
  }
  Color? getBorderColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primary;
    if (isHovered) return colorScheme.outline;
    return colorScheme.outline.withValues(alpha: 0.2);
  }
  Color? getBackgroundColor(bool isHovered, bool isSelected, ColorScheme colorScheme) {
    if (isSelected) return colorScheme.primaryContainer.withValues(alpha: 0.1);
    if (isHovered) return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    return colorScheme.surface;
  }
}
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
  }
}
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
  }
}
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
