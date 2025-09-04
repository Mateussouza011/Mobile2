import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

/// Enumeração para diferentes variantes do botão
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

/// Enumeração para diferentes tamanhos do botão
enum ButtonSize {
  small,
  medium,
  large,
  icon,
}

/// Delegate para customização do botão
abstract class ButtonDelegate {
  Color getBackgroundColor(ButtonVariant variant, bool isHovered, bool isPressed);
  Color getForegroundColor(ButtonVariant variant);
  EdgeInsets getPadding(ButtonSize size);
  double getBorderRadius();
  TextStyle getTextStyle(ButtonSize size);
}

/// Implementação padrão do delegate
class DefaultButtonDelegate implements ButtonDelegate {
  @override
  Color getBackgroundColor(ButtonVariant variant, bool isHovered, bool isPressed) {
    switch (variant) {
      case ButtonVariant.primary:
        if (isPressed) return ShadcnColors.primary.withValues(alpha: 0.9);
        if (isHovered) return ShadcnColors.primary.withValues(alpha: 0.95);
        return ShadcnColors.primary;
      case ButtonVariant.secondary:
        if (isPressed) return ShadcnColors.secondary.withValues(alpha: 0.8);
        if (isHovered) return ShadcnColors.secondary.withValues(alpha: 0.9);
        return ShadcnColors.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        if (isPressed) return ShadcnColors.accent.withValues(alpha: 0.8);
        if (isHovered) return ShadcnColors.accent.withValues(alpha: 0.9);
        return Colors.transparent;
      case ButtonVariant.destructive:
        if (isPressed) return ShadcnColors.destructive.withValues(alpha: 0.9);
        if (isHovered) return ShadcnColors.destructive.withValues(alpha: 0.95);
        return ShadcnColors.destructive;
    }
  }

  @override
  Color getForegroundColor(ButtonVariant variant) {
    switch (variant) {
      case ButtonVariant.primary:
        return ShadcnColors.primaryForeground;
      case ButtonVariant.secondary:
        return ShadcnColors.secondaryForeground;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return ShadcnColors.foreground;
      case ButtonVariant.destructive:
        return ShadcnColors.destructiveForeground;
    }
  }

  @override
  EdgeInsets getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 12);
      case ButtonSize.icon:
        return const EdgeInsets.all(8);
    }
  }

  @override
  double getBorderRadius() => 6.0;

  @override
  TextStyle getTextStyle(ButtonSize size) {
    final baseStyle = ShadcnTypography.getTextTheme().labelMedium!;
    switch (size) {
      case ButtonSize.small:
        return baseStyle.copyWith(fontSize: 12);
      case ButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14);
      case ButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
      case ButtonSize.icon:
        return baseStyle;
    }
  }
}

/// Botão personalizado inspirado no shadcn/ui
class ShadcnButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonDelegate? delegate;

  const ShadcnButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.delegate,
  }) : assert(
          (text != null && child == null) ||
          (text == null && child != null) ||
          (icon != null && text == null && child == null),
          'Forneça apenas text, child ou icon',
        );

  @override
  State<ShadcnButton> createState() => _ShadcnButtonState();
}

class _ShadcnButtonState extends State<ShadcnButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  late ButtonDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = widget.delegate ?? DefaultButtonDelegate();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _delegate.getBackgroundColor(
      widget.variant,
      _isHovered,
      _isPressed,
    );
    final foregroundColor = _delegate.getForegroundColor(widget.variant);
    final padding = _delegate.getPadding(widget.size);
    final borderRadius = _delegate.getBorderRadius();
    final textStyle = _delegate.getTextStyle(widget.size);

    Widget buttonChild;

    if (widget.isLoading) {
      buttonChild = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    } else if (widget.icon != null) {
      buttonChild = Icon(
        widget.icon,
        color: foregroundColor,
        size: widget.size == ButtonSize.small ? 16 : 20,
      );
    } else {
      final List<Widget> children = [];

      if (widget.leadingIcon != null) {
        children.add(Icon(
          widget.leadingIcon,
          color: foregroundColor,
          size: 16,
        ));
        children.add(const SizedBox(width: 8));
      }

      if (widget.text != null) {
        children.add(Text(
          widget.text!,
          style: textStyle.copyWith(color: foregroundColor),
        ));
      } else if (widget.child != null) {
        children.add(widget.child!);
      }

      if (widget.trailingIcon != null) {
        children.add(const SizedBox(width: 8));
        children.add(Icon(
          widget.trailingIcon,
          color: foregroundColor,
          size: 16,
        ));
      }

      buttonChild = children.length == 1
          ? children.first
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: widget.variant == ButtonVariant.outline
                ? Border.all(color: ShadcnColors.border)
                : null,
          ),
          child: buttonChild,
        ),
      ),
    );
  }
}
