import 'package:flutter/material.dart';

enum ShadcnCardVariant {
  default_,
  elevated,
  outlined,
  filled,
  ghost,
}

enum ShadcnCardSize {
  sm,
  default_,
  lg,
  xl,
}

enum ShadcnCardLayout {
  vertical,
  horizontal,
  grid,
  custom,
}

class ShadcnCardViewModel extends ChangeNotifier {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isSelected = false;
  bool _isExpanded = false;
  bool _isLoading = false;
  bool _isEnabled = true;

  ShadcnCardVariant _variant = ShadcnCardVariant.default_;
  ShadcnCardSize _size = ShadcnCardSize.default_;
  ShadcnCardLayout _layout = ShadcnCardLayout.vertical;

  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;
  bool get isSelected => _isSelected;
  bool get isExpanded => _isExpanded;
  bool get isLoading => _isLoading;
  bool get isEnabled => _isEnabled;
  bool get isInteractive => _isEnabled && !_isLoading;
  ShadcnCardVariant get variant => _variant;
  ShadcnCardSize get size => _size;
  ShadcnCardLayout get layout => _layout;

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

  void setSelected(bool selected) {
    if (_isSelected != selected) {
      _isSelected = selected;
      notifyListeners();
    }
  }

  void toggleSelection() {
    _isSelected = !_isSelected;
    notifyListeners();
  }

  void setExpanded(bool expanded) {
    if (_isExpanded != expanded) {
      _isExpanded = expanded;
      notifyListeners();
    }
  }

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setEnabled(bool enabled) {
    if (_isEnabled != enabled) {
      _isEnabled = enabled;
      notifyListeners();
    }
  }

  void setVariant(ShadcnCardVariant variant) {
    if (_variant != variant) {
      _variant = variant;
      notifyListeners();
    }
  }

  void setSize(ShadcnCardSize size) {
    if (_size != size) {
      _size = size;
      notifyListeners();
    }
  }

  void setLayout(ShadcnCardLayout layout) {
    if (_layout != layout) {
      _layout = layout;
      notifyListeners();
    }
  }

  Color getBackgroundColor(ColorScheme colorScheme) {
    Color baseColor;
    switch (_variant) {
      case ShadcnCardVariant.default_:
        baseColor = colorScheme.surface;
        break;
      case ShadcnCardVariant.elevated:
        baseColor = colorScheme.surface;
        break;
      case ShadcnCardVariant.outlined:
        baseColor = Colors.transparent;
        break;
      case ShadcnCardVariant.filled:
        baseColor = colorScheme.surfaceContainerHighest;
        break;
      case ShadcnCardVariant.ghost:
        baseColor = Colors.transparent;
        break;
    }

    if (!_isEnabled) {
      baseColor = baseColor.withValues(alpha: 0.5);
    } else if (_isSelected) {
      baseColor = Color.alphaBlend(
        colorScheme.primary.withValues(alpha: 0.1),
        baseColor,
      );
    } else if (_isHovered) {
      baseColor = Color.alphaBlend(
        Colors.black.withValues(alpha: 0.02),
        baseColor,
      );
    }

    return baseColor;
  }

  Color? getBorderColor(ColorScheme colorScheme) {
    if (_variant == ShadcnCardVariant.outlined || _variant == ShadcnCardVariant.default_) {
      if (_isSelected) {
        return colorScheme.primary;
      }
      return colorScheme.outline.withValues(alpha: 0.2);
    }
    return null;
  }

  double getElevation() {
    if (_variant == ShadcnCardVariant.elevated) {
      if (_isHovered) return 8;
      return 4;
    }
    return 0;
  }

  EdgeInsets getPadding() {
    switch (_size) {
      case ShadcnCardSize.sm:
        return const EdgeInsets.all(12);
      case ShadcnCardSize.default_:
        return const EdgeInsets.all(16);
      case ShadcnCardSize.lg:
        return const EdgeInsets.all(20);
      case ShadcnCardSize.xl:
        return const EdgeInsets.all(24);
    }
  }

  double getSpacing() {
    switch (_size) {
      case ShadcnCardSize.sm:
        return 8;
      case ShadcnCardSize.default_:
        return 12;
      case ShadcnCardSize.lg:
        return 16;
      case ShadcnCardSize.xl:
        return 20;
    }
  }

  BorderRadius getBorderRadius() {
    switch (_size) {
      case ShadcnCardSize.sm:
        return BorderRadius.circular(8);
      case ShadcnCardSize.default_:
        return BorderRadius.circular(12);
      case ShadcnCardSize.lg:
        return BorderRadius.circular(16);
      case ShadcnCardSize.xl:
        return BorderRadius.circular(20);
    }
  }
}
