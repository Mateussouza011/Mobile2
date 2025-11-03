import 'package:flutter/material.dart';

typedef ComponentWidgetBuilder = Widget Function(
  BuildContext context,
  ComponentViewModel viewModel,
  Map<String, dynamic> properties,
);

/// Base view-model structure for describing showcase components.
class ComponentViewModel {
  final String id;
  final String title;
  final String description;
  final ComponentViewModel? parent;
  final Map<String, dynamic> overrides;
  final Map<String, Object?> metadata;
  final ComponentWidgetBuilder builder;

  const ComponentViewModel({
    required this.id,
    required this.title,
    required this.builder,
    this.description = '',
    this.parent,
    this.overrides = const <String, dynamic>{},
    this.metadata = const <String, Object?>{},
  });

  /// Returns the merged property map considering ancestors.
  Map<String, dynamic> get properties => <String, dynamic>{
        ...?parent?.properties,
        ...overrides,
      };

  /// Access a strongly typed property from the resolved map.
  T prop<T>(String key, {T? fallback}) {
    if (properties.containsKey(key)) {
      return properties[key] as T;
    }
    if (fallback != null) {
      return fallback;
    }
    throw ArgumentError('Property "$key" not found in component "$id"');
  }

  /// Inherit properties from the current view-model while overriding specifics.
  ComponentViewModel derive({
    required String id,
    String? title,
    String? description,
    Map<String, dynamic> overrides = const <String, dynamic>{},
    Map<String, Object?> metadata = const <String, Object?>{},
    ComponentWidgetBuilder? builder,
  }) {
    return ComponentViewModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      parent: this,
      overrides: overrides,
      metadata: <String, Object?>{
        ...this.metadata,
        ...metadata,
      },
      builder: builder ?? this.builder,
    );
  }

  /// Builds the widget preview for this component.
  Widget build(BuildContext context) => builder(context, this, properties);
}

enum ComponentGroupLayout { column, row, wrap }

/// Describes how a subset of components should be laid out within a section.
class ComponentGroupViewModel {
  final String id;
  final List<ComponentViewModel> components;
  final ComponentGroupLayout layout;
  final double spacing;
  final double runSpacing;
  final bool expandChildren;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final WrapAlignment wrapAlignment;
  final WrapAlignment wrapRunAlignment;

  const ComponentGroupViewModel({
    required this.id,
    required this.components,
    this.layout = ComponentGroupLayout.column,
    this.spacing = 12,
    double? runSpacing,
    this.expandChildren = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapRunAlignment = WrapAlignment.start,
  }) : runSpacing = runSpacing ?? spacing;

  factory ComponentGroupViewModel.column({
    required String id,
    required List<ComponentViewModel> components,
    double spacing = 12,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return ComponentGroupViewModel(
      id: id,
      components: components,
      layout: ComponentGroupLayout.column,
      spacing: spacing,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  factory ComponentGroupViewModel.row({
    required String id,
    required List<ComponentViewModel> components,
    double spacing = 12,
    bool expandChildren = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return ComponentGroupViewModel(
      id: id,
      components: components,
      layout: ComponentGroupLayout.row,
      spacing: spacing,
      expandChildren: expandChildren,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  factory ComponentGroupViewModel.wrap({
    required String id,
    required List<ComponentViewModel> components,
    double spacing = 12,
    double runSpacing = 12,
    WrapAlignment alignment = WrapAlignment.start,
    WrapAlignment runAlignment = WrapAlignment.start,
  }) {
    return ComponentGroupViewModel(
      id: id,
      components: components,
      layout: ComponentGroupLayout.wrap,
      spacing: spacing,
      runSpacing: runSpacing,
      wrapAlignment: alignment,
      wrapRunAlignment: runAlignment,
    );
  }
}

/// Aggregates a set of component groups under a named showcase section.
class ComponentSectionViewModel {
  final String id;
  final String title;
  final String description;
  final List<ComponentGroupViewModel> groups;

  const ComponentSectionViewModel({
    required this.id,
    required this.title,
    this.description = '',
    this.groups = const <ComponentGroupViewModel>[],
  });
}

/// Represents a full showcase category (e.g., Buttons, Inputs).
class ComponentCategoryViewModel {
  final String id;
  final String title;
  final String description;
  final List<ComponentSectionViewModel> sections;

  const ComponentCategoryViewModel({
    required this.id,
    required this.title,
    this.description = '',
    this.sections = const <ComponentSectionViewModel>[],
  });
}
