import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';

/// Delegate para comunicar mudanças de bottom navigation
abstract class BottomNavigationDelegate {
  /// Chamado quando o índice da bottom navigation muda
  void onBottomNavigationChanged(int index);
}

/// ViewModel para item do Bottom Navigation Bar
class BottomNavigationItemViewModel extends BaseComponentViewModel {
  /// Ícone do item
  final IconData icon;
  
  /// Ícone quando selecionado (opcional)
  final IconData? activeIcon;
  
  /// Label do item
  final String label;

  BottomNavigationItemViewModel({
    required this.icon,
    required this.label,
    this.activeIcon,
    super.backgroundColor,
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Cria uma cópia do ViewModel com valores atualizados
  BottomNavigationItemViewModel copyWith({
    IconData? icon,
    IconData? activeIcon,
    String? label,
    Color? backgroundColor,
    String? id,
    bool? isEnabled,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return BottomNavigationItemViewModel(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      width: width ?? this.width,
      height: height ?? this.height,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}

/// ViewModel para Bottom Navigation Bar
class BottomNavigationBarViewModel extends BaseComponentViewModel {
  /// Lista de itens
  final List<BottomNavigationItemViewModel> items;
  
  /// Índice atual selecionado
  final int currentIndex;
  
  /// Delegate para callbacks
  final BottomNavigationDelegate? delegate;
  
  /// Cor dos itens selecionados
  final Color? selectedItemColor;
  
  /// Cor dos itens não selecionados
  final Color? unselectedItemColor;
  
  /// Se deve mostrar labels dos itens não selecionados
  final bool showUnselectedLabels;
  
  /// Tipo do bottom navigation bar
  final BottomNavigationBarType type;
  
  /// Elevação
  final double elevation;

  BottomNavigationBarViewModel({
    required this.items,
    this.currentIndex = 0,
    this.delegate,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showUnselectedLabels = true,
    this.type = BottomNavigationBarType.fixed,
    this.elevation = 8,
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Cria uma cópia do ViewModel com valores atualizados
  BottomNavigationBarViewModel copyWith({
    List<BottomNavigationItemViewModel>? items,
    int? currentIndex,
    BottomNavigationDelegate? delegate,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    bool? showUnselectedLabels,
    BottomNavigationBarType? type,
    double? elevation,
    String? id,
    bool? isEnabled,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return BottomNavigationBarViewModel(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      delegate: delegate ?? this.delegate,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      showUnselectedLabels: showUnselectedLabels ?? this.showUnselectedLabels,
      type: type ?? this.type,
      elevation: elevation ?? this.elevation,
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      width: width ?? this.width,
      height: height ?? this.height,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}
