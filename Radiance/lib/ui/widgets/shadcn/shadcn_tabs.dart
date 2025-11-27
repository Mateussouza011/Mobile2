import 'package:flutter/material.dart';

class ShadcnTab {
  final String label;
  final Widget content;
  final Widget? icon;
  final bool enabled;
  final String? tooltip;

  const ShadcnTab({
    required this.label,
    required this.content,
    this.icon,
    this.enabled = true,
    this.tooltip,
  });
}

enum ShadcnTabsVariant {
  line,
  pills,
  card,
}

class ShadcnTabs extends StatefulWidget {
  final List<ShadcnTab> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final ShadcnTabsVariant variant;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  final Axis direction;

  const ShadcnTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
    this.variant = ShadcnTabsVariant.line,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.padding,
    this.scrollable = false,
    this.direction = Axis.horizontal,
  });

  @override
  State<ShadcnTabs> createState() => _ShadcnTabsState();
}

class _ShadcnTabsState extends State<ShadcnTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_controller.index != _currentIndex) {
      setState(() {
        _currentIndex = _controller.index;
      });
      widget.onChanged?.call(_controller.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: widget.padding,
      decoration: widget.backgroundColor != null
          ? BoxDecoration(color: widget.backgroundColor)
          : null,
      child: widget.direction == Axis.horizontal
          ? _buildHorizontalTabs(theme, colorScheme)
          : _buildVerticalTabs(theme, colorScheme),
    );
  }

  Widget _buildHorizontalTabs(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildTabBar(theme, colorScheme),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTabs(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _buildTabBar(theme, colorScheme, isVertical: true),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme, ColorScheme colorScheme, {bool isVertical = false}) {
    switch (widget.variant) {
      case ShadcnTabsVariant.line:
        return _buildLineTabBar(theme, colorScheme, isVertical);
      case ShadcnTabsVariant.pills:
        return _buildPillsTabBar(theme, colorScheme, isVertical);
      case ShadcnTabsVariant.card:
        return _buildCardTabBar(theme, colorScheme, isVertical);
    }
  }

  Widget _buildLineTabBar(ThemeData theme, ColorScheme colorScheme, bool isVertical) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isVertical
              ? BorderSide.none
              : BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
          right: isVertical
              ? BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))
              : BorderSide.none,
        ),
      ),
      child: TabBar(
        controller: _controller,
        isScrollable: widget.scrollable,
        indicatorColor: widget.selectedColor ?? colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor: widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium,
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        tabs: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildTabWidget(tab, index, theme, colorScheme);
        }).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(ThemeData theme, ColorScheme colorScheme, bool isVertical) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: isVertical
          ? Column(
              children: widget.tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                return _buildPillTab(tab, index, theme, colorScheme, isVertical);
              }).toList(),
            )
          : Row(
              children: widget.tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                return Expanded(
                  child: _buildPillTab(tab, index, theme, colorScheme, isVertical),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildCardTabBar(ThemeData theme, ColorScheme colorScheme, bool isVertical) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: TabBar(
        controller: _controller,
        isScrollable: widget.scrollable,
        indicator: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        tabs: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildTabWidget(tab, index, theme, colorScheme);
        }).toList(),
      ),
    );
  }

  Widget _buildTabWidget(ShadcnTab tab, int index, ThemeData theme, ColorScheme colorScheme) {
    Widget tabContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            tab.icon!,
            const SizedBox(width: 8),
          ],
          Text(tab.label),
        ],
      ),
    );

    if (tab.tooltip != null) {
      tabContent = Tooltip(
        message: tab.tooltip!,
        child: tabContent,
      );
    }

    return Tab(child: tabContent);
  }

  Widget _buildPillTab(ShadcnTab tab, int index, ThemeData theme, ColorScheme colorScheme, bool isVertical) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: tab.enabled ? () => _controller.animateTo(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (widget.selectedColor ?? colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : (widget.unselectedColor ?? colorScheme.onSurfaceVariant),
                  size: 16,
                ),
                child: tab.icon!,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              tab.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : (widget.unselectedColor ?? colorScheme.onSurfaceVariant),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}