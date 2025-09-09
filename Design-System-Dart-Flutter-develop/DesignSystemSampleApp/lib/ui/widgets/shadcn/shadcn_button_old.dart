import 'package:flutter/material.dart';

/// Variantes do botão Shadcn/UI
enum ShadcnButtonVariant {
  default_,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

/// Tamanhos do botão Shadcn/UI
enum ShadcnButtonSize {
  default_,
  sm,
  lg,
  icon,
}

/// Componente Button baseado no Shadcn/UI - Versão Genérica e Flexível
class ShadcnButton extends StatelessWidget {
  // Conteúdo principal
  final String? text;
  final Widget? child;
  
  // Comportamento
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  
  // Estilo visual
  final ShadcnButtonVariant variant;
  final ShadcnButtonSize size;
  
  // Ícones flexíveis
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? icon; // Para botões icon-only (retrocompatibilidade)
  
  // Estados
  final bool loading;
  final bool disabled;
  final bool autofocus;
  
  // Customização avançada
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
  
  // Animação e feedback
  final Duration? animationDuration;
  final Widget? loadingWidget;
  final double? elevation;
  
  // Construtores
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

  // Construtor nomeado para botão com ícone à esquerda
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

  // Construtor nomeado para botão apenas com ícone
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

  // Construtor nomeado para loading
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determinar cores baseadas na variante ou customização
    Color bgColor = backgroundColor ?? _getBackgroundColor(colorScheme);
    Color fgColor = foregroundColor ?? _getForegroundColor(colorScheme);
    Color? bColor = borderColor ?? _getBorderColor(colorScheme);
    
    // Determinar tamanho e padding
    EdgeInsets buttonPadding = padding ?? _getPadding();
    double buttonHeight = height ?? _getHeight();
    double fontSize = _getFontSize();
    BorderRadius buttonBorderRadius = borderRadius ?? BorderRadius.circular(6);
    
    // Estado desabilitado ou loading
    if (disabled || loading) {
      bgColor = bgColor.withOpacity(0.5);
      fgColor = fgColor.withOpacity(0.5);
    }

    // Widget de conteúdo
    Widget buttonChild = _buildButtonContent(fgColor, fontSize);

    // Container principal
    Widget button = Container(
      width: width,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: gradient == null ? bgColor : null,
        gradient: gradient,
        borderRadius: buttonBorderRadius,
        border: bColor != null 
            ? Border.all(color: bColor, width: borderWidth ?? 1) 
            : null,
        boxShadow: boxShadow ?? (elevation != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation!,
            offset: Offset(0, elevation! / 2),
          )
        ] : null),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: buttonBorderRadius,
        child: InkWell(
          onTap: disabled || loading ? null : onPressed,
          onLongPress: disabled || loading ? null : onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          borderRadius: buttonBorderRadius,
          autofocus: autofocus,
          child: Container(
            padding: buttonPadding,
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );

    // Aplicar animação se especificada
    if (animationDuration != null) {
      button = AnimatedContainer(
        duration: animationDuration!,
        child: button,
      );
    }

    return button;
  }

  // Métodos auxiliares para determinar cores baseadas na variante
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ShadcnButtonVariant.default_:
        return colorScheme.primary;
      case ShadcnButtonVariant.destructive:
        return colorScheme.error;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        return Colors.transparent;
      case ShadcnButtonVariant.secondary:
        return colorScheme.surfaceVariant;
      case ShadcnButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ShadcnButtonVariant.default_:
        return colorScheme.onPrimary;
      case ShadcnButtonVariant.destructive:
        return colorScheme.onError;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        return colorScheme.onSurface;
      case ShadcnButtonVariant.secondary:
        return colorScheme.onSurfaceVariant;
      case ShadcnButtonVariant.link:
        return colorScheme.primary;
    }
  }

  Color? _getBorderColor(ColorScheme colorScheme) {
    switch (variant) {
      case ShadcnButtonVariant.outline:
        return colorScheme.outline;
      default:
        return null;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
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
    switch (size) {
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
    switch (size) {
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

    Widget buttonChild;
    if (loading) {
      buttonChild = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    } else if (size == ShadcnButtonSize.icon) {
      buttonChild = IconTheme(
        data: IconThemeData(color: foregroundColor),
        child: icon ?? const Icon(Icons.add),
      );
    } else {
      List<Widget> children = [];
      
      if (icon != null) {
        children.add(
          IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: icon!,
          ),
        );
        children.add(const SizedBox(width: 8));
      }
      
      children.add(
        Text(
          text ?? '',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: foregroundColor,
          ),
        ),
      );
      
      if (child != null) {
        children = [child!];
      }
      
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return SizedBox(
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: disabled || loading ? null : onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: padding,
            decoration: borderColor != null
                ? BoxDecoration(
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}
