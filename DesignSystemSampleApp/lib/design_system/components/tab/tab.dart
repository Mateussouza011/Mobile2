import 'package:flutter/material.dart';
import 'tab_view_model.dart';
import '../../theme/design_system_theme.dart';

/// Componente TabBar reutilizável baseado em ViewModel
class DSTabBar extends StatefulWidget {
  final TabBarViewModel viewModel;

  const DSTabBar({
    super.key,
    required this.viewModel,
  });

  /// Factory method para instanciar o tab bar
  static Widget instantiate({required TabBarViewModel viewModel}) {
    return DSTabBar(viewModel: viewModel);
  }

  @override
  State<DSTabBar> createState() => _DSTabBarState();
}

class _DSTabBarState extends State<DSTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.viewModel.tabs.length,
      vsync: this,
      initialIndex: widget.viewModel.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.viewModel.delegate?.onTabChanged(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    
    // Converte os TabItemViewModel em Widgets Tab do Flutter
    final tabs = widget.viewModel.tabs.map((tabItem) {
      if (tabItem.child != null) {
        return Tab(child: tabItem.child);
      }
      
      if (tabItem.icon != null && tabItem.text != null) {
        return Tab(
          icon: Icon(tabItem.icon),
          text: tabItem.text,
        );
      }
      
      if (tabItem.icon != null) {
        return Tab(icon: Icon(tabItem.icon));
      }
      
      return Tab(text: tabItem.text ?? '');
    }).toList();

    Widget tabBar = TabBar(
      controller: _tabController,
      tabs: tabs,
      isScrollable: widget.viewModel.isScrollable,
      indicatorColor: widget.viewModel.indicatorColor ?? theme.primaryColor,
      labelColor: widget.viewModel.labelColor ?? theme.primaryColor,
      unselectedLabelColor: widget.viewModel.unselectedLabelColor ?? 
          theme.textSecondaryColor,
      indicatorWeight: 3,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );

    // Aplica padding se especificado
    if (widget.viewModel.padding != null) {
      tabBar = Padding(
        padding: widget.viewModel.padding!,
        child: tabBar,
      );
    }

    // Aplica margin se especificado
    if (widget.viewModel.margin != null) {
      tabBar = Padding(
        padding: widget.viewModel.margin!,
        child: tabBar,
      );
    }

    return tabBar;
  }
}

/// Widget para exibir o conteúdo das tabs
class DSTabBarView extends StatelessWidget {
  final TabController controller;
  final List<Widget> children;

  const DSTabBarView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: children,
    );
  }
}
