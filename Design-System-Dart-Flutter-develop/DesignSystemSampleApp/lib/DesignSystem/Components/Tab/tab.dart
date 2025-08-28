import 'package:flutter/material.dart';
import 'tab_view_model.dart';
import 'tab_delegate.dart';
import '../../shared/colors.dart';

class TabComponent extends StatefulWidget {
  final TabViewModel tabViewModel;
  final TabDelegate? delegate;

  const TabComponent._({super.key, required this.tabViewModel, this.delegate});

  @override
  State<TabComponent> createState() => _TabComponentState();

  static Widget instantiate({required TabViewModel tabViewModel, TabDelegate? delegate}) {
    return TabComponent._(tabViewModel: tabViewModel, delegate: delegate);
  }
}

class _TabComponentState extends State<TabComponent>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: widget.tabViewModel.tabs.length,
        vsync: this,
        initialIndex: widget.tabViewModel.initialIndex);
    tabController.addListener(handleTabChange);
  }

  void handleTabChange() {
    if (tabController.indexIsChanging) {
      widget.delegate?.onTabIndexChanged(tabController.index);
    }
  }

  @override
  void dispose() {
    tabController.removeListener(handleTabChange);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: widget.tabViewModel.tabs,
          indicatorColor: lightPrimaryBrandColor,
          labelColor: lightPrimaryBrandColor,
          unselectedLabelColor: Colors.grey,
        ),
      ],
    );
  }
}
