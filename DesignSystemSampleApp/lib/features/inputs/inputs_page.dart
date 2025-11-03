import 'package:flutter/material.dart';

import '../../design_system/components/component_showcase_scaffold.dart';
import '../../design_system/components/input/input_view_model.dart';

class InputsPage extends StatelessWidget {
  const InputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: InputComponentLibrary.category,
    );
  }
}