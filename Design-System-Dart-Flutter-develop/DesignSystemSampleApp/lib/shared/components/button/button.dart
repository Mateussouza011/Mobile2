/// Button Component (shadcn/ui)
/// Implementação completa do componente Button seguindo design system
library;

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart' as colors;
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants/durations.dart';
import 'button_view_model.dart';
import 'button_delegate.dart';

/// Componente Button do Design System
/// 
/// Implementa todas as variantes do shadcn/ui:
/// - default: Background primary
/// - destructive: Background destructive (vermelho)
/// - outline: Borda com background transparente
/// - secondary: Background secondary
/// - ghost: Sem background, apenas texto
/// - link: Texto sem background, sublinhado no hover
/// 
/// Tamanhos disponíveis:
/// - sm: 36px altura
/// - default: 40px altura
/// - lg: 44px altura
/// - icon: 40x40px (apenas ícone)
/// 
/// Exemplo de uso:
/// ```dart
/// class MyScreen extends StatelessWidget implements ButtonDelegate {
///   @override
///   void onPressed() {
///     print('Clicked!');
///   }
///   
///   @override
///   Widget build(BuildContext context) {
///     return ButtonComponent(
///       viewModel: ButtonViewModel.text('Click me'),
///       delegate: this,
///     );
///   }
/// }
/// ```
class ButtonComponent extends StatefulWidget {
  final ButtonViewModel viewModel;
  final ButtonDelegate? delegate;

  const ButtonComponent({
    Key? key,
    required this.viewModel,
    this.delegate,
  }) : super(key: key);

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = widget.viewModel;

    // Calcular se o botão está interativo
    final isInteractive = vm.enabled && !vm.loading && widget.delegate != null;

    // Obter cores baseadas na variante e tema
    final buttonColors = _getButtonColors(vm.variant, isDark);

    // Obter dimensões baseadas no tamanho
    final dimensions = _getButtonDimensions(vm.size);

    Widget content = _buildContent(vm, buttonColors, dimensions, isDark);

    // Aplicar largura se especificada
    if (vm.fullWidth) {
      content = SizedBox(width: double.infinity, child: content);
    } else if (vm.width != null) {
      content = SizedBox(width: vm.width, child: content);
    }

