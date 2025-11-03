import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:designsystemsampleapp/design_system/components/component_models.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_form.dart';
import 'package:designsystemsampleapp/ui/widgets/shadcn/shadcn_input.dart';

class InputComponentLibrary {
	InputComponentLibrary._();

	static final ComponentViewModel _baseInput = ComponentViewModel(
		id: 'input.base',
		title: 'Input Base',
		overrides: <String, dynamic>{
			'label': null,
			'placeholder': null,
			'helperText': null,
			'errorText': null,
			'initialValue': null,
			'controller': null,
			'enabled': true,
			'maxLines': null,
			'minLines': null,
			'inputType': ShadcnInputType.text,
			'variant': ShadcnInputVariant.default_,
			'size': ShadcnInputSize.default_,
			'obscureText': false,
			'obscureNotifier': null,
			'prefixBuilder': null,
			'suffixBuilder': null,
			'customBuilder': null,
			'inputFormatters': null,
		},
		builder: (context, viewModel, props) {
			final customBuilder = props['customBuilder'] as WidgetBuilder?;
			if (customBuilder != null) {
				return customBuilder(context);
			}

			final controller = props['controller'] as TextEditingController?;
			final prefixBuilder = props['prefixBuilder'] as WidgetBuilder?;
			final suffixBuilder = props['suffixBuilder'] as Widget Function(BuildContext, Map<String, dynamic>)?;
			final obscureNotifier = props['obscureNotifier'] as ValueNotifier<bool>?;
			final inputFormatters = props['inputFormatters'] as List<TextInputFormatter>?;

			Widget buildInput(bool obscureValue) {
				Widget? suffix;
				if (suffixBuilder != null) {
					suffix = suffixBuilder(
						context,
						<String, dynamic>{
							...props,
							'obscureValue': obscureValue,
							if (obscureNotifier != null)
								'toggleObscure': () => obscureNotifier.value = !obscureNotifier.value,
						},
					);
				}

				return ShadcnInput(
					label: props['label'] as String?,
					placeholder: props['placeholder'] as String?,
					helperText: props['helperText'] as String?,
					errorText: props['errorText'] as String?,
					controller: controller,
					initialValue: controller == null ? props['initialValue'] as String? : null,
					inputType: props['inputType'] as ShadcnInputType? ?? ShadcnInputType.text,
					variant: props['variant'] as ShadcnInputVariant? ?? ShadcnInputVariant.default_,
					size: props['size'] as ShadcnInputSize? ?? ShadcnInputSize.default_,
					obscureText: obscureValue,
					enabled: props['enabled'] as bool? ?? true,
					maxLines: props['maxLines'] as int?,
					minLines: props['minLines'] as int?,
					prefixIcon: prefixBuilder?.call(context),
					suffixIcon: suffix,
					inputFormatters: inputFormatters,
				);
			}

			if (obscureNotifier != null) {
				return ValueListenableBuilder<bool>(
					valueListenable: obscureNotifier,
					builder: (context, obscureValue, _) => buildInput(obscureValue),
				);
			}

			final obscureText = props['obscureText'] as bool? ?? false;
			return buildInput(obscureText);
		},
	);

	static ComponentViewModel _input({
		required String id,
		required String title,
		Map<String, dynamic> overrides = const <String, dynamic>{},
	}) {
		return _baseInput.derive(
			id: id,
			title: title,
			overrides: overrides,
		);
	}

	static final ComponentViewModel nameField = _input(
		id: 'input.name',
		title: 'Nome Completo',
		overrides: <String, dynamic>{
			'label': 'Nome Completo',
			'placeholder': 'Digite seu nome...',
			'prefixBuilder': (BuildContext context) => Icon(
						Icons.person_outline,
						color: Theme.of(context).colorScheme.onSurfaceVariant,
					),
		},
	);

