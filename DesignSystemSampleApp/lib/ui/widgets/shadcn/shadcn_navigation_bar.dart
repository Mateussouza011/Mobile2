import 'package:flutter/material.dart';

enum ShadcnNavigationBarVariant {
  primary,
  secondary,
  ghost,
}

enum ShadcnNavigationBarSize {
  sm,
  md,
  lg,
}

class ShadcnNavigationBarItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String? tooltip;
  final bool enabled;
  final Widget? badge;

  const ShadcnNavigationBarItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
    this.enabled = true,
    this.badge,
  });
}

class ShadcnNavigationBar extends StatelessWidget {
  final List<ShadcnNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final ShadcnNavigationBarVariant variant;
  final ShadcnNavigationBarSize size;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool showLabels;
  final NavigationDestinationLabelBehavior? labelBehavior;

  const ShadcnNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.variant = ShadcnNavigationBarVariant.primary,
    this.size = ShadcnNavigationBarSize.md,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.padding,
    this.showLabels = true,
    this.labelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final destinations = items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == selectedIndex;

      return NavigationDestination(
        icon: _buildIcon(context, item, isSelected),
        selectedIcon: _buildSelectedIcon(context, item),
        label: item.label,
        tooltip: item.tooltip,
        enabled: item.enabled,
      );
    }).toList();

    switch (variant) {
      case ShadcnNavigationBarVariant.primary:
        return NavigationBar(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: backgroundColor ?? colorScheme.surface,
          surfaceTintColor: colorScheme.surfaceTint,
          indicatorColor: selectedItemColor ?? colorScheme.secondaryContainer,
          elevation: elevation ?? 3.0,
          height: _getHeight(),
          labelBehavior: labelBehavior ?? 
            (showLabels ? NavigationDestinationLabelBehavior.alwaysShow : NavigationDestinationLabelBehavior.alwaysHide),
        );

      case ShadcnNavigationBarVariant.secondary:
        return Container(
          height: _getHeight(),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == selectedIndex;

              return _buildSecondaryItem(context, item, index, isSelected);
            }).toList(),
          ),
        );

      case ShadcnNavigationBarVariant.ghost:
        return Container(
          height: _getHeight(),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == selectedIndex;

              return _buildGhostItem(context, item, index, isSelected);
            }).toList(),
          ),
        );
    }
  }

  Widget _buildIcon(BuildContext context, ShadcnNavigationBarItem item, bool isSelected) {
    Widget icon = Icon(item.icon);
    
    if (item.badge != null) {
      icon = Badge(
        label: item.badge,
        child: icon,
      );
    }
    
    return icon;
  }

  Widget _buildSelectedIcon(BuildContext context, ShadcnNavigationBarItem item) {
    Widget icon = Icon(item.selectedIcon ?? item.icon);
    
    if (item.badge != null) {
      icon = Badge(
        label: item.badge,
        child: icon,
      );
    }
    
    return icon;
  }

  Widget _buildSecondaryItem(BuildContext context, ShadcnNavigationBarItem item, int index, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: item.enabled ? () => onDestinationSelected?.call(index) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getItemPadding(),
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondaryContainer.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context, item, isSelected),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected 
                    ? (selectedItemColor ?? colorScheme.onSecondaryContainer)
                    : (unselectedItemColor ?? colorScheme.onSurfaceVariant),
                  fontSize: _getLabelSize(),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGhostItem(BuildContext context, ShadcnNavigationBarItem item, int index, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: item.enabled ? () => onDestinationSelected?.call(index) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getItemPadding(),
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context, item, isSelected),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected 
                    ? (selectedItemColor ?? colorScheme.primary)
                    : (unselectedItemColor ?? colorScheme.onSurfaceVariant),
                  fontSize: _getLabelSize(),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case ShadcnNavigationBarSize.sm:
        return 56;
      case ShadcnNavigationBarSize.md:
        return 64;
      case ShadcnNavigationBarSize.lg:
        return 72;
    }
  }

  double _getItemPadding() {
    switch (size) {
      case ShadcnNavigationBarSize.sm:
        return 8;
      case ShadcnNavigationBarSize.md:
        return 12;
      case ShadcnNavigationBarSize.lg:
        return 16;
    }
  }

  double _getLabelSize() {
    switch (size) {
      case ShadcnNavigationBarSize.sm:
        return 10;
      case ShadcnNavigationBarSize.md:
        return 12;
      case ShadcnNavigationBarSize.lg:
        return 14;
    }
  }
}

// Navigation Rail para layouts maiores
class ShadcnNavigationRail extends StatelessWidget {
  final List<ShadcnNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final NavigationRailLabelType? labelType;

  const ShadcnNavigationRail({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.labelType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final destinations = items.map((item) {
      return NavigationRailDestination(
        icon: _buildIcon(item, false),
        selectedIcon: _buildIcon(item, true),
        label: Text(item.label),
        disabled: !item.enabled,
      );
    }).toList();

    return NavigationRail(
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      leading: leading,
      trailing: trailing,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation ?? 0,
      indicatorColor: selectedItemColor ?? colorScheme.secondaryContainer,
      selectedIconTheme: IconThemeData(color: selectedItemColor ?? colorScheme.onSecondaryContainer),
      unselectedIconTheme: IconThemeData(color: unselectedItemColor ?? colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(color: selectedItemColor ?? colorScheme.onSecondaryContainer),
      unselectedLabelTextStyle: TextStyle(color: unselectedItemColor ?? colorScheme.onSurfaceVariant),
      labelType: labelType ?? NavigationRailLabelType.all,
    );
  }

  Widget _buildIcon(ShadcnNavigationBarItem item, bool isSelected) {
    Widget icon = Icon(isSelected ? (item.selectedIcon ?? item.icon) : item.icon);
    
    if (item.badge != null) {
      icon = Badge(
        label: item.badge,
        child: icon,
      );
    }
    
    return icon;
  }
}