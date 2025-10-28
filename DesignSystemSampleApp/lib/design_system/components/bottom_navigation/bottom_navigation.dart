import 'package:flutter/material.dart';
import 'bottom_navigation_view_model.dart';
import '../../theme/design_system_theme.dart';

/// Componente Bottom Navigation Bar reutilizável baseado em ViewModel
class DSBottomNavigationBar extends StatelessWidget {
  final BottomNavigationBarViewModel viewModel;

  const DSBottomNavigationBar({
    super.key,
    required this.viewModel,
  });

  /// Factory method para instanciar o bottom navigation bar
  static Widget instantiate({required BottomNavigationBarViewModel viewModel}) {
    return DSBottomNavigationBar(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    
    // Converte os BottomNavigationItemViewModel em BottomNavigationBarItem
    final items = viewModel.items.map((item) {
      return BottomNavigationBarItem(
        icon: Icon(item.icon),
        activeIcon: item.activeIcon != null ? Icon(item.activeIcon) : null,
        label: item.label,
        backgroundColor: item.backgroundColor,
        tooltip: item.tooltip,
      );
    }).toList();

    return BottomNavigationBar(
      items: items,
      currentIndex: viewModel.currentIndex,
      onTap: viewModel.isEnabled 
          ? (index) => viewModel.delegate?.onBottomNavigationChanged(index)
          : null,
      selectedItemColor: viewModel.selectedItemColor ?? theme.primaryColor,
      unselectedItemColor: viewModel.unselectedItemColor ?? 
          theme.textSecondaryColor,
      showUnselectedLabels: viewModel.showUnselectedLabels,
      type: viewModel.type,
      backgroundColor: viewModel.backgroundColor ?? theme.surfaceColor,
      elevation: viewModel.elevation,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 24,
    );
  }
}
