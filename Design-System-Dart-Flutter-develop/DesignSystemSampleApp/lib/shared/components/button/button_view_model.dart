/// ViewModel do Button
/// Define os dados imutáveis que configuram o Button
library;

import 'package:flutter/material.dart';

/// Variantes de estilo do Button (shadcn/ui)
enum ButtonVariant {
  /// Estilo padrão (background primary)
  defaultVariant,
  
  /// Estilo destrutivo (background destructive)
  destructive,
  
  /// Estilo outline (borda com background transparente)
  outline,
  
  /// Estilo secundário (background secondary)
  secondary,
  
  /// Estilo fantasma (sem background, apenas texto)
  ghost,
  
  /// Estilo link (texto sem background, sublinhado no hover)
  link,
}

/// Tamanhos do Button
enum ButtonSize {
  /// Tamanho pequeno (height: 36px, padding: 12px)
  sm,
  
  /// Tamanho padrão (height: 40px, padding: 16px)
  defaultSize,
  
  /// Tamanho grande (height: 44px, padding: 24px)
  lg,
  
  /// Tamanho para ícone apenas (height: 40px, width: 40px)
  icon,
}

/// ViewModel imutável do Button
/// 
/// Esta classe contém APENAS dados, sem lógica de negócio.
/// Segue o padrão MVVM onde ViewModel é puramente descritivo.
/// 
/// IMPORTANTE: NÃO usar Function() aqui! Use ButtonDelegate para eventos.
class ButtonViewModel {
  /// Texto do botão
  final String? text;
  
  /// Ícone à esquerda do texto
  final IconData? leadingIcon;
  
  /// Ícone à direita do texto
  final IconData? trailingIcon;
  
  /// Variante de estilo
  final ButtonVariant variant;
  
  /// Tamanho do botão
  final ButtonSize size;
  
  /// Se o botão está habilitado
  final bool enabled;
  
  /// Se o botão está em estado de loading
  final bool loading;
  
  /// Largura do botão (null = wrap content)
  final double? width;
  
  /// Se o botão deve ocupar toda a largura disponível
  final bool fullWidth;

  const ButtonViewModel({
    this.text,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = ButtonVariant.defaultVariant,
    this.size = ButtonSize.defaultSize,
    this.enabled = true,
    this.loading = false,
    this.width,
    this.fullWidth = false,
  }) : assert(
          text != null || leadingIcon != null || trailingIcon != null,
          'Button must have text or icon',
        );

  /// Cria uma cópia do ViewModel com valores modificados
  ButtonViewModel copyWith({
    String? text,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonVariant? variant,
    ButtonSize? size,
    bool? enabled,
    bool? loading,
    double? width,
    bool? fullWidth,
  }) {
    return ButtonViewModel(
      text: text ?? this.text,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
      variant: variant ?? this.variant,
      size: size ?? this.size,
      enabled: enabled ?? this.enabled,
      loading: loading ?? this.loading,
      width: width ?? this.width,
      fullWidth: fullWidth ?? this.fullWidth,
    );
  }

  /// Factory: Button padrão com texto
  factory ButtonViewModel.text(
    String text, {
    ButtonVariant variant = ButtonVariant.defaultVariant,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
  }) {
    return ButtonViewModel(
      text: text,
      variant: variant,
      size: size,
      enabled: enabled,
      loading: loading,
    );
  }

  /// Factory: Button com ícone e texto
  factory ButtonViewModel.icon(
    String text,
    IconData icon, {
    ButtonVariant variant = ButtonVariant.defaultVariant,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
  }) {
    return ButtonViewModel(
      text: text,
      leadingIcon: icon,
      variant: variant,
      size: size,
      enabled: enabled,
      loading: loading,
    );
  }

  /// Factory: Button apenas com ícone
  factory ButtonViewModel.iconOnly(
    IconData icon, {
    ButtonVariant variant = ButtonVariant.defaultVariant,
    bool enabled = true,
    bool loading = false,
  }) {
    return ButtonViewModel(
      leadingIcon: icon,
      variant: variant,
      size: ButtonSize.icon,
      enabled: enabled,
      loading: loading,
    );
  }
}
