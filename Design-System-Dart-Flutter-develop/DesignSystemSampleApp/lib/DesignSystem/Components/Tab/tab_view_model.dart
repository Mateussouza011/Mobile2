import 'package:flutter/material.dart';
import 'tab_delegate.dart';

class TabViewModel {
  final List<Tab> tabs;
  final int initialIndex;

  TabViewModel({
    required this.initialIndex,
    required this.tabs,
  });
}
