/// Factory para criar instâncias pré-configuradas de Button
/// Facilita a criação de buttons comuns sem precisar configurar ViewModels
library;

import 'package:flutter/material.dart';
import 'button.dart';
import 'button_view_model.dart';
import 'button_delegate.dart';

/// Factory para criar Buttons com configurações pré-definidas
/// 
/// Esta classe fornece métodos estáticos convenientes para criar
/// buttons comuns sem precisar instanciar ViewModels manualmente.
/// 
/// Exemplo de uso:
/// ```dart
/// ButtonFactory.primary(
///   text: 'Save',
///   delegate: this,
/// )
/// ```
class ButtonFactory {
  ButtonFactory._(); // Construtor privado para prevenir instanciação

  // ==================== VARIANTES PRINCIPAIS ====================

  /// Cria um button com variante primary (padrão)
  static Widget primary({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.defaultVariant,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com variante destructive (vermelho)
  static Widget destructive({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.destructive,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com variante outline (borda)
  static Widget outline({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.outline,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com variante secondary
  static Widget secondary({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.secondary,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com variante ghost (transparente)
  static Widget ghost({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.ghost,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com variante link (texto sublinhado)
  static Widget link({
    required String text,
    required ButtonDelegate delegate,
    IconData? leadingIcon,
    IconData? trailingIcon,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        variant: ButtonVariant.link,
        size: size,
        enabled: enabled,
        loading: loading,
      ),
      delegate: delegate,
    );
  }

  // ==================== BUTTONS COM ÍCONES ====================

  /// Cria um button apenas com ícone (icon button)
  static Widget icon({
    required IconData icon,
    required ButtonDelegate delegate,
    ButtonVariant variant = ButtonVariant.defaultVariant,
    bool enabled = true,
    bool loading = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel.iconOnly(
        icon,
        variant: variant,
        enabled: enabled,
        loading: loading,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button com ícone e texto (leading icon)
  static Widget withIcon({
    required String text,
    required IconData icon,
    required ButtonDelegate delegate,
    ButtonVariant variant = ButtonVariant.defaultVariant,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: icon,
        variant: variant,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  // ==================== BUTTONS ESPECIALIZADOS ====================

  /// Cria um button de submit/save (primary + ícone check)
  static Widget save({
    String text = 'Save',
    required ButtonDelegate delegate,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: loading ? null : Icons.check,
        variant: ButtonVariant.defaultVariant,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button de delete (destructive + ícone trash)
  static Widget delete({
    String text = 'Delete',
    required ButtonDelegate delegate,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: loading ? null : Icons.delete_outline,
        variant: ButtonVariant.destructive,
        size: size,
        enabled: enabled,
        loading: loading,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button de cancel (secondary + ícone close)
  static Widget cancel({
    String text = 'Cancel',
    required ButtonDelegate delegate,
    ButtonSize size = ButtonSize.defaultSize,
    bool enabled = true,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        leadingIcon: Icons.close,
        variant: ButtonVariant.secondary,
        size: size,
        enabled: enabled,
        fullWidth: fullWidth,
      ),
      delegate: delegate,
    );
  }

  /// Cria um button de loading (disabled + spinner)
  static Widget loading({
    String text = 'Loading...',
    ButtonVariant variant = ButtonVariant.defaultVariant,
    ButtonSize size = ButtonSize.defaultSize,
    bool fullWidth = false,
  }) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: text,
        variant: variant,
        size: size,
        enabled: true,
        loading: true,
        fullWidth: fullWidth,
      ),
      delegate: null,
    );
  }
}
