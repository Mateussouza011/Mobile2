import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';

/// ViewModel para componente de Input/TextField
class InputViewModel extends InteractiveComponentViewModel {
  /// Controller do texto
  final TextEditingController controller;
  
  /// Placeholder/Label do input
  final String placeholder;
  
  /// Se é um campo de senha
  final bool isPassword;
  
  /// Ícone no final do input
  final Widget? suffixIcon;
  
  /// Ícone no início do input
  final Widget? prefixIcon;
  
  /// Função de validação
  final String? Function(String?)? validator;
  
  /// Callback quando o texto muda
  final ValueChanged<String>? onChanged;
  
  /// Callback quando o campo é submetido
  final ValueChanged<String>? onSubmitted;
  
  /// Tipo de teclado
  final TextInputType keyboardType;
  
  /// Texto de ajuda/hint
  final String? helperText;
  
  /// Texto de erro
  final String? errorText;
  
  /// Número máximo de linhas
  final int? maxLines;
  
  /// Número mínimo de linhas
  final int minLines;
  
  /// Máximo de caracteres
  final int? maxLength;
  
  /// Se deve obscurecer o texto (para senhas)
  final bool obscureText;
  
  /// Cor da borda
  final Color? borderColor;
  
  /// Cor da borda quando focado
  final Color? focusedBorderColor;
  
  /// Cor de preenchimento
  final Color? fillColor;

  InputViewModel({
    required this.controller,
    required this.placeholder,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.helperText,
    this.errorText,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    super.isEnabled = true,
    super.autoFocus = false,
    super.onPressed,
    super.isLoading = false,
    super.id,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Cria uma cópia do ViewModel com valores atualizados
  InputViewModel copyWith({
    TextEditingController? controller,
    String? placeholder,
    bool? isPassword,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    TextInputType? keyboardType,
    String? helperText,
    String? errorText,
    int? maxLines,
    int? minLines,
    int? maxLength,
    bool? obscureText,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? fillColor,
    bool? isEnabled,
    bool? autoFocus,
    VoidCallback? onPressed,
    bool? isLoading,
    String? id,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return InputViewModel(
      controller: controller ?? this.controller,
      placeholder: placeholder ?? this.placeholder,
      isPassword: isPassword ?? this.isPassword,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      validator: validator ?? this.validator,
      onChanged: onChanged ?? this.onChanged,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      keyboardType: keyboardType ?? this.keyboardType,
      helperText: helperText ?? this.helperText,
      errorText: errorText ?? this.errorText,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      maxLength: maxLength ?? this.maxLength,
      obscureText: obscureText ?? this.obscureText,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      fillColor: fillColor ?? this.fillColor,
      isEnabled: isEnabled ?? this.isEnabled,
      autoFocus: autoFocus ?? this.autoFocus,
      onPressed: onPressed ?? this.onPressed,
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      width: width ?? this.width,
      height: height ?? this.height,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}
