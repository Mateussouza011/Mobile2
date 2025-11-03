import 'package:flutter/material.dart';

import 'package:designsystemsampleapp/design_system/components/component_models.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_button.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_card.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_separator.dart';

class CardComponentLibrary {
  CardComponentLibrary._();

  static ComponentViewModel _card({
    required String id,
    required String title,
    String description = '',
    required Widget Function(BuildContext) builder,
  }) {
    return ComponentViewModel(
      id: id,
      title: title,
      description: description,
      builder: (context, viewModel, props) => builder(context),
    );
  }

  static ComponentViewModel get simpleCard => _card(
        id: 'card.simple',
        title: 'Card Simples',
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Simples',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Conteúdo do card demonstrativo.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      );

  static ComponentViewModel get elevatedCard => _card(
        id: 'card.elevated',
        title: 'Card Elevado',
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            variant: ShadcnCardVariant.elevated,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Card Elevado',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          );
        },
      );

  static ComponentViewModel get filledCard => _card(
        id: 'card.filled',
        title: 'Card Preenchido',
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            variant: ShadcnCardVariant.filled,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Card Preenchido',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          );
        },
      );

  static ComponentViewModel get simpleActionCard => _card(
        id: 'card.simple.action',
        title: 'Card Simples com ação',
        builder: (context) {
          return ShadcnCard.simple(
            child: const Text('Este é um card simples com conteúdo básico.'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card simples tocado!')),
              );
            },
          );
        },
      );

  static ComponentViewModel get headerFooterCard => _card(
        id: 'card.header.footer',
        title: 'Card com Header e Footer',
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            title: 'Notificações',
            description: 'Você tem 3 mensagens não lidas.',
            header: const Row(
              children: [
                Icon(Icons.notifications_outlined),
                SizedBox(width: 8),
                Text('Sistema'),
              ],
            ),
            footer: Row(
              children: [
                ShadcnButton(
                  text: 'Marcar como lidas',
                  variant: ShadcnButtonVariant.ghost,
                  size: ShadcnButtonSize.sm,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificações marcadas!')),
                    );
                  },
                ),
              ],
            ),
            child: Text(
              'Apenas uma visualização rápida das suas notificações.',
              style: textTheme.bodyMedium,
            ),
          );
        },
      );

  static final ValueNotifier<bool> _expandNotifier = ValueNotifier<bool>(false);

  static ComponentViewModel get expandableCard => ComponentViewModel(
        id: 'card.expandable',
        title: 'Card Expansível',
        overrides: <String, dynamic>{
          'notifier': _expandNotifier,
        },
        builder: (context, viewModel, props) {
          final notifier = props['notifier'] as ValueNotifier<bool>;
          final textTheme = Theme.of(context).textTheme;

          return ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, expanded, _) {
              return ShadcnCard.expandable(
                title: 'Card Expansível',
                subtitle: 'Toque para expandir/recolher',
                leading: const Icon(Icons.info_outline),
                expanded: expanded,
                onExpandChanged: (value) => notifier.value = value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Conteúdo expandido aqui!'),
                    const SizedBox(height: 8),
                    Text(
                      'Este conteúdo só aparece quando o card está expandido.',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ShadcnButton(
                      text: 'Ação',
                      size: ShadcnButtonSize.sm,
                      variant: ShadcnButtonVariant.outline,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ação executada!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );

  static final ValueNotifier<bool> _selectionNotifier = ValueNotifier<bool>(false);

  static ComponentViewModel get selectableCard => ComponentViewModel(
        id: 'card.selectable',
        title: 'Card Selecionável',
        overrides: <String, dynamic>{
          'notifier': _selectionNotifier,
        },
        builder: (context, viewModel, props) {
          final notifier = props['notifier'] as ValueNotifier<bool>;
          final colorScheme = Theme.of(context).colorScheme;

          return ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, selected, _) {
              return ShadcnCard(
                title: 'Card Selecionável',
                description: 'Toque para selecionar/deselecionar',
                selectable: true,
                selected: selected,
                onSelectionChanged: (value) => notifier.value = value,
                variant: selected ? ShadcnCardVariant.filled : ShadcnCardVariant.outlined,
                leading: Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? colorScheme.primary : null,
                ),
              );
            },
          );
        },
      );

  static ComponentViewModel get horizontalLayoutCard => _card(
        id: 'card.horizontal.layout',
        title: 'Card Layout Horizontal',
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            layout: ShadcnCardLayout.horizontal,
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.onPrimary,
                size: 30,
              ),
            ),
            title: 'João Silva',
            subtitle: 'Desenvolvedor Flutter',
            description: 'Especialista em desenvolvimento mobile',
            trailing: Column(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text('4.9', style: textTheme.bodySmall),
              ],
            ),
            actions: [
              ShadcnButton.icon(
                icon: const Icon(Icons.message),
                size: ShadcnButtonSize.sm,
                variant: ShadcnButtonVariant.ghost,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enviando mensagem...')),
                  );
                },
              ),
              const SizedBox(width: 8),
              ShadcnButton.icon(
                icon: const Icon(Icons.phone),
                size: ShadcnButtonSize.sm,
                variant: ShadcnButtonVariant.ghost,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fazendo ligação...')),
                  );
                },
              ),
            ],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil de João Silva')),
              );
            },
          );
        },
      );

  static ComponentViewModel get separatorsBasicCard => _card(
        id: 'card.separators.basic',
        title: 'Separadores Básicos',
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Separadores Básicos',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const Text('Separador sólido:'),
                const SizedBox(height: 8),
                const ShadcnSeparator.horizontal(),
                const SizedBox(height: 12),
                const Text('Separador tracejado:'),
                const SizedBox(height: 8),
                const ShadcnSeparator.dashed(),
                const SizedBox(height: 12),
                const Text('Separador pontilhado:'),
                const SizedBox(height: 8),
                const ShadcnSeparator.dotted(),
                const SizedBox(height: 12),
                const Text('Separador com gradiente:'),
                const SizedBox(height: 8),
                ShadcnSeparator.gradient(
                  gradientColors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.primary,
                    Colors.transparent,
                  ],
                ),
              ],
            ),
          );
        },
      );

  static ComponentViewModel get separatorsLabelCard => _card(
        id: 'card.separators.label',
        title: 'Separadores com Labels',
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          return ShadcnCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Separadores com Labels',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                const ShadcnSeparator.horizontal(label: 'OU'),
                const SizedBox(height: 12),
                const ShadcnSeparator.horizontal(
                  label: 'CONTINUAR COM',
                  variant: ShadcnSeparatorVariant.dashed,
                ),
              ],
            ),
          );
        },
      );

  static ComponentViewModel get layoutSettingsCard => _card(
        id: 'card.layout.settings',
        title: 'Configurações Layout',
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          final colorScheme = Theme.of(context).colorScheme;
          return ShadcnCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configurações',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gerencie suas preferências',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                const ShadcnSeparator.horizontal(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Idioma', style: textTheme.bodyMedium),
                          Text(
                            'Português (Brasil)',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ShadcnButton(
                      text: 'Alterar',
                      variant: ShadcnButtonVariant.outline,
                      size: ShadcnButtonSize.sm,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alterando idioma...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

  static ComponentSectionViewModel get basicsSection => ComponentSectionViewModel(
        id: 'cards.section.basic',
        title: 'Básicos',
        groups: [
          ComponentGroupViewModel.column(
            id: 'cards.section.basic.column',
            components: [simpleCard],
          ),
        ],
      );

  static ComponentSectionViewModel get variationsSection => ComponentSectionViewModel(
        id: 'cards.section.variations',
        title: 'Variações',
        groups: [
          ComponentGroupViewModel.column(
            id: 'cards.section.variations.column',
            components: [elevatedCard, filledCard],
            spacing: 16,
          ),
        ],
      );

  static ComponentSectionViewModel get advancedSection => ComponentSectionViewModel(
        id: 'cards.section.advanced',
        title: 'Cards Avançados',
        groups: [
          ComponentGroupViewModel.column(
            id: 'cards.section.advanced.column',
            components: [
              simpleActionCard,
              headerFooterCard,
              expandableCard,
              selectableCard,
              horizontalLayoutCard,
            ],
            spacing: 16,
          ),
        ],
      );

  static ComponentSectionViewModel get layoutSection => ComponentSectionViewModel(
        id: 'cards.section.layout',
        title: 'Layout & Separadores',
        groups: [
          ComponentGroupViewModel.column(
            id: 'cards.section.layout.column',
            components: [
              separatorsBasicCard,
              separatorsLabelCard,
              layoutSettingsCard,
            ],
            spacing: 16,
          ),
        ],
      );

  static ComponentCategoryViewModel get category => ComponentCategoryViewModel(
        id: 'cards',
        title: 'Cards',
        sections: [
          basicsSection,
          variationsSection,
          advancedSection,
          layoutSection,
        ],
      );
}
