import 'package:flutter/material.dart';

import '../../design_system/components/component_showcase_scaffold.dart';
import '../../design_system/components/progress/progress_view_model.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: ProgressComponentLibrary.category,
    );
  }
}