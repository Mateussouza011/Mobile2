import 'package:flutter/material.dart';

import 'package:designsystemsampleapp/design_system/components/component_models.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_progress.dart';

class ProgressComponentLibrary {
  ProgressComponentLibrary._();

  static final ComponentViewModel _linearBase = ComponentViewModel(
    id: 'progress.linear.base',
    title: 'Progresso Linear',
    overrides: <String, dynamic>{
      'label': '',
      'value': 0.0,
      'size': ShadcnProgressSize.default_,
      'variant': null,
    },
    builder: (context, viewModel, props) {
      final label = props['label'] as String?;
      final textTheme = Theme.of(context).textTheme;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null && label.isNotEmpty) ...[
            Text(label, style: textTheme.bodySmall),
            const SizedBox(height: 8),
          ],
          ShadcnProgress.linear(
            value: props['value'] as double? ?? 0,
            size: props['size'] as ShadcnProgressSize? ?? ShadcnProgressSize.default_,
            variant: props['variant'] as ShadcnProgressVariant? ?? ShadcnProgressVariant.default_,
          ),
        ],
      );
    },
  );

  static ComponentViewModel _linear({
    required String id,
    required String title,
    Map<String, dynamic> overrides = const <String, dynamic>{},
  }) {
    return _linearBase.derive(
      id: id,
      title: title,
      overrides: overrides,
    );
  }

  static final ComponentViewModel linearBasic = _linear(
    id: 'progress.linear.basic',
    title: 'Básico',
    overrides: const <String, dynamic>{
      'label': 'Básico',
      'value': 50.0,
    },
  );

  static final ComponentViewModel linearSmall = _linear(
    id: 'progress.linear.small',
    title: 'Pequeno',
    overrides: const <String, dynamic>{
      'label': 'Pequeno',
      'value': 40.0,
      'size': ShadcnProgressSize.sm,
    },
  );

  static final ComponentViewModel linearDefault = _linear(
    id: 'progress.linear.default',
    title: 'Padrão',
    overrides: const <String, dynamic>{
      'label': 'Padrão',
      'value': 60.0,
      'size': ShadcnProgressSize.default_,
    },
  );

  static final ComponentViewModel linearLarge = _linear(
    id: 'progress.linear.large',
    title: 'Grande',
    overrides: const <String, dynamic>{
      'label': 'Grande',
      'value': 80.0,
      'size': ShadcnProgressSize.lg,
    },
  );

  static final ComponentViewModel _circularBase = ComponentViewModel(
    id: 'progress.circular.base',
    title: 'Progresso Circular',
    overrides: const <String, dynamic>{
      'label': '',
      'value': 0.0,
      'showOverlayText': false,
      'indeterminate': false,
    },
    builder: (context, viewModel, props) {
      final label = props['label'] as String?;
      final textTheme = Theme.of(context).textTheme;
      final value = props['value'] as double? ?? 0.0;
      final showOverlay = props['showOverlayText'] as bool? ?? false;
      final indeterminate = props['indeterminate'] as bool? ?? false;

      Widget indicator;
      if (indeterminate) {
        indicator = const ShadcnProgress.indeterminate(
          type: ShadcnProgressType.circular,
        );
      } else {
        indicator = ShadcnProgress.circular(value: value);
      }

      if (showOverlay && !indeterminate) {
        indicator = Stack(
          alignment: Alignment.center,
          children: [
            indicator,
            Text(
              '${value.toInt()}%',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        );
      }

      return Column(
        children: [
          if (label != null && label.isNotEmpty) ...[
            Text(label, style: textTheme.bodySmall),
            const SizedBox(height: 8),
          ],
          indicator,
        ],
      );
    },
  );

  static ComponentViewModel _circular({
    required String id,
    required String title,
    Map<String, dynamic> overrides = const <String, dynamic>{},
  }) {
    return _circularBase.derive(
      id: id,
      title: title,
      overrides: overrides,
    );
  }

  static final ComponentViewModel circularBasic = _circular(
    id: 'progress.circular.basic',
    title: 'Circular Básico',
    overrides: const <String, dynamic>{
      'label': 'Básico',
      'value': 65.0,
    },
  );

  static final ComponentViewModel circularWithText = _circular(
    id: 'progress.circular.text',
    title: 'Circular com texto',
    overrides: const <String, dynamic>{
      'label': 'Com texto',
      'value': 80.0,
      'showOverlayText': true,
    },
  );

  static final ComponentViewModel circularIndeterminate = _circular(
    id: 'progress.circular.indeterminate',
    title: 'Circular indeterminado',
    overrides: const <String, dynamic>{
      'label': 'Indeterminado',
      'indeterminate': true,
    },
  );

  static final ComponentViewModel _stepsBase = ComponentViewModel(
    id: 'progress.steps.base',
    title: 'Progresso por Etapas',
    overrides: const <String, dynamic>{
      'totalSteps': 4,
      'currentStep': 0,
      'labels': <String>[],
  'variant': ShadcnProgressVariant.default_,
    },
    builder: (context, viewModel, props) {
      return ShadcnStepProgress(
        totalSteps: props['totalSteps'] as int? ?? 4,
        currentStep: props['currentStep'] as int? ?? 0,
        stepLabels: List<String>.from(props['labels'] as List<String>),
        variant: props['variant'] as ShadcnProgressVariant? ?? ShadcnProgressVariant.default_,
      );
    },
  );

  static ComponentViewModel _steps({
    required String id,
    required String title,
    Map<String, dynamic> overrides = const <String, dynamic>{},
  }) {
    return _stepsBase.derive(
      id: id,
      title: title,
      overrides: overrides,
    );
  }

  static final ComponentViewModel stepsPersonalInfo = _steps(
    id: 'progress.steps.personalInfo',
    title: 'Fluxo padrão',
    overrides: const <String, dynamic>{
      'currentStep': 2,
      'labels': <String>[
        'Informações Pessoais',
        'Endereço',
        'Pagamento',
        'Confirmação',
      ],
    },
  );

  static final ComponentViewModel stepsUpload = _steps(
    id: 'progress.steps.upload',
    title: 'Fluxo de upload',
    overrides: const <String, dynamic>{
      'currentStep': 1,
      'variant': ShadcnProgressVariant.success,
      'labels': <String>[
        'Upload',
        'Processamento',
        'Validação',
        'Concluído',
      ],
    },
  );

  static ComponentSectionViewModel get linearSection => ComponentSectionViewModel(
        id: 'progress.section.linear',
        title: 'Progresso Linear',
        description: 'Diferentes estilos de barras de progresso',
        groups: [
          ComponentGroupViewModel.column(
            id: 'progress.section.linear.column',
            components: [linearBasic],
          ),
        ],
      );

  static ComponentSectionViewModel get circularSection => ComponentSectionViewModel(
        id: 'progress.section.circular',
        title: 'Progresso Circular',
        description: 'Indicadores circulares de progresso',
        groups: [
          ComponentGroupViewModel.row(
            id: 'progress.section.circular.row',
            components: [circularBasic, circularWithText, circularIndeterminate],
            spacing: 24,
          ),
        ],
      );

  static ComponentSectionViewModel get sizesSection => ComponentSectionViewModel(
        id: 'progress.section.sizes',
        title: 'Tamanhos',
        description: 'Diferentes tamanhos disponíveis',
        groups: [
          ComponentGroupViewModel.column(
            id: 'progress.section.sizes.column',
            components: [linearSmall, linearDefault, linearLarge],
            spacing: 16,
          ),
        ],
      );

  static ComponentSectionViewModel get stepsSection => ComponentSectionViewModel(
        id: 'progress.section.steps',
        title: 'Progresso por Etapas',
        description: 'Progresso dividido em etapas específicas',
        groups: [
          ComponentGroupViewModel.column(
            id: 'progress.section.steps.column',
            components: [stepsPersonalInfo, stepsUpload],
            spacing: 20,
          ),
        ],
      );

  static ComponentCategoryViewModel get category => ComponentCategoryViewModel(
        id: 'progress',
        title: 'Progresso',
        sections: [
          linearSection,
          circularSection,
          sizesSection,
          stepsSection,
        ],
      );
}
