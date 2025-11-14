/// ViewModel do Input
/// Define os dados imutáveis que configuram o Input
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tipos de input
enum InputType {
  /// Texto normal
  text,
  
  /// Password (obscured text)
  password,
  
  /// Email
  email,
  
  /// Número
  number,
  
  /// Telefone
  phone,
  
  /// Multiline (textarea)
  multiline,
}

/// ViewModel imutável do Input
/// 
/// Esta classe contém APENAS dados, sem lógica de negócio.
/// Segue o padrão MVVM onde ViewModel é puramente descritivo.
/// 
/// IMPORTANTE: NÃO usar Function() aqui! Use InputDelegate para eventos.
class InputViewModel {
  /// Texto inicial do input
  final String? initialValue;
  
  /// Placeholder do input
  final String? placeholder;
  
  /// Label do input (acima do campo)
  final String? label;
  
  /// Mensagem de erro
  final String? errorMessage;
  
  /// Mensagem de ajuda (abaixo do campo)
  final String? helperText;
  
  /// Tipo do input
  final InputType type;
  
  /// Se o input está habilitado
  final bool enabled;
  
  /// Se o input é readonly
  final bool readonly;
  
  /// Se o input é obrigatório
  final bool required;
  
  /// Número máximo de linhas (para multiline)
  final int? maxLines;
  
  /// Número máximo de caracteres
  final int? maxLength;
  
  /// Ícone leading (à esquerda)
  final IconData? leadingIcon;
  
  /// Ícone trailing (à direita)
  final IconData? trailingIcon;
  
  /// Prefixo de texto
  final String? prefix;
  
  /// Sufixo de texto
  final String? suffix;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  const InputViewModel({
    this.initialValue,
    this.placeholder,
    this.label,
    this.errorMessage,
    this.helperText,
    this.type = InputType.text,
    this.enabled = true,
    this.readonly = false,
    this.required = false,
    this.maxLines,
    this.maxLength,
    this.leadingIcon,
    this.trailingIcon,
    this.prefix,
    this.suffix,
    this.inputFormatters,
  });

  /// Verifica se o input tem erro
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  /// Cria uma cópia do ViewModel com valores modificados
  InputViewModel copyWith({
    String? initialValue,
    String? placeholder,
    String? label,
    String? errorMessage,
    String? helperText,
    InputType? type,
    bool? enabled,
    bool? readonly,
    bool? required,
    int? maxLines,
    int? maxLength,
    IconData? leadingIcon,
    IconData? trailingIcon,
    String? prefix,
    String? suffix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return InputViewModel(
      initialValue: initialValue ?? this.initialValue,
      placeholder: placeholder ?? this.placeholder,
      label: label ?? this.label,
      errorMessage: errorMessage,
      helperText: helperText ?? this.helperText,
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      readonly: readonly ?? this.readonly,
      required: required ?? this.required,
      maxLines: maxLines ?? this.maxLines,
      maxLength: maxLength ?? this.maxLength,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      inputFormatters: inputFormatters ?? this.inputFormatters,
    );
  }

  /// Factory: Input de texto simples
  factory InputViewModel.text({
    String? placeholder,
    String? label,
    String? initialValue,
  }) {
    return InputViewModel(
      type: InputType.text,
      placeholder: placeholder,
      label: label,
      initialValue: initialValue,
    );
  }

  /// Factory: Input de password
  factory InputViewModel.password({
    String? placeholder,
    String? label,
  }) {
    return InputViewModel(
      type: InputType.password,
      placeholder: placeholder,
      label: label,
    );
  }

  /// Factory: Input de email
  factory InputViewModel.email({
    String? placeholder,
    String? label,
  }) {
    return InputViewModel(
      type: InputType.email,
      placeholder: placeholder ?? 'email@example.com',
      label: label,
    );
  }

  /// Factory: Input de número
  factory InputViewModel.number({
    String? placeholder,
    String? label,
  }) {
    return InputViewModel(
      type: InputType.number,
      placeholder: placeholder,
      label: label,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  /// Factory: Textarea (multiline)
  factory InputViewModel.textarea({
    String? placeholder,
    String? label,
    int maxLines = 4,
  }) {
    return InputViewModel(
      type: InputType.multiline,
      placeholder: placeholder,
      label: label,
      maxLines: maxLines,
    );
  }
}
