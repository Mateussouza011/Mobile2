import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'button_view_model.dart';
import 'button_delegate.dart';

class ShadcnButtonView extends StatefulWidget {
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

  const ShadcnButtonView({
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
  }) : assert(
          text != null || child != null || icon != null,
          'Either text, child, or icon must be provided',
        );

  const ShadcnButtonView.withLeadingIcon({
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
  })  : child = null,
        trailingIcon = null,
        icon = null;

  const ShadcnButtonView.icon({
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
  })  : text = null,
        child = null,
        leadingIcon = null,
        trailingIcon = null;

  const ShadcnButtonView.loading({
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
  })  : onPressed = null,
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
  State<ShadcnButtonView> createState() => _ShadcnButtonViewState();
}

class _ShadcnButtonViewState extends State<ShadcnButtonView>
    with SingleTickerProviderStateMixin {
  late final ShadcnButtonViewModel _viewModel;
  late final ShadcnButtonService _service;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _viewModel = ShadcnButtonViewModel();
    _viewModel.setVariant(widget.variant);
    _viewModel.setSize(widget.size);
    _viewModel.setLoading(widget.loading);
    _viewModel.setDisabled(widget.disabled);

    _service = ShadcnButtonService(
      viewModel: _viewModel,
      onPressedCallback: widget.onPressed,
      onLongPressCallback: widget.onLongPress,
      onHoverCallback: widget.onHover,
      onFocusCallback: widget.onFocusChange,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(ShadcnButtonView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.variant != oldWidget.variant) {
      _viewModel.setVariant(widget.variant);
    }
    if (widget.size != oldWidget.size) {
      _viewModel.setSize(widget.size);
    }
    if (widget.loading != oldWidget.loading) {
      _viewModel.setLoading(widget.loading);
    }
    if (widget.disabled != oldWidget.disabled) {
      _viewModel.setDisabled(widget.disabled);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ShadcnButtonViewModel>(
        builder: (context, viewModel, child) {
          return _buildButton(context, viewModel);
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, ShadcnButtonViewModel viewModel) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bgColor = widget.backgroundColor ?? viewModel.getBackgroundColor(colorScheme);
    Color fgColor = widget.foregroundColor ?? viewModel.getForegroundColor(colorScheme);
    Color? bColor = widget.borderColor ?? viewModel.getBorderColor(colorScheme);

    EdgeInsets buttonPadding = widget.padding ?? viewModel.getPadding();
    double buttonHeight = widget.height ?? viewModel.getHeight();
    double fontSize = viewModel.getFontSize();
    BorderRadius buttonBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    Widget buttonChild = _buildButtonContent(fgColor, fontSize, viewModel);

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
        boxShadow: widget.boxShadow ??
            (widget.elevation != null
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: widget.elevation!,
                      offset: Offset(0, widget.elevation! / 2),
                    )
                  ]
                : null),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: buttonBorderRadius,
        child: InkWell(
          onTap: viewModel.isInteractive ? () => _service.onPressed() : null,
          onLongPress: viewModel.isInteractive ? () => _service.onLongPress() : null,
          onHover: (hovered) => _service.onHoverChanged(hovered),
          onTapDown: (_) {
            if (viewModel.isInteractive) {
              viewModel.setPressed(true);
              _scaleController.forward();
            }
          },
          onTapUp: (_) {
            if (viewModel.isInteractive) {
              viewModel.setPressed(false);
              _scaleController.reverse();
            }
          },
          onTapCancel: () {
            if (viewModel.isInteractive) {
              viewModel.setPressed(false);
              _scaleController.reverse();
            }
          },
          onFocusChange: (hasFocus) => _service.onFocusChanged(hasFocus),
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

  Widget _buildButtonContent(
    Color fgColor,
    double fontSize,
    ShadcnButtonViewModel viewModel,
  ) {
    if (viewModel.isLoading) {
      return widget.loadingWidget ??
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          );
    }

    if (viewModel.size == ShadcnButtonSize.icon) {
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

    if (widget.icon != null &&
        widget.leadingIcon == null &&
        widget.trailingIcon == null &&
        viewModel.size != ShadcnButtonSize.icon) {
      children.insert(
        0,
        IconTheme(
          data: IconThemeData(color: fgColor),
          child: widget.icon!,
        ),
      );
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
