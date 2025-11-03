import 'package:flutter/material.dart';

import 'package:designsystemsampleapp/design_system/components/component_models.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_alert.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_button.dart';

class AlertComponentLibrary {
  AlertComponentLibrary._();

  static final ComponentViewModel _baseAlert = ComponentViewModel(
    id: 'alert.base',
    title: 'Alert Base',
    description: 'Modelo base para alerts.',
    overrides: <String, dynamic>{
      'alertTitle': 'Alert',
      'description': null,
      'type': ShadcnAlertType.info,
      'variant': ShadcnAlertVariant.default_,
      'actionBuilder': null,
      'dismissible': false,
      'onDismissBuilder': null,
      'autoDismiss': null,
      'showIcon': true,
      'iconBuilder': null,
    },
    builder: (context, viewModel, props) {
      final actionBuilder = props['actionBuilder'] as WidgetBuilder?;
      final iconBuilder = props['iconBuilder'] as WidgetBuilder?;
      final onDismissBuilder = props['onDismissBuilder'] as VoidCallback Function(BuildContext)?;

      return ShadcnAlert(
        title: props['alertTitle'] as String,
        description: props['description'] as String?,
        type: props['type'] as ShadcnAlertType? ?? ShadcnAlertType.info,
        variant: props['variant'] as ShadcnAlertVariant? ?? ShadcnAlertVariant.default_,
        action: actionBuilder?.call(context),
        dismissible: props['dismissible'] as bool? ?? false,
        onDismiss: onDismissBuilder?.call(context),
        autoDismiss: props['autoDismiss'] as Duration?,
        showIcon: props['showIcon'] as bool? ?? true,
        icon: iconBuilder?.call(context),
      );
    },
  );

  static ComponentViewModel _alert({
    required String id,
    required String title,
    String? description,
    Map<String, dynamic> overrides = const <String, dynamic>{},
  }) {
    return _baseAlert.derive(
      id: id,
      title: title,
      overrides: <String, dynamic>{
        'alertTitle': title,
        'description': description,
        ...overrides,
      },
    );
  }

