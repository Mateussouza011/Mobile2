import 'package:flutter/material.dart';

enum ShadcnBadgeVariant {
  default_,
  secondary,
  destructive,
  outline,
  success,
  warning,
}

enum ShadcnBadgeSize {
  sm,
  md,
  lg,
}

class ShadcnBadge extends StatelessWidget {
  final String text;
  final ShadcnBadgeVariant variant;
  final ShadcnBadgeSize size;
  final Widget? icon;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const ShadcnBadge({
    super.key,
    required this.text,
    this.variant = ShadcnBadgeVariant.default_,
    this.size = ShadcnBadgeSize.md,
    this.icon,
    this.onTap,
    this.onClose,
    this.showCloseButton = false,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeColors = _getBadgeColors(colorScheme);
    final badgeSize = _getBadgeSize();

    Widget badge = Container(
      padding: padding ?? badgeSize.padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? badgeColors.backgroundColor,
        borderRadius: borderRadius ?? badgeSize.borderRadius,
        border: variant == ShadcnBadgeVariant.outline
            ? Border.all(color: borderColor ?? badgeColors.borderColor)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: textColor ?? badgeColors.textColor,
                size: badgeSize.iconSize,
              ),
              child: icon!,
            ),
            SizedBox(width: badgeSize.spacing),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? badgeSize.fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor ?? badgeColors.textColor,
              height: 1.2,
            ),
          ),
          if (showCloseButton && onClose != null) ...[
            SizedBox(width: badgeSize.spacing),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                size: badgeSize.iconSize,
                color: (textColor ?? badgeColors.textColor).withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      badge = GestureDetector(
        onTap: onTap,
        child: badge,
      );
    }

    return badge;
  }

  _BadgeColors _getBadgeColors(ColorScheme colorScheme) {
    switch (variant) {
      case ShadcnBadgeVariant.default_:
        return _BadgeColors(
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          borderColor: colorScheme.primary,
        );
      case ShadcnBadgeVariant.secondary:
        return _BadgeColors(
          backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
          textColor: colorScheme.secondary,
          borderColor: colorScheme.secondary,
        );
      case ShadcnBadgeVariant.destructive:
        return _BadgeColors(
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
          borderColor: colorScheme.error,
        );
      case ShadcnBadgeVariant.outline:
        return _BadgeColors(
          backgroundColor: Colors.transparent,
          textColor: colorScheme.onSurface,
          borderColor: colorScheme.outline,
        );
      case ShadcnBadgeVariant.success:
        return _BadgeColors(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          borderColor: Colors.green,
        );
      case ShadcnBadgeVariant.warning:
        return _BadgeColors(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          borderColor: Colors.orange,
        );
    }
  }

  _BadgeSize _getBadgeSize() {
    switch (size) {
      case ShadcnBadgeSize.sm:
        return _BadgeSize(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          fontSize: 10,
          iconSize: 12,
          spacing: 4,
          borderRadius: BorderRadius.circular(4),
        );
      case ShadcnBadgeSize.md:
        return _BadgeSize(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          fontSize: 12,
          iconSize: 14,
          spacing: 4,
          borderRadius: BorderRadius.circular(6),
        );
      case ShadcnBadgeSize.lg:
        return _BadgeSize(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          fontSize: 14,
          iconSize: 16,
          spacing: 6,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }
}

class _BadgeColors {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  _BadgeColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}

class _BadgeSize {
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double spacing;
  final BorderRadius borderRadius;

  _BadgeSize({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
  });
}
class ShadcnDotBadge extends StatelessWidget {
  final Widget child;
  final String? count;
  final bool showBadge;
  final Color? badgeColor;
  final Color? textColor;
  final double? size;
  final Alignment alignment;

  const ShadcnDotBadge({
    super.key,
    required this.child,
    this.count,
    this.showBadge = true,
    this.badgeColor,
    this.textColor,
    this.size,
    this.alignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeSize = size ?? (count != null && count!.isNotEmpty ? 18.0 : 8.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge)
          Positioned(
            top: alignment == Alignment.topRight || alignment == Alignment.topLeft ? -4 : null,
            bottom: alignment == Alignment.bottomRight || alignment == Alignment.bottomLeft ? -4 : null,
            right: alignment == Alignment.topRight || alignment == Alignment.bottomRight ? -4 : null,
            left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft ? -4 : null,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: badgeColor ?? colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
              child: count != null && count!.isNotEmpty
                  ? Center(
                      child: Text(
                        count!,
                        style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
class ShadcnStatusBadge extends StatelessWidget {
  final String status;
  final bool isOnline;
  final ShadcnBadgeSize size;

  const ShadcnStatusBadge({
    super.key,
    required this.status,
    required this.isOnline,
    this.size = ShadcnBadgeSize.md,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnBadge(
      text: status,
      variant: isOnline ? ShadcnBadgeVariant.success : ShadcnBadgeVariant.secondary,
      size: size,
      icon: Icon(
        isOnline ? Icons.circle : Icons.circle_outlined,
      ),
    );
  }
}
class ShadcnNumberBadge extends StatelessWidget {
  final int number;
  final int? maxCount;
  final ShadcnBadgeVariant variant;
  final ShadcnBadgeSize size;

  const ShadcnNumberBadge({
    super.key,
    required this.number,
    this.maxCount = 99,
    this.variant = ShadcnBadgeVariant.default_,
    this.size = ShadcnBadgeSize.md,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (maxCount != null && number > maxCount!) {
      displayText = '$maxCount+';
    } else {
      displayText = number.toString();
    }

    return ShadcnBadge(
      text: displayText,
      variant: variant,
      size: size,
    );
  }
}