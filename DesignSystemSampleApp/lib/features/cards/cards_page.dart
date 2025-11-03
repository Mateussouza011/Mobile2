import 'package:flutter/material.dart';

import '../../design_system/components/cards/cards_view_model.dart';
import '../../design_system/components/component_showcase_scaffold.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: CardComponentLibrary.category,
    );
  }
}