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

class ShadcnButtonViewModel extends ChangeNotifier {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isLoading = false;
  bool _isDisabled = false;
  ShadcnButtonVariant _variant = ShadcnButtonVariant.default_;
  ShadcnButtonSize _size = ShadcnButtonSize.default_;

  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;
  bool get isLoading => _isLoading;
  bool get isDisabled => _isDisabled;
  bool get isInteractive => !_isLoading && !_isDisabled;
  ShadcnButtonVariant get variant => _variant;
  ShadcnButtonSize get size => _size;

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      _isHovered = hovered;
      notifyListeners();
    }
  }

  void setPressed(bool pressed) {
    if (_isPressed != pressed) {
      _isPressed = pressed;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setDisabled(bool disabled) {
    if (_isDisabled != disabled) {
      _isDisabled = disabled;
      notifyListeners();
    }
  }

  void setVariant(ShadcnButtonVariant variant) {
    if (_variant != variant) {
      _variant = variant;
      notifyListeners();
    }
  }

  void setSize(ShadcnButtonSize size) {
    if (_size != size) {
      _size = size;
      notifyListeners();
    }
  }

  Color getBackgroundColor(ColorScheme colorScheme) {
    Color baseColor;
    switch (_variant) {
      case ShadcnButtonVariant.default_:
        baseColor = colorScheme.primary;
        break;
      case ShadcnButtonVariant.destructive:
        baseColor = colorScheme.error;
        break;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        baseColor = Colors.transparent;
        break;
      case ShadcnButtonVariant.secondary:
        baseColor = colorScheme.secondary;
        break;
      case ShadcnButtonVariant.link:
        baseColor = Colors.transparent;
        break;
    }

    if (!isInteractive) {
      baseColor = baseColor.withValues(alpha: 0.5);
    } else if (_isHovered) {
      baseColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.1), baseColor);
    }

    return baseColor;
  }

  Color getForegroundColor(ColorScheme colorScheme) {
    Color baseColor;
    switch (_variant) {
      case ShadcnButtonVariant.default_:
        baseColor = colorScheme.onPrimary;
        break;
      case ShadcnButtonVariant.destructive:
        baseColor = colorScheme.onError;
        break;
      case ShadcnButtonVariant.outline:
      case ShadcnButtonVariant.ghost:
        baseColor = colorScheme.onSurface;
        break;
      case ShadcnButtonVariant.secondary:
        baseColor = colorScheme.onSecondary;
        break;
      case ShadcnButtonVariant.link:
        baseColor = colorScheme.primary;
        break;
    }

    if (!isInteractive) {
      baseColor = baseColor.withValues(alpha: 0.5);
    }

    return baseColor;
  }

  Color? getBorderColor(ColorScheme colorScheme) {
    switch (_variant) {
      case ShadcnButtonVariant.outline:
        return colorScheme.outline;
      default:
        return null;
    }
  }

  EdgeInsets getPadding() {
    switch (_size) {
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

  double getHeight() {
    switch (_size) {
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

  double getFontSize() {
    switch (_size) {
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
}