    return MouseRegion(
      onEnter: isInteractive ? (_) => setState(() => _isHovered = true) : null,
      onExit: isInteractive ? (_) => setState(() => _isHovered = false) : null,
      cursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isInteractive ? _handleTap : null,
        onLongPress: isInteractive ? _handleLongPress : null,
        onTapDown: isInteractive ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isInteractive ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isInteractive ? () => setState(() => _isPressed = false) : null,
        child: AnimatedContainer(
          duration: durationFast,
          height: dimensions.height,
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.paddingHorizontal,
            vertical: dimensions.paddingVertical,
          ),
          decoration: BoxDecoration(
            color: _getBackgroundColor(buttonColors, isInteractive),
            border: vm.variant == ButtonVariant.outline
                ? Border.all(
                    color: isDark ? colors.borderDark : colors.border,
                    width: 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: vm.variant != ButtonVariant.ghost && 
                       vm.variant != ButtonVariant.link && 
                       _isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent(
    ButtonViewModel vm,
    _ButtonColors colors,
    _ButtonDimensions dimensions,
    bool isDark,
  ) {
    final textColor = _getTextColor(colors, vm.enabled && !vm.loading);
    final iconSize = dimensions.iconSize;

    // Modo loading: mostrar spinner
    if (vm.loading) {
      return Center(
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    // Apenas ícone
    if (vm.text == null && vm.leadingIcon != null) {
      return Icon(
        vm.leadingIcon,
        size: iconSize,
        color: textColor,
      );
    }

    // Texto com ícones opcionais
    final textStyle = dimensions.textStyle.copyWith(
      color: textColor,
      decoration: vm.variant == ButtonVariant.link && _isHovered
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (vm.leadingIcon != null) ...[
          Icon(
            vm.leadingIcon,
            size: iconSize,
            color: textColor,
          ),
          SizedBox(width: spacing2),
        ],
        if (vm.text != null)
          Text(
            vm.text!,
            style: textStyle,
          ),
        if (vm.trailingIcon != null) ...[
          SizedBox(width: spacing2),
          Icon(
            vm.trailingIcon,
            size: iconSize,
            color: textColor,
          ),
        ],
      ],
    );
  }

  Color _getBackgroundColor(_ButtonColors colors, bool isInteractive) {
    if (!widget.viewModel.enabled || widget.viewModel.loading) {
      return colors.disabled;
    }

    if (_isPressed) {
      return colors.pressed;
    }

    if (_isHovered) {
      return colors.hover;
    }

    return colors.normal;
  }

  Color _getTextColor(_ButtonColors colors, bool isEnabled) {
    return isEnabled ? colors.foreground : colors.foregroundDisabled;
  }

  _ButtonColors _getButtonColors(ButtonVariant variant, bool isDark) {
    switch (variant) {
      case ButtonVariant.defaultVariant:
        return _ButtonColors(
          normal: isDark ? colors.primaryDark : colors.primary,
          hover: isDark ? colors.primaryDark.withOpacity(0.9) : colors.primary.withOpacity(0.9),
          pressed: isDark ? colors.primaryDark.withOpacity(0.8) : colors.primary.withOpacity(0.8),
          disabled: isDark ? colors.mutedDark : colors.muted,
          foreground: isDark ? colors.primaryForegroundDark : colors.primaryForeground,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );

      case ButtonVariant.destructive:
        return _ButtonColors(
          normal: isDark ? colors.destructiveDark : colors.destructive,
          hover: isDark ? colors.destructiveDark.withOpacity(0.9) : colors.destructive.withOpacity(0.9),
          pressed: isDark ? colors.destructiveDark.withOpacity(0.8) : colors.destructive.withOpacity(0.8),
          disabled: isDark ? colors.mutedDark : colors.muted,
          foreground: isDark ? colors.destructiveForegroundDark : colors.destructiveForeground,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );

      case ButtonVariant.outline:
        return _ButtonColors(
          normal: Colors.transparent,
          hover: isDark ? colors.accentDark : colors.accent,
          pressed: isDark ? colors.accentDark.withOpacity(0.8) : colors.accent.withOpacity(0.8),
          disabled: Colors.transparent,
          foreground: isDark ? colors.foregroundDark : colors.foreground,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );

      case ButtonVariant.secondary:
        return _ButtonColors(
          normal: isDark ? colors.secondaryDark : colors.secondary,
          hover: isDark ? colors.secondaryDark.withOpacity(0.8) : colors.secondary.withOpacity(0.8),
          pressed: isDark ? colors.secondaryDark.withOpacity(0.7) : colors.secondary.withOpacity(0.7),
          disabled: isDark ? colors.mutedDark : colors.muted,
          foreground: isDark ? colors.secondaryForegroundDark : colors.secondaryForeground,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );

      case ButtonVariant.ghost:
        return _ButtonColors(
          normal: Colors.transparent,
          hover: isDark ? colors.accentDark : colors.accent,
          pressed: isDark ? colors.accentDark.withOpacity(0.8) : colors.accent.withOpacity(0.8),
          disabled: Colors.transparent,
          foreground: isDark ? colors.foregroundDark : colors.foreground,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );

      case ButtonVariant.link:
        return _ButtonColors(
          normal: Colors.transparent,
          hover: Colors.transparent,
          pressed: Colors.transparent,
          disabled: Colors.transparent,
          foreground: isDark ? colors.primaryDark : colors.primary,
          foregroundDisabled: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
        );
    }
  }

  _ButtonDimensions _getButtonDimensions(ButtonSize size) {
    switch (size) {
      case ButtonSize.sm:
        return _ButtonDimensions(
          height: 36,
          paddingHorizontal: spacing3,
          paddingVertical: 0,
          iconSize: 16,
          textStyle: bodySmall,
        );

      case ButtonSize.defaultSize:
        return _ButtonDimensions(
          height: 40,
          paddingHorizontal: spacing4,
          paddingVertical: spacing2,
          iconSize: 18,
          textStyle: bodyBase,
        );

      case ButtonSize.lg:
        return _ButtonDimensions(
          height: 44,
          paddingHorizontal: spacing6,
          paddingVertical: spacing2,
          iconSize: 20,
          textStyle: bodyLarge,
        );

      case ButtonSize.icon:
        return _ButtonDimensions(
          height: 40,
          paddingHorizontal: 0,
          paddingVertical: 0,
          iconSize: 18,
          textStyle: bodyBase,
        );
    }
  }

  void _handleTap() {
    if (widget.delegate != null) {
      widget.delegate!.onPressed();
    }
  }

  void _handleLongPress() {
    if (widget.delegate != null) {
      widget.delegate!.onLongPress();
    }
  }
}

/// Classe auxiliar para armazenar cores do botão
class _ButtonColors {
  final Color normal;
  final Color hover;
  final Color pressed;
  final Color disabled;
  final Color foreground;
  final Color foregroundDisabled;

  const _ButtonColors({
    required this.normal,
    required this.hover,
    required this.pressed,
    required this.disabled,
    required this.foreground,
    required this.foregroundDisabled,
  });
}

/// Classe auxiliar para armazenar dimensões do botão
class _ButtonDimensions {
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;
  final double iconSize;
  final TextStyle textStyle;

  const _ButtonDimensions({
    required this.height,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.iconSize,
    required this.textStyle,
  });
}
