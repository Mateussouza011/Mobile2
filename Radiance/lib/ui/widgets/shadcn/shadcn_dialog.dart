import 'package:flutter/material.dart';

enum ShadcnDialogSize {
  sm,
  md,
  lg,
  xl,
  fullscreen,
}

class ShadcnDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final ShadcnDialogSize size;
  final bool dismissible;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? icon;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const ShadcnDialog({
    super.key,
    this.title,
    this.description,
    this.content,
    this.actions,
    this.size = ShadcnDialogSize.md,
    this.dismissible = true,
    this.padding,
    this.contentPadding,
    this.icon,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dialogSize = _getDialogSize(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: padding as EdgeInsets? ?? dialogSize.insetPadding as EdgeInsets?,
      child: Container(
        width: dialogSize.width,
        height: size == ShadcnDialogSize.fullscreen ? MediaQuery.of(context).size.height : null,
        constraints: dialogSize.constraints,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: size == ShadcnDialogSize.fullscreen ? null : BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || showCloseButton)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          color: colorScheme.primary,
                          size: 24,
                        ),
                        child: icon!,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              description!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        onPressed: onClose ?? () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            if (content != null)
              Flexible(
                child: Container(
                  padding: contentPadding ?? const EdgeInsets.all(24),
                  child: content!,
                ),
              ),
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!
                      .expand((action) => [action, const SizedBox(width: 8)])
                      .take(actions!.length * 2 - 1)
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _DialogSize _getDialogSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    switch (size) {
      case ShadcnDialogSize.sm:
        return _DialogSize(
          width: 400,
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          insetPadding: const EdgeInsets.all(16),
        );
      case ShadcnDialogSize.md:
        return _DialogSize(
          width: 500,
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          insetPadding: const EdgeInsets.all(16),
        );
      case ShadcnDialogSize.lg:
        return _DialogSize(
          width: 600,
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          insetPadding: const EdgeInsets.all(16),
        );
      case ShadcnDialogSize.xl:
        return _DialogSize(
          width: 800,
          constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
          insetPadding: const EdgeInsets.all(8),
        );
      case ShadcnDialogSize.fullscreen:
        return _DialogSize(
          width: double.infinity,
          constraints: const BoxConstraints(),
          insetPadding: EdgeInsets.zero,
        );
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required ShadcnDialog dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible && dialog.dismissible,
      builder: (context) => dialog,
    );
  }
}

class _DialogSize {
  final double width;
  final BoxConstraints constraints;
  final EdgeInsetsGeometry insetPadding;

  _DialogSize({
    required this.width,
    required this.constraints,
    required this.insetPadding,
  });
}
class ShadcnAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final bool isDestructive;

  const ShadcnAlertDialog({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Confirmar',
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShadcnDialog(
      title: title,
      description: description,
      size: ShadcnDialogSize.sm,
      showCloseButton: false,
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelText!),
          ),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive 
                ? colorScheme.error 
                : confirmColor ?? colorScheme.primary,
            foregroundColor: isDestructive 
                ? colorScheme.onError 
                : colorScheme.onPrimary,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ShadcnAlertDialog(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        isDestructive: isDestructive,
      ),
    );
  }
}
class ShadcnLoadingDialog extends StatelessWidget {
  final String? title;
  final String? description;

  const ShadcnLoadingDialog({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnDialog(
      title: title ?? 'Carregando...',
      description: description,
      size: ShadcnDialogSize.sm,
      showCloseButton: false,
      dismissible: false,
      content: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? description,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShadcnLoadingDialog(
        title: title,
        description: description,
      ),
    );
  }
}
class ShadcnBottomSheetDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showHandle;
  final double? height;

  const ShadcnBottomSheetDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showHandle = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Flexible(
            child: content,
          ),
          if (actions != null && actions!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .expand((action) => [action, const SizedBox(width: 8)])
                    .take(actions!.length * 2 - 1)
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool showHandle = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShadcnBottomSheetDialog(
        title: title,
        content: content,
        actions: actions,
        showHandle: showHandle,
        height: height,
      ),
    );
  }
}