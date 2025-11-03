import 'package:flutter/material.dart';

import 'package:designsystemsampleapp/design_system/components/component_models.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_button.dart';

class ButtonComponentLibrary {
	ButtonComponentLibrary._();

	static final ComponentViewModel _baseButton = ComponentViewModel(
		id: 'button.base',
		title: 'Botão Base',
		description: 'Configuração base para botões Shadcn.',
		overrides: <String, dynamic>{
			'label': 'Botão',
			'variant': ShadcnButtonVariant.default_,
			'size': ShadcnButtonSize.default_,
			'loading': false,
			'disabled': false,
			'leadingIconBuilder': null,
			'trailingIconBuilder': null,
			'iconBuilder': null,
			'onPressed': null,
		},
		builder: (context, viewModel, props) {
			final label = props['label'] as String?;
			final loading = props['loading'] as bool? ?? false;
			final disabled = props['disabled'] as bool? ?? false;
			final onPressed = props['onPressed'] as VoidCallback? ?? () {};
			final leadingIconBuilder = props['leadingIconBuilder'] as WidgetBuilder?;
			final trailingIconBuilder = props['trailingIconBuilder'] as WidgetBuilder?;
			final iconBuilder = props['iconBuilder'] as WidgetBuilder?;

			return ShadcnButton(
				text: label,
				variant: props['variant'] as ShadcnButtonVariant? ?? ShadcnButtonVariant.default_,
				size: props['size'] as ShadcnButtonSize? ?? ShadcnButtonSize.default_,
				loading: loading,
				disabled: disabled,
				leadingIcon: leadingIconBuilder?.call(context),
				trailingIcon: trailingIconBuilder?.call(context),
				icon: iconBuilder?.call(context),
				onPressed: disabled || loading ? null : onPressed,
			);
		},
	);

	static ComponentViewModel _button({
		required String id,
		required String title,
		String? description,
		Map<String, dynamic> overrides = const <String, dynamic>{},
	}) {
		return _baseButton.derive(
			id: id,
			title: title,
			description: description,
			overrides: overrides,
		);
	}

	static final ComponentViewModel primary = _button(
		id: 'button.primary',
		title: 'Primário',
		overrides: <String, dynamic>{
			'label': 'Primário',
			'onPressed': () {},
		},
	);

	static final ComponentViewModel secondary = _button(
		id: 'button.secondary',
		title: 'Secundário',
		overrides: <String, dynamic>{
			'label': 'Secundário',
			'variant': ShadcnButtonVariant.secondary,
			'onPressed': () {},
		},
	);

	static final ComponentViewModel destructive = _button(
		id: 'button.destructive',
		title: 'Destrutivo',
		overrides: <String, dynamic>{
			'label': 'Destrutivo',
			'variant': ShadcnButtonVariant.destructive,
			'onPressed': () {},
		},
	);

	static final ComponentViewModel outline = _button(
		id: 'button.outline',
		title: 'Outline',
		overrides: <String, dynamic>{
			'label': 'Outline',
			'variant': ShadcnButtonVariant.outline,
			'onPressed': () {},
		},
	);

	static final ComponentViewModel leadingDownload = _button(
		id: 'button.leading.download',
		title: 'Download',
		overrides: <String, dynamic>{
			'label': 'Download',
			'leadingIconBuilder': (BuildContext context) {
				final colorScheme = Theme.of(context).colorScheme;
				return Icon(Icons.download, color: colorScheme.onPrimary);
			},
			'onPressed': () {},
		},
	);

	static final ComponentViewModel leadingSend = _button(
		id: 'button.leading.send',
		title: 'Enviar',
		overrides: <String, dynamic>{
			'label': 'Enviar',
			'variant': ShadcnButtonVariant.outline,
			'leadingIconBuilder': (BuildContext context) {
				final colorScheme = Theme.of(context).colorScheme;
				return Icon(Icons.send, color: colorScheme.onSurfaceVariant);
			},
			'onPressed': () {},
		},
	);

	static final ComponentViewModel iconFavorite = _button(
		id: 'button.icon.favorite',
		title: 'Favorito',
		overrides: <String, dynamic>{
			'label': null,
			'size': ShadcnButtonSize.icon,
			'iconBuilder': (BuildContext context) {
				final colorScheme = Theme.of(context).colorScheme;
				return Icon(Icons.favorite, color: colorScheme.onPrimary);
			},
			'onPressed': () {},
		},
	);