	static final ComponentViewModel emailField = _input(
		id: 'input.email',
		title: 'Email',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnInput.email(
						label: 'Email',
						placeholder: 'exemplo@email.com',
					),
		},
	);

	static final ComponentViewModel passwordField = _input(
		id: 'input.password',
		title: 'Senha',
		overrides: <String, dynamic>{
			'label': 'Senha',
			'placeholder': 'Digite sua senha',
			'obscureNotifier': ValueNotifier<bool>(true),
			'suffixBuilder': (BuildContext context, Map<String, dynamic> data) {
				final toggle = data['toggleObscure'] as VoidCallback;
				final obscureValue = data['obscureValue'] as bool;
				final colorScheme = Theme.of(context).colorScheme;
				return IconButton(
					icon: Icon(
						obscureValue ? Icons.visibility_off : Icons.visibility,
						color: colorScheme.onSurfaceVariant,
					),
					onPressed: toggle,
				);
			},
			'prefixBuilder': (BuildContext context) => Icon(
						Icons.lock_outline,
						color: Theme.of(context).colorScheme.onSurfaceVariant,
					),
		},
	);

	static final ComponentViewModel searchField = _input(
		id: 'input.search',
		title: 'Busca',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnInput.search(
						placeholder: 'Buscar produtos...',
					),
		},
	);

	static final ComponentViewModel cpfField = _input(
		id: 'input.cpf',
		title: 'CPF',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnCpfInput(
						placeholder: '000.000.000-00',
					),
		},
	);

	static final ComponentViewModel cnpjField = _input(
		id: 'input.cnpj',
		title: 'CNPJ',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnCnpjInput(
						placeholder: '00.000.000/0000-00',
					),
		},
	);

	static final ComponentViewModel phoneField = _input(
		id: 'input.phone',
		title: 'Telefone',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnPhoneInput(
						placeholder: '(00) 00000-0000',
					),
		},
	);

	static final ComponentViewModel cepField = _input(
		id: 'input.cep',
		title: 'CEP',
		overrides: <String, dynamic>{
			'customBuilder': (BuildContext context) => const ShadcnCepInput(
						placeholder: '00000-000',
					),
		},
	);

	static final ComponentViewModel stateNormal = _input(
		id: 'input.state.normal',
		title: 'Estado Normal',
		overrides: <String, dynamic>{
			'label': 'Estado Normal',
			'placeholder': 'Campo normal',
			'helperText': 'Este campo está em estado normal',
		},
	);

	static final ComponentViewModel stateDisabled = _input(
		id: 'input.state.disabled',
		title: 'Estado Desabilitado',
		overrides: <String, dynamic>{
			'label': 'Estado Desabilitado',
			'initialValue': 'Campo desabilitado',
			'enabled': false,
			'helperText': 'Este campo está desabilitado',
		},
	);

	static final ComponentViewModel stateError = _input(
		id: 'input.state.error',
		title: 'Estado de Erro',
		overrides: <String, dynamic>{
			'label': 'Estado de Erro',
			'placeholder': 'Campo com erro',
			'errorText': 'Este campo contém um erro',
		},
	);

	static final ComponentViewModel stateTextarea = _input(
		id: 'input.state.textarea',
		title: 'Comentários',
		overrides: <String, dynamic>{
			'label': 'Comentários',
			'placeholder': 'Digite seus comentários...',
			'helperText': 'Máximo de 500 caracteres',
			'maxLines': 4,
		},
	);

	static ComponentSectionViewModel get basicsSection => ComponentSectionViewModel(
				id: 'inputs.basic',
				title: 'Inputs Básicos',
				description: 'Diferentes tipos e variações de campos de entrada',
				groups: [
					ComponentGroupViewModel.column(
						id: 'inputs.basic.column',
						components: [nameField, emailField, passwordField, searchField],
						spacing: 16,
					),
				],
			);

	static ComponentSectionViewModel get maskedSection => ComponentSectionViewModel(
				id: 'inputs.masked',
				title: 'Campos com Máscara',
				description: 'Inputs especializados com formatação automática',
				groups: [
					ComponentGroupViewModel.column(
						id: 'inputs.masked.column',
						components: [cpfField, cnpjField, phoneField, cepField],
						spacing: 16,
					),
				],
			);

	static ComponentSectionViewModel get statesSection => ComponentSectionViewModel(
				id: 'inputs.states',
				title: 'Estados dos Inputs',
				description: 'Diferentes estados visuais e de interação',
				groups: [
					ComponentGroupViewModel.column(
						id: 'inputs.states.column',
						components: [stateNormal, stateDisabled, stateError, stateTextarea],
						spacing: 16,
					),
				],
			);

	static ComponentCategoryViewModel get category => ComponentCategoryViewModel(
				id: 'inputs',
				title: 'Inputs',
				sections: [
					basicsSection,
					maskedSection,
					statesSection,
				],
			);
}
