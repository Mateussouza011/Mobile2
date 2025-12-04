import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

enum ShadcnAlertType {
  info,
  success,
  warning,
  error,
}

enum ShadcnAlertVariant {
  default_,
  destructive,
  filled,
  outlined,
  minimal,
}

class ShadcnAlert extends StatefulWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final ShadcnAlertType type;
  final ShadcnAlertVariant variant;
  final Widget? action;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final Duration? autoDismiss;
  final bool showIcon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ShadcnAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.type = ShadcnAlertType.info,
    this.variant = ShadcnAlertVariant.default_,
    this.action,
    this.dismissible = false,
    this.onDismiss,
    this.autoDismiss,
    this.showIcon = true,
    this.padding,
    this.borderRadius,
  });

  @override
  State<ShadcnAlert> createState() => _ShadcnAlertState();
}

class _ShadcnAlertState extends State<ShadcnAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
    if (widget.autoDismiss != null) {
      Future.delayed(widget.autoDismiss!, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!_isVisible) return;
    
    setState(() {
      _isVisible = false;
    });

    _animationController.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final alertColors = _getAlertColors(colorScheme);
    final defaultIcon = _getDefaultIcon();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: _getDecoration(alertColors, colorScheme),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showIcon) ...[
                widget.icon ?? Icon(
                  defaultIcon,
                  color: _getIconColor(alertColors),
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _getTitleColor(alertColors, colorScheme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getDescriptionColor(alertColors, colorScheme),
                        ),
                      ),
                    ],
                    if (widget.action != null) ...[
                      const SizedBox(height: 12),
                      widget.action!,
                    ],
                  ],
                ),
              ),
              if (widget.dismissible) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: _dismiss,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: _getIconColor(alertColors),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _AlertColors _getAlertColors(ColorScheme colorScheme) {
    switch (widget.type) {
      case ShadcnAlertType.info:
        return _AlertColors(
          primary: colorScheme.primary,
          background: colorScheme.primary.withValues(alpha: 0.1),
          border: colorScheme.primary.withValues(alpha: 0.3),
        );
      case ShadcnAlertType.success:
        return _AlertColors(
          primary: ShadcnColors.success,
          background: ShadcnColors.success.withValues(alpha: 0.1),
          border: ShadcnColors.success.withValues(alpha: 0.3),
        );
      case ShadcnAlertType.warning:
        return _AlertColors(
          primary: ShadcnColors.warning,
          background: ShadcnColors.warning.withValues(alpha: 0.1),
          border: ShadcnColors.warning.withValues(alpha: 0.3),
        );
      case ShadcnAlertType.error:
        return _AlertColors(
          primary: colorScheme.error,
          background: colorScheme.error.withValues(alpha: 0.1),
          border: colorScheme.error.withValues(alpha: 0.3),
        );
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.type) {
      case ShadcnAlertType.info:
        return Icons.info_outline;
      case ShadcnAlertType.success:
        return Icons.check_circle_outline;
      case ShadcnAlertType.warning:
        return Icons.warning_amber_outlined;
      case ShadcnAlertType.error:
        return Icons.error_outline;
    }
  }

  BoxDecoration _getDecoration(_AlertColors colors, ColorScheme colorScheme) {
    if (widget.variant == ShadcnAlertVariant.destructive) {
      return BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error),
      );
    }

    switch (widget.variant) {
      case ShadcnAlertVariant.default_:
        return BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.border),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        );
      case ShadcnAlertVariant.filled:
        return BoxDecoration(
          color: colors.primary,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        );
      case ShadcnAlertVariant.outlined:
        return BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colors.primary, width: 1.5),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        );
      case ShadcnAlertVariant.minimal:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border(
            left: BorderSide(color: colors.primary, width: 4),
          ),
        );
      case ShadcnAlertVariant.destructive:
        return BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.1),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          border: Border.all(color: colorScheme.error),
        );
    }
  }

  Color _getIconColor(_AlertColors colors) {
    if (widget.variant == ShadcnAlertVariant.destructive) {
      return Theme.of(context).colorScheme.error;
    }

    switch (widget.variant) {
      case ShadcnAlertVariant.filled:
        return Colors.white;
      default:
        return colors.primary;
    }
  }

  Color _getTitleColor(_AlertColors colors, ColorScheme colorScheme) {
    if (widget.variant == ShadcnAlertVariant.destructive) {
      return colorScheme.error;
    }

    switch (widget.variant) {
      case ShadcnAlertVariant.filled:
        return Colors.white;
      default:
        return colorScheme.onSurface;
    }
  }

  Color _getDescriptionColor(_AlertColors colors, ColorScheme colorScheme) {
    if (widget.variant == ShadcnAlertVariant.destructive) {
      return colorScheme.onErrorContainer;
    }

    switch (widget.variant) {
      case ShadcnAlertVariant.filled:
        return Colors.white.withValues(alpha: 0.9);
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}

class _AlertColors {
  final Color primary;
  final Color background;
  final Color border;

  _AlertColors({
    required this.primary,
    required this.background,
    required this.border,
  });
}
class ShadcnAlertManager {
  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required String title,
    String? description,
    ShadcnAlertType type = ShadcnAlertType.info,
    ShadcnAlertVariant variant = ShadcnAlertVariant.default_,
    Widget? icon,
    Widget? action,
    bool dismissible = true,
    Duration? autoDismiss = const Duration(seconds: 4),
  }) {
    dismiss();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: ShadcnAlert(
            title: title,
            description: description,
            type: type,
            variant: variant,
            icon: icon,
            action: action,
            dismissible: dismissible,
            autoDismiss: autoDismiss,
            onDismiss: () {
              overlayEntry.remove();
              _currentOverlay = null;
            },
          ),
        ),
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
  }

  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
  static void showInfo({
    required BuildContext context,
    required String title,
    String? description,
    Widget? action,
    bool dismissible = true,
    Duration? autoDismiss = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: ShadcnAlertType.info,
      action: action,
      dismissible: dismissible,
      autoDismiss: autoDismiss,
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String title,
    String? description,
    Widget? action,
    bool dismissible = true,
    Duration? autoDismiss = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: ShadcnAlertType.success,
      action: action,
      dismissible: dismissible,
      autoDismiss: autoDismiss,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    String? description,
    Widget? action,
    bool dismissible = true,
    Duration? autoDismiss = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: ShadcnAlertType.warning,
      action: action,
      dismissible: dismissible,
      autoDismiss: autoDismiss,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    String? description,
    Widget? action,
    bool dismissible = true,
    Duration? autoDismiss = const Duration(seconds: 5),
  }) {
    show(
      context: context,
      title: title,
      description: description,
      type: ShadcnAlertType.error,
      action: action,
      dismissible: dismissible,
      autoDismiss: autoDismiss,
    );
  }
}