	static final ComponentViewModel _stateBase = _baseButton.derive(
		id: 'button.state.base',
		title: 'Estado Base',
		overrides: <String, dynamic>{
			'stateTitle': 'Estado',
			'stateDescription': '',
		},
		builder: (context, viewModel, props) {
			final colorScheme = Theme.of(context).colorScheme;
			final button = viewModel.parent!.builder(context, viewModel, props);

			return Container(
				padding: const EdgeInsets.all(16),
				decoration: BoxDecoration(
					color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
					borderRadius: BorderRadius.circular(8),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							props['stateTitle'] as String,
							style: Theme.of(context).textTheme.titleSmall?.copyWith(
										color: colorScheme.onSurface,
										fontWeight: FontWeight.w600,
									),
						),
						const SizedBox(height: 12),
						button,
					],
				),
			);
		},
	);

	static final ComponentViewModel stateNormal = _stateBase.derive(
		id: 'button.state.normal',
		title: 'Normal',
		overrides: <String, dynamic>{
			'stateTitle': 'Normal',
			'label': 'Ativo',
			'loading': false,
			'disabled': false,
		},
	);

	static final ComponentViewModel stateLoading = _stateBase.derive(
		id: 'button.state.loading',
		title: 'Loading',
		overrides: <String, dynamic>{
			'stateTitle': 'Loading',
			'label': 'Carregando...',
			'loading': true,
		},
	);

	static final ComponentViewModel stateDisabled = _stateBase.derive(
		id: 'button.state.disabled',
		title: 'Desabilitado',
		overrides: <String, dynamic>{
			'stateTitle': 'Desabilitado',
			'label': 'Desabilitado',
			'disabled': true,
		},
	);

	static final ComponentViewModel sizeSmall = _button(
		id: 'button.size.small',
		title: 'Pequeno',
		overrides: <String, dynamic>{
			'label': 'Pequeno',
			'size': ShadcnButtonSize.sm,
		},
	);

	static final ComponentViewModel sizeDefault = _button(
		id: 'button.size.default',
		title: 'Padrão',
		overrides: const <String, dynamic>{
			'label': 'Padrão',
		},
	);

	static final ComponentViewModel sizeLarge = _button(
		id: 'button.size.large',
		title: 'Grande',
		overrides: <String, dynamic>{
			'label': 'Grande',
			'size': ShadcnButtonSize.lg,
		},
	);

		static ComponentSectionViewModel get variantsSection => ComponentSectionViewModel(
					id: 'buttons.variants',
					title: 'Variantes',
					groups: [
						ComponentGroupViewModel.row(
							id: 'buttons.variants.row1',
							components: [primary, secondary],
							spacing: 12,
							expandChildren: true,
						),
						ComponentGroupViewModel.row(
							id: 'buttons.variants.row2',
							components: [destructive, outline],
							spacing: 12,
							expandChildren: true,
						),
					],
				);

	static ComponentSectionViewModel get iconSection => ComponentSectionViewModel(
				id: 'buttons.icons',
				title: 'Com Ícones',
				groups: [
								ComponentGroupViewModel.row(
						id: 'buttons.icons.row1',
						components: [leadingDownload, leadingSend],
						spacing: 12,
						expandChildren: true,
					),
					ComponentGroupViewModel.column(
						id: 'buttons.icons.column1',
									components: [iconFavorite],
						crossAxisAlignment: CrossAxisAlignment.start,
					),
				],
			);

	static ComponentSectionViewModel get statesSection => ComponentSectionViewModel(
				id: 'buttons.states',
				title: 'Estados',
							groups: [
					ComponentGroupViewModel.column(
						id: 'buttons.states.column',
						components: [stateNormal, stateLoading, stateDisabled],
						spacing: 16,
					),
				],
			);

	static ComponentSectionViewModel get sizesSection => ComponentSectionViewModel(
				id: 'buttons.sizes',
				title: 'Tamanhos',
							groups: [
					ComponentGroupViewModel.row(
						id: 'buttons.sizes.row',
						components: [sizeSmall, sizeDefault, sizeLarge],
						spacing: 12,
					),
				],
			);

	static ComponentCategoryViewModel get category => ComponentCategoryViewModel(
				id: 'buttons',
				title: 'Botões',
				sections: [
					variantsSection,
					iconSection,
					statesSection,
					sizesSection,
				],
			);
}
