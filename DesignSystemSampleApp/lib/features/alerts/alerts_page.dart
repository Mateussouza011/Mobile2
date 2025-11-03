import 'package:flutter/material.dart';

import '../../design_system/components/alert/alert_view_model.dart';
import '../../design_system/components/component_showcase_scaffold.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: AlertComponentLibrary.category,
    );
  }
}