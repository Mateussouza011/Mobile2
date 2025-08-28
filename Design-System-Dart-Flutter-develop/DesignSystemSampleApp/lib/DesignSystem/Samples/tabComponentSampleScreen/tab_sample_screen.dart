import 'package:flutter/material.dart';
import '../../Components/Tab/tab.dart';
import '../../Components/Tab/tab_view_model.dart';
import '../../Components/Tab/tab_delegate.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> implements TabDelegate {
  int currentTabIndex = 0;

  @override
  void onTabIndexChanged(int index) {
    setState(() {
      currentTabIndex = index;
    });
    print('Tab selecionado: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab page Demo"),
      ),
      body: Column(
        children: [
          TabComponent.instantiate(
            tabViewModel: TabViewModel(
              tabs: [
                const Tab(text: 'Home'),
                const Tab(text: 'Messages'),
                const Tab(text: 'Label'),
                const Tab(text: 'Profile'),
              ],
              initialIndex: 0,
            ),
            delegate: this,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Conteúdo do Tab ${_getTabName(currentTabIndex)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Messages';
      case 2:
        return 'Label';
      case 3:
        return 'Profile';
      default:
        return 'Desconhecido';
    }
  }
}