import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
enum CustomButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}
enum CustomButtonSize {
  small,
  medium,
  large,
}
abstract class CustomButtonDelegate {
  Color getBackgroundColor(CustomButtonVariant variant, bool isHovered, bool isPressed);
  Color getForegroundColor(CustomButtonVariant variant);
  Color getBorderColor(CustomButtonVariant variant);
  EdgeInsets getPadding(CustomButtonSize size);
  double getBorderRadius();
  TextStyle getTextStyle(CustomButtonSize size);
  double getElevation(CustomButtonVariant variant);
}
class DefaultCustomButtonDelegate implements CustomButtonDelegate {
  @override
  Color getBackgroundColor(CustomButtonVariant variant, bool isHovered, bool isPressed) {
    switch (variant) {
      case CustomButtonVariant.primary:
        if (isPressed) return ShadcnColors.primary.withValues(alpha: 0.9);
        if (isHovered) return ShadcnColors.primary.withValues(alpha: 0.95);
        return ShadcnColors.primary;
      case CustomButtonVariant.secondary:
        if (isPressed) return ShadcnColors.secondary.withValues(alpha: 0.8);
        if (isHovered) return ShadcnColors.secondary.withValues(alpha: 0.9);
        return ShadcnColors.secondary;
      case CustomButtonVariant.outline:
      case CustomButtonVariant.ghost:
        if (isPressed) return ShadcnColors.accent.withValues(alpha: 0.8);
        if (isHovered) return ShadcnColors.accent.withValues(alpha: 0.9);
        return Colors.transparent;
      case CustomButtonVariant.destructive:
        if (isPressed) return ShadcnColors.destructive.withValues(alpha: 0.9);
        if (isHovered) return ShadcnColors.destructive.withValues(alpha: 0.95);
        return ShadcnColors.destructive;
    }
  }

  @override
  Color getForegroundColor(CustomButtonVariant variant) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return ShadcnColors.primaryForeground;
      case CustomButtonVariant.secondary:
        return ShadcnColors.secondaryForeground;
      case CustomButtonVariant.outline:
      case CustomButtonVariant.ghost:
        return ShadcnColors.foreground;
      case CustomButtonVariant.destructive:
        return ShadcnColors.destructiveForeground;
    }
  }

  @override
  Color getBorderColor(CustomButtonVariant variant) {
    switch (variant) {
      case CustomButtonVariant.outline:
        return ShadcnColors.border;
      case CustomButtonVariant.primary:
      case CustomButtonVariant.secondary:
      case CustomButtonVariant.ghost:
      case CustomButtonVariant.destructive:
        return Colors.transparent;
    }
  }

  @override
  EdgeInsets getPadding(CustomButtonSize size) {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
  }

  @override
  double getBorderRadius() => 6.0;

  @override
  TextStyle getTextStyle(CustomButtonSize size) {
    final baseStyle = ShadcnTypography.getTextTheme().labelLarge!;
    switch (size) {
      case CustomButtonSize.small:
        return baseStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
      case CustomButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
      case CustomButtonSize.large:
        return baseStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
    }
  }

  @override
  double getElevation(CustomButtonVariant variant) {
    return 0.0; 
  }
}
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final CustomButtonDelegate? delegate;
  final double? width;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.delegate,
    this.width,
    this.isFullWidth = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  late CustomButtonDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = widget.delegate ?? DefaultCustomButtonDelegate();
  }

  bool get _isInteractionDisabled => 
      widget.isDisabled || widget.isLoading || widget.onPressed == null;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _delegate.getBackgroundColor(
      widget.variant,
      _isHovered && !_isInteractionDisabled,
      _isPressed && !_isInteractionDisabled,
    );
    final foregroundColor = _delegate.getForegroundColor(widget.variant);
    final borderColor = _delegate.getBorderColor(widget.variant);
    final padding = _delegate.getPadding(widget.size);
    final borderRadius = _delegate.getBorderRadius();
    final textStyle = _delegate.getTextStyle(widget.size);
    final elevation = _delegate.getElevation(widget.variant);

    Widget buttonChild;

    if (widget.isLoading) {
      buttonChild = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _isInteractionDisabled 
                ? foregroundColor.withValues(alpha: 0.6) 
                : foregroundColor,
          ),
        ),
      );
    } else {
      final List<Widget> children = [];

      if (widget.leadingIcon != null) {
        children.add(Icon(
          widget.leadingIcon,
          color: _isInteractionDisabled 
              ? foregroundColor.withValues(alpha: 0.6) 
              : foregroundColor,
          size: widget.size == CustomButtonSize.small ? 14 : 16,
        ));
        children.add(const SizedBox(width: 8));
      }

      children.add(Text(
        widget.text,
        style: textStyle.copyWith(
          color: _isInteractionDisabled 
              ? foregroundColor.withValues(alpha: 0.6) 
              : foregroundColor,
        ),
      ));

      if (widget.trailingIcon != null) {
        children.add(const SizedBox(width: 8));
        children.add(Icon(
          widget.trailingIcon,
          color: _isInteractionDisabled 
              ? foregroundColor.withValues(alpha: 0.6) 
              : foregroundColor,
          size: widget.size == CustomButtonSize.small ? 14 : 16,
        ));
      }

      buttonChild = Row(
        mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    final Widget button = MouseRegion(
      onEnter: _isInteractionDisabled ? null : (_) => setState(() => _isHovered = true),
      onExit: _isInteractionDisabled ? null : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _isInteractionDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: _isInteractionDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: _isInteractionDisabled ? null : () => setState(() => _isPressed = false),
        onTap: _isInteractionDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: widget.width ?? (widget.isFullWidth ? double.infinity : null),
          padding: padding,
          decoration: BoxDecoration(
            color: _isInteractionDisabled 
                ? backgroundColor.withValues(alpha: 0.6) 
                : backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderColor != Colors.transparent 
                ? Border.all(color: borderColor) 
                : null,
            boxShadow: elevation > 0 
                ? [BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: elevation,
                    offset: Offset(0, elevation / 2),
                  )]
                : null,
          ),
          child: buttonChild,
        ),
      ),
    );

    return button;
  }
}