  static final ComponentViewModel info = _alert(
    id: 'alert.info',
    title: 'Informação',
    description: 'Este é um alert informativo com informações úteis.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.info,
    },
  );

  static final ComponentViewModel success = _alert(
    id: 'alert.success',
    title: 'Sucesso',
    description: 'Operação realizada com sucesso!',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.success,
    },
  );

  static final ComponentViewModel warning = _alert(
    id: 'alert.warning',
    title: 'Atenção',
    description: 'Você deve prestar atenção nesta mensagem.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.warning,
    },
  );

  static final ComponentViewModel error = _alert(
    id: 'alert.error',
    title: 'Erro',
    description: 'Algo deu errado. Por favor, tente novamente.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.error,
    },
  );

  static final ComponentViewModel defaultVariant = _alert(
    id: 'alert.variant.default',
    title: 'Alert Padrão',
    description: 'Alert com estilo padrão.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.info,
      'variant': ShadcnAlertVariant.default_,
    },
  );

  static final ComponentViewModel filledVariant = _alert(
    id: 'alert.variant.filled',
    title: 'Alert Preenchido',
    description: 'Alert com fundo colorido.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.success,
      'variant': ShadcnAlertVariant.filled,
    },
  );

  static final ComponentViewModel outlinedVariant = _alert(
    id: 'alert.variant.outlined',
    title: 'Alert Contornado',
    description: 'Alert apenas com borda.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.warning,
      'variant': ShadcnAlertVariant.outlined,
    },
  );

  static final ComponentViewModel minimalVariant = _alert(
    id: 'alert.variant.minimal',
    title: 'Alert Minimal',
    description: 'Alert com estilo minimalista.',
    overrides: const <String, dynamic>{
      'type': ShadcnAlertType.error,
      'variant': ShadcnAlertVariant.minimal,
    },
  );

  static final ComponentViewModel destructiveVariant = _alert(
    id: 'alert.variant.destructive',
    title: 'Erro',
    description: 'Ocorreu um erro durante a operação.',
    overrides: <String, dynamic>{
      'variant': ShadcnAlertVariant.destructive,
      'iconBuilder': (BuildContext context) => const Icon(Icons.error_outline),
    },
  );

  static final ComponentViewModel withoutIcon = _alert(
    id: 'alert.noicon',
    title: 'Alert sem ícone',
    description: 'Este alert não tem ícone.',
    overrides: const <String, dynamic>{
      'showIcon': false,
    },
  );

  static final ComponentViewModel customIconUpload = _alert(
    id: 'alert.custom.upload',
    title: 'Upload Completo',
    description: 'Seu arquivo foi enviado com sucesso.',
    overrides: <String, dynamic>{
      'type': ShadcnAlertType.success,
      'iconBuilder': (BuildContext context) => const Icon(Icons.cloud_upload),
    },
  );

  static final ComponentViewModel customIconBattery = _alert(
    id: 'alert.custom.battery',
    title: 'Bateria Baixa',
    description: 'Conecte o dispositivo ao carregador.',
    overrides: <String, dynamic>{
      'type': ShadcnAlertType.warning,
      'iconBuilder': (BuildContext context) => const Icon(Icons.battery_alert),
    },
  );

  static final ComponentViewModel withActions = _alert(
    id: 'alert.actions',
    title: 'Nova Atualização Disponível',
    description: 'Uma nova versão do aplicativo está disponível.',
    overrides: <String, dynamic>{
      'type': ShadcnAlertType.info,
      'actionBuilder': (BuildContext context) {
        return Row(
          children: [
            ShadcnButton(
              text: 'Atualizar',
              size: ShadcnButtonSize.sm,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Atualizando...')),
                );
              },
            ),
            const SizedBox(width: 8),
            ShadcnButton(
              text: 'Mais tarde',
              size: ShadcnButtonSize.sm,
              variant: ShadcnButtonVariant.ghost,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lembrete definido')),
                );
              },
            ),
          ],
        );
      },
    },
  );

  static final ComponentViewModel dismissible = _alert(
    id: 'alert.dismissible',
    title: 'Alert Dismissible',
    description: 'Clique no X para fechar este alert.',
    overrides: <String, dynamic>{
      'type': ShadcnAlertType.success,
      'dismissible': true,
      'onDismissBuilder': (BuildContext context) {
        return () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alert fechado')),
          );
        };
      },
    },
  );

  static final ComponentViewModel _triggerBase = ComponentViewModel(
    id: 'alert.trigger.base',
    title: 'Trigger',
    overrides: <String, dynamic>{
      'label': 'Mostrar Alert',
      'type': ShadcnAlertType.info,
      'triggerTitle': 'Alert',
      'triggerDescription': null,
      'buttonVariant': ShadcnButtonVariant.outline,
    },
    builder: (context, viewModel, props) {
      final type = props['type'] as ShadcnAlertType? ?? ShadcnAlertType.info;
      final label = props['label'] as String;
      final buttonVariant = props['buttonVariant'] as ShadcnButtonVariant? ?? ShadcnButtonVariant.outline;
      final title = props['triggerTitle'] as String;
      final description = props['triggerDescription'] as String?;

      return ShadcnButton(
        text: label,
        variant: buttonVariant,
        onPressed: () {
          switch (type) {
            case ShadcnAlertType.info:
              ShadcnAlertManager.showInfo(
                context: context,
                title: title,
                description: description,
              );
              break;
            case ShadcnAlertType.success:
              ShadcnAlertManager.showSuccess(
                context: context,
                title: title,
                description: description,
              );
              break;
            case ShadcnAlertType.warning:
              ShadcnAlertManager.showWarning(
                context: context,
                title: title,
                description: description,
              );
              break;
            case ShadcnAlertType.error:
              ShadcnAlertManager.showError(
                context: context,
                title: title,
                description: description,
              );
              break;
          }
        },
      );
    },
  );

  static ComponentViewModel _trigger({
    required String id,
    required String label,
    required ShadcnAlertType type,
  }) {
    return _triggerBase.derive(
      id: id,
      title: label,
      overrides: <String, dynamic>{
        'label': label,
        'type': type,
        'triggerTitle': label,
        'triggerDescription': 'Este é um alert global de ${label.toLowerCase()}.',
      },
    );
  }

  static final ComponentViewModel triggerInfo = _trigger(
    id: 'alert.trigger.info',
    label: 'Info',
    type: ShadcnAlertType.info,
  );

  static final ComponentViewModel triggerSuccess = _trigger(
    id: 'alert.trigger.success',
    label: 'Sucesso',
    type: ShadcnAlertType.success,
  );

  static final ComponentViewModel triggerWarning = _trigger(
    id: 'alert.trigger.warning',
    label: 'Aviso',
    type: ShadcnAlertType.warning,
  );

  static final ComponentViewModel triggerError = _trigger(
    id: 'alert.trigger.error',
    label: 'Erro',
    type: ShadcnAlertType.error,
  );

  static ComponentSectionViewModel get typesSection => ComponentSectionViewModel(
        id: 'alerts.types',
        title: 'Tipos de Alert',
        description: 'Diferentes tipos para diferentes situações',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.types.column',
            components: [info, success, warning, error],
            spacing: 16,
          ),
        ],
      );

  static ComponentSectionViewModel get variantsSection => ComponentSectionViewModel(
        id: 'alerts.variants',
        title: 'Variantes',
        description: 'Diferentes estilos visuais',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.variants.column',
            components: [defaultVariant, filledVariant, outlinedVariant, minimalVariant],
            spacing: 16,
          ),
        ],
      );

  static ComponentSectionViewModel get actionsSection => ComponentSectionViewModel(
        id: 'alerts.actions',
        title: 'Com Ações',
        description: 'Alerts com botões de ação',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.actions.column',
            components: [withActions],
          ),
        ],
      );

  static ComponentSectionViewModel get dismissibleSection => ComponentSectionViewModel(
        id: 'alerts.dismissible',
        title: 'Dismissible',
        description: 'Alerts que podem ser fechados',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.dismissible.column',
            components: [dismissible],
          ),
        ],
      );

  static ComponentSectionViewModel get globalSection => ComponentSectionViewModel(
        id: 'alerts.global',
        title: 'Alerts Globais',
        description: 'Alerts que aparecem no topo da tela',
        groups: [
          ComponentGroupViewModel.wrap(
            id: 'alerts.global.wrap',
            components: [triggerInfo, triggerSuccess, triggerWarning, triggerError],
            spacing: 8,
            runSpacing: 8,
          ),
        ],
      );

  static ComponentSectionViewModel get legacySection => ComponentSectionViewModel(
        id: 'alerts.legacy',
        title: 'Legacy - Variante Destructive',
        description: 'Compatibilidade com versão anterior',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.legacy.column',
            components: [destructiveVariant],
          ),
        ],
      );

  static ComponentSectionViewModel get withoutIconSection => ComponentSectionViewModel(
        id: 'alerts.noicon',
        title: 'Sem Ícones',
        description: 'Alerts sem ícones',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.noicon.column',
            components: [withoutIcon],
          ),
        ],
      );

  static ComponentSectionViewModel get customIconsSection => ComponentSectionViewModel(
        id: 'alerts.custom',
        title: 'Ícones Personalizados',
        description: 'Alerts com ícones customizados',
        groups: [
          ComponentGroupViewModel.column(
            id: 'alerts.custom.column',
            components: [customIconUpload, customIconBattery],
            spacing: 16,
          ),
        ],
      );

  static ComponentCategoryViewModel get category => ComponentCategoryViewModel(
        id: 'alerts',
        title: 'Alerts',
        sections: [
          typesSection,
          variantsSection,
          actionsSection,
          dismissibleSection,
          globalSection,
          legacySection,
          withoutIconSection,
          customIconsSection,
        ],
      );
}
