import 'package:flutter/material.dart';
enum ShadcnButtonVariant {
  default_,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}
enum ShadcnButtonSize {
  default_,
  sm,
  lg,
  icon,
}
class ShadcnButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ShadcnButtonVariant variant;
  final ShadcnButtonSize size;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? icon; 
  final bool loading;
  final bool disabled;
  final bool autofocus;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Duration? animationDuration;
  final Widget? loadingWidget;
  final double? elevation;
  const ShadcnButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant = ShadcnButtonVariant.default_,
    this.size = ShadcnButtonSize.default_,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.autofocus = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.gradient,
    this.boxShadow,
    this.animationDuration,
    this.loadingWidget,
    this.elevation,
  }) : assert(text != null || child != null || icon != null, 'Either text, child, or icon must be provided');
  const ShadcnButton.withLeadingIcon({
    super.key,
    required this.text,
    required this.leadingIcon,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant = ShadcnButtonVariant.default_,
    this.size = ShadcnButtonSize.default_,
    this.loading = false,
    this.disabled = false,
    this.autofocus = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.gradient,
    this.boxShadow,
    this.animationDuration,
    this.loadingWidget,
    this.elevation,
  }) : child = null,
       trailingIcon = null,
       icon = null;
  const ShadcnButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant = ShadcnButtonVariant.default_,
    this.size = ShadcnButtonSize.icon,
    this.loading = false,
    this.disabled = false,
    this.autofocus = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.gradient,
    this.boxShadow,
    this.animationDuration,
    this.loadingWidget,
    this.elevation,
  }) : text = null,
       child = null,
       leadingIcon = null,
       trailingIcon = null;
  const ShadcnButton.loading({
    super.key,
    this.text,
    this.child,
    this.variant = ShadcnButtonVariant.default_,
    this.size = ShadcnButtonSize.default_,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.loadingWidget,
  }) : onPressed = null,
       onLongPress = null,
       onHover = null,
       onFocusChange = null,
       leadingIcon = null,
       trailingIcon = null,
       icon = null,
       loading = true,
       disabled = false,
       autofocus = false,
       gradient = null,
       boxShadow = null,
       animationDuration = null,
       elevation = null;

  @override
  State<ShadcnButton> createState() => _ShadcnButtonState();
}

class _ShadcnButtonState extends State<ShadcnButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false; // Used for press state tracking in gesture callbacks
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color bgColor = widget.backgroundColor ?? _getBackgroundColor(colorScheme);
    Color fgColor = widget.foregroundColor ?? _getForegroundColor(colorScheme);
    Color? bColor = widget.borderColor ?? _getBorderColor(colorScheme);
    EdgeInsets buttonPadding = widget.padding ?? _getPadding();
    double buttonHeight = widget.height ?? _getHeight();
    double fontSize = _getFontSize();
    BorderRadius buttonBorderRadius = widget.borderRadius ?? BorderRadius.circular(12); 
    if (widget.disabled || widget.loading) {
      bgColor = bgColor.withValues(alpha: 0.5);
      fgColor = fgColor.withValues(alpha: 0.5);
    }
    if (_isHovered && !widget.disabled && !widget.loading) {
      bgColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.1), bgColor);
    }
    Widget buttonChild = _buildButtonContent(fgColor, fontSize);
    Widget button = Container(
      width: widget.width,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: buttonBorderRadius,
        border: bColor != null 
            ? Border.all(color: bColor, width: widget.borderWidth ?? 1) 
            : null,
        boxShadow: widget.boxShadow ?? (widget.elevation != null ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: widget.elevation!,
            offset: Offset(0, widget.elevation! / 2),
          )
        ] : null),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: buttonBorderRadius,
        child: InkWell(
          onTap: widget.disabled || widget.loading ? null : () {
            widget.onPressed?.call();
          },
          onLongPress: widget.disabled || widget.loading ? null : widget.onLongPress,
          onHover: (hovered) {
            setState(() => _isHovered = hovered);
            widget.onHover?.call(hovered);
          },
          onTapDown: (_) {
            if (!widget.disabled && !widget.loading) {
              setState(() => _isPressed = true);
              _scaleController.forward();
            }
          },
          onTapUp: (_) {
            if (!widget.disabled && !widget.loading) {
              setState(() => _isPressed = false);
              _scaleController.reverse();
            }
          },
          onTapCancel: () {
            if (!widget.disabled && !widget.loading) {
              setState(() => _isPressed = false);
              _scaleController.reverse();
            }
          },
          onFocusChange: widget.onFocusChange,
          borderRadius: buttonBorderRadius,
          autofocus: widget.autofocus,
          child: Container(
            padding: buttonPadding,
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
    return ScaleTransition(
      scale: _scaleAnimation,
      child: button,
    );
  }
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ShadcnButtonVariant.default_:
        return colorScheme.primary;
      case ShadcnButtonVariant.destructive:
        return colorScheme.error;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        return Colors.transparent;
      case ShadcnButtonVariant.secondary:
        return colorScheme.secondary;
      case ShadcnButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ShadcnButtonVariant.default_:
        return colorScheme.onPrimary;
      case ShadcnButtonVariant.destructive:
        return colorScheme.onError;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        return colorScheme.onSurface;
      case ShadcnButtonVariant.secondary:
        return colorScheme.onSecondary;
      case ShadcnButtonVariant.link:
        return colorScheme.primary;
    }
  }

  Color? _getBorderColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ShadcnButtonVariant.outline:
        return colorScheme.outline;
      default:
        return null;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ShadcnButtonSize.default_:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ShadcnButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ShadcnButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case ShadcnButtonSize.icon:
        return const EdgeInsets.all(8);
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case ShadcnButtonSize.default_:
        return 40;
      case ShadcnButtonSize.sm:
        return 36;
      case ShadcnButtonSize.lg:
        return 44;
      case ShadcnButtonSize.icon:
        return 40;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ShadcnButtonSize.default_:
        return 14;
      case ShadcnButtonSize.sm:
        return 12;
      case ShadcnButtonSize.lg:
        return 16;
      case ShadcnButtonSize.icon:
        return 14;
    }
  }

  Widget _buildButtonContent(Color fgColor, double fontSize) {
    if (widget.loading) {
      return widget.loadingWidget ?? SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }
    if (widget.size == ShadcnButtonSize.icon) {
      return IconTheme(
        data: IconThemeData(color: fgColor),
        child: widget.icon ?? const Icon(Icons.add),
      );
    }
    if (widget.child != null) {
      return widget.child!;
    }
    List<Widget> children = [];
    if (widget.leadingIcon != null) {
      children.add(
        IconTheme(
          data: IconThemeData(color: fgColor),
          child: widget.leadingIcon!,
        ),
      );
      children.add(const SizedBox(width: 8));
    }
    if (widget.text != null) {
      children.add(
        Text(
          widget.text!,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: fgColor,
          ),
        ),
      );
    }
    if (widget.trailingIcon != null) {
      children.add(const SizedBox(width: 8));
      children.add(
        IconTheme(
          data: IconThemeData(color: fgColor),
          child: widget.trailingIcon!,
        ),
      );
    }
    if (widget.icon != null && widget.leadingIcon == null && widget.trailingIcon == null && widget.size != ShadcnButtonSize.icon) {
      children.insert(0, IconTheme(
        data: IconThemeData(color: fgColor),
        child: widget.icon!,
      ));
      if (widget.text != null) {
        children.insert(1, const SizedBox(width: 8));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
