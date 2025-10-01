import 'package:flutter/material.dart';

/// Variantes visuais do chip
enum ShadcnChipVariant {
  default_,
  secondary,
  outline,
  destructive,
  success,
  warning,
}

/// Tamanhos do chip
enum ShadcnChipSize {
  sm,
  default_,
  lg,
}

/// Componente Chip baseado no Shadcn/UI
class ShadcnChip extends StatefulWidget {
  final String label;
  final Widget? avatar;
  final Widget? icon;
  final Widget? deleteIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final ShadcnChipVariant variant;
  final ShadcnChipSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool disabled;
  final bool selectable;
  final bool deletable;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final String? tooltip;

  const ShadcnChip({
    super.key,
    required this.label,
    this.avatar,
    this.icon,
    this.deleteIcon,
    this.onPressed,
    this.onDeleted,
    this.selected = false,
    this.onSelected,
    this.variant = ShadcnChipVariant.default_,
    this.size = ShadcnChipSize.default_,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.disabled = false,
    this.selectable = false,
    this.deletable = false,
    this.padding,
    this.borderRadius,
    this.tooltip,
  });

  /// Chip de filtro selecionável
  const ShadcnChip.filter({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    required this.onSelected,
    this.variant = ShadcnChipVariant.default_,
    this.size = ShadcnChipSize.default_,
    this.disabled = false,
    this.tooltip,
  }) : avatar = null,
       deleteIcon = null,
       onPressed = null,
       onDeleted = null,
       backgroundColor = null,
       foregroundColor = null,
       borderColor = null,
       selectable = true,
       deletable = false,
       padding = null,
       borderRadius = null;

  /// Chip removível
  const ShadcnChip.input({
    super.key,
    required this.label,
    this.avatar,
    required this.onDeleted,
    this.variant = ShadcnChipVariant.default_,
    this.size = ShadcnChipSize.default_,
    this.disabled = false,
    this.deleteIcon,
    this.tooltip,
  }) : icon = null,
       onPressed = null,
       selected = false,
       onSelected = null,
       backgroundColor = null,
       foregroundColor = null,
       borderColor = null,
       selectable = false,
       deletable = true,
       padding = null,
       borderRadius = null;

  /// Chip de ação
  const ShadcnChip.action({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.variant = ShadcnChipVariant.default_,
    this.size = ShadcnChipSize.default_,
    this.disabled = false,
    this.tooltip,
  }) : avatar = null,
       deleteIcon = null,
       onDeleted = null,
       selected = false,
       onSelected = null,
       backgroundColor = null,
       foregroundColor = null,
       borderColor = null,
       selectable = false,
       deletable = false,
       padding = null,
       borderRadius = null;

  @override
  State<ShadcnChip> createState() => _ShadcnChipState();
}

class _ShadcnChipState extends State<ShadcnChip> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.disabled) return;
    
    if (widget.selectable && widget.onSelected != null) {
      widget.onSelected!(!widget.selected);
    } else if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleDelete() {
    if (widget.disabled || widget.onDeleted == null) return;
    widget.onDeleted!();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Configurações baseadas no tamanho
    final chipHeight = switch (widget.size) {
      ShadcnChipSize.sm => 24.0,
      ShadcnChipSize.default_ => 32.0,
      ShadcnChipSize.lg => 40.0,
    };

    final textStyle = switch (widget.size) {
      ShadcnChipSize.sm => textTheme.bodySmall,
      ShadcnChipSize.default_ => textTheme.bodyMedium,
      ShadcnChipSize.lg => textTheme.bodyLarge,
    };

    final iconSize = switch (widget.size) {
      ShadcnChipSize.sm => 12.0,
      ShadcnChipSize.default_ => 16.0,
      ShadcnChipSize.lg => 20.0,
    };

    final avatarSize = switch (widget.size) {
      ShadcnChipSize.sm => 20.0,
      ShadcnChipSize.default_ => 24.0,
      ShadcnChipSize.lg => 32.0,
    };

    // Configurações de cor baseadas na variante
    final (backgroundColor, foregroundColor, borderColor) = _getColors(colorScheme);

    final chip = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: chipHeight,
            padding: widget.padding ?? EdgeInsets.symmetric(
              horizontal: switch (widget.size) {
                ShadcnChipSize.sm => 8.0,
                ShadcnChipSize.default_ => 12.0,
                ShadcnChipSize.lg => 16.0,
              },
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: widget.variant == ShadcnChipVariant.outline 
                  ? Border.all(color: borderColor, width: 1)
                  : null,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(chipHeight / 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar ou ícone à esquerda
                if (widget.avatar != null) ...[
                  SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: widget.avatar,
                  ),
                  const SizedBox(width: 8),
                ] else if (widget.icon != null) ...[
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: IconTheme(
                      data: IconThemeData(
                        color: foregroundColor,
                        size: iconSize,
                      ),
                      child: widget.icon!,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                
                // Label
                Flexible(
                  child: Text(
                    widget.label,
                    style: textStyle?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Ícone de remoção
                if (widget.deletable && widget.onDeleted != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _handleDelete,
                    child: SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: widget.deleteIcon ?? Icon(
                        Icons.close,
                        size: iconSize,
                        color: foregroundColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    Widget result = GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: _handleTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: widget.disabled ? 0.5 : 1.0,
          child: chip,
        ),
      ),
    );

    if (widget.tooltip != null) {
      result = Tooltip(
        message: widget.tooltip!,
        child: result,
      );
    }

    return result;
  }

  (Color, Color, Color) _getColors(ColorScheme colorScheme) {
    if (widget.backgroundColor != null && widget.foregroundColor != null) {
      return (
        widget.backgroundColor!,
        widget.foregroundColor!,
        widget.borderColor ?? colorScheme.outline,
      );
    }

    final isSelected = widget.selected;
    final isHovered = _isHovered;

    return switch (widget.variant) {
      ShadcnChipVariant.default_ => (
        isSelected || isHovered
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surface,
        isSelected ? colorScheme.primary : colorScheme.onSurface,
        colorScheme.outline,
      ),
      ShadcnChipVariant.secondary => (
        isSelected || isHovered
            ? colorScheme.secondary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest,
        isSelected ? colorScheme.secondary : colorScheme.onSurfaceVariant,
        colorScheme.outline,
      ),
      ShadcnChipVariant.outline => (
        isSelected || isHovered
            ? colorScheme.primary.withValues(alpha: 0.05)
            : Colors.transparent,
        isSelected ? colorScheme.primary : colorScheme.onSurface,
        isSelected ? colorScheme.primary : colorScheme.outline,
      ),
      ShadcnChipVariant.destructive => (
        isSelected || isHovered
            ? colorScheme.error.withValues(alpha: 0.1)
            : colorScheme.errorContainer,
        colorScheme.error,
        colorScheme.error,
      ),
      ShadcnChipVariant.success => (
        const Color(0xFFDCFCE7),
        const Color(0xFF166534),
        const Color(0xFF166534),
      ),
      ShadcnChipVariant.warning => (
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
        const Color(0xFF92400E),
      ),
    };
  }
}

/// Wrapper para múltiplos chips
class ShadcnChipGroup extends StatelessWidget {
  final List<ShadcnChip> chips;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;

  const ShadcnChipGroup({
    super.key,
    required this.chips,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: chips,
    );
  }
}