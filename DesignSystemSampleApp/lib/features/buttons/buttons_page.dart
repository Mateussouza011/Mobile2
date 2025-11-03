import 'package:flutter/material.dart';

import '../../design_system/components/button/button_view_model.dart';
import '../../design_system/components/component_showcase_scaffold.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: ButtonComponentLibrary.category,
    );
  }
}