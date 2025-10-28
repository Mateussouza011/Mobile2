import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';

/// Tamanhos disponíveis para botões
enum ButtonSize {
  small,
  medium,
  large,
}

/// Estilos/variantes disponíveis para botões
enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  outline,
  ghost,
  destructive,
}

/// ViewModel para componente de botão
/// Herda de InteractiveComponentViewModel e IconComponentViewModel
class ButtonViewModel extends InteractiveComponentViewModel {
  /// Texto do botão
  final String text;
  
  /// Tamanho do botão
  final ButtonSize size;
  
  /// Variante/estilo do botão
  final ButtonVariant variant;
  
  /// Ícone do botão (opcional)
  final IconData? icon;
  
  /// Posição do ícone (leading ou trailing)
  final IconPosition iconPosition;
  
  /// Estilo de texto customizado
  final TextStyle? textStyle;
  
  /// Largura total (ocupa todo o espaço disponível)
  final bool fullWidth;
  
  /// Border radius customizado
  final BorderRadius? borderRadius;

  ButtonViewModel({
    required this.text,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.textStyle,
    this.fullWidth = false,
    this.borderRadius,
    super.onPressed,
    super.isLoading = false,
    super.isEnabled = true,
    super.autoFocus = false,
    super.id,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Cria uma cópia do ViewModel com valores atualizados
  ButtonViewModel copyWith({
    String? text,
    ButtonSize? size,
    ButtonVariant? variant,
    IconData? icon,
    IconPosition? iconPosition,
    TextStyle? textStyle,
    bool? fullWidth,
    BorderRadius? borderRadius,
    VoidCallback? onPressed,
    bool? isLoading,
    bool? isEnabled,
    bool? autoFocus,
    String? id,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return ButtonViewModel(
      text: text ?? this.text,
      size: size ?? this.size,
      variant: variant ?? this.variant,
      icon: icon ?? this.icon,
      iconPosition: iconPosition ?? this.iconPosition,
      textStyle: textStyle ?? this.textStyle,
      fullWidth: fullWidth ?? this.fullWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      onPressed: onPressed ?? this.onPressed,
      isLoading: isLoading ?? this.isLoading,
      isEnabled: isEnabled ?? this.isEnabled,
      autoFocus: autoFocus ?? this.autoFocus,
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

/// Posição do ícone no botão
enum IconPosition {
  leading,
  trailing,
}
