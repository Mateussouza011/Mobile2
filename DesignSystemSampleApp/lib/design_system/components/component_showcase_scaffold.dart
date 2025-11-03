import 'package:flutter/material.dart';
import 'package:designsystemsampleapp/design_system/components/component_models.dart';

class ComponentShowcaseScaffold extends StatelessWidget {
  final ComponentCategoryViewModel category;

  const ComponentShowcaseScaffold({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 32),
          for (final section in category.sections) ...[
            ComponentSectionWidget(section: section),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

class ComponentSectionWidget extends StatelessWidget {
  final ComponentSectionViewModel section;

  const ComponentSectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (section.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            section.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        for (final group in section.groups) ...[
          const SizedBox(height: 20),
          _GroupRenderer(group: group),
        ],
      ],
    );
  }
}

class _GroupRenderer extends StatelessWidget {
  final ComponentGroupViewModel group;

  const _GroupRenderer({required this.group});

  @override
  Widget build(BuildContext context) {
    switch (group.layout) {
      case ComponentGroupLayout.column:
        return _buildColumn(context);
      case ComponentGroupLayout.row:
        return _buildRow(context);
      case ComponentGroupLayout.wrap:
        return _buildWrap(context);
    }
  }

  Widget _buildColumn(BuildContext context) {
    final children = <Widget>[];
    for (final component in group.components) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: group.spacing));
      }
      children.add(component.build(context));
    }

    return Column(
      crossAxisAlignment: group.crossAxisAlignment,
      children: children,
    );
  }

  Widget _buildRow(BuildContext context) {
    final children = <Widget>[];
    for (final component in group.components) {
      if (children.isNotEmpty) {
        children.add(SizedBox(width: group.spacing));
      }
      final widget = group.expandChildren
          ? Expanded(child: component.build(context))
          : component.build(context);
      children.add(widget);
    }

    return Row(
      mainAxisAlignment: group.mainAxisAlignment,
      crossAxisAlignment: group.crossAxisAlignment,
      children: children,
    );
  }

  Widget _buildWrap(BuildContext context) {
    return Wrap(
      spacing: group.spacing,
      runSpacing: group.runSpacing,
      alignment: group.wrapAlignment,
      runAlignment: group.wrapRunAlignment,
      children: group.components.map((component) => component.build(context)).toList(),
    );
  }
}
