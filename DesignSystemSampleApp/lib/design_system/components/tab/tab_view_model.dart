import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';

/// Delegate para comunicar mudanças de tab
abstract class TabDelegate {
  /// Chamado quando o índice da tab muda
  void onTabChanged(int index);
}

/// ViewModel para componente de Tab (item individual)
class TabItemViewModel extends BaseComponentViewModel {
  /// Texto da tab
  final String? text;
  
  /// Ícone da tab
  final IconData? icon;
  
  /// Widget customizado (se não quiser usar text ou icon)
  final Widget? child;
  
  /// Se a tab está selecionada
  final bool isSelected;

  TabItemViewModel({
    this.text,
    this.icon,
    this.child,
    this.isSelected = false,
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
  TabItemViewModel copyWith({
    String? text,
    IconData? icon,
    Widget? child,
    bool? isSelected,
    String? id,
    bool? isEnabled,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return TabItemViewModel(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      child: child ?? this.child,
      isSelected: isSelected ?? this.isSelected,
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

/// ViewModel para componente TabBar (conjunto de tabs)
class TabBarViewModel extends BaseComponentViewModel {
  /// Lista de tabs
  final List<TabItemViewModel> tabs;
  
  /// Índice inicial selecionado
  final int initialIndex;
  
  /// Delegate para callbacks
  final TabDelegate? delegate;
  
  /// Cor do indicador
  final Color? indicatorColor;
  
  /// Cor das labels selecionadas
  final Color? labelColor;
  
  /// Cor das labels não selecionadas
  final Color? unselectedLabelColor;
  
  /// Se as tabs são roláveis
  final bool isScrollable;

  TabBarViewModel({
    required this.tabs,
    this.initialIndex = 0,
    this.delegate,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.isScrollable = false,
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
  TabBarViewModel copyWith({
    List<TabItemViewModel>? tabs,
    int? initialIndex,
    TabDelegate? delegate,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    bool? isScrollable,
    String? id,
    bool? isEnabled,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return TabBarViewModel(
      tabs: tabs ?? this.tabs,
      initialIndex: initialIndex ?? this.initialIndex,
      delegate: delegate ?? this.delegate,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      labelColor: labelColor ?? this.labelColor,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      isScrollable: isScrollable ?? this.isScrollable,
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
