import 'package:flutter/material.dart';

enum ShadcnInputType {
  text,
  email,
  password,
  number,
  phone,
  url,
  multiline,
  search,
  date,
  time,
  datetime,
}

enum ShadcnInputVariant {
  default_,
  filled,
  outlined,
  underlined,
  borderless,
}

enum ShadcnInputSize {
  sm,
  default_,
  lg,
}

class ShadcnInputViewModel extends ChangeNotifier {
  bool _isFocused = false;
  bool _isHovered = false;
  bool _hasError = false;
  bool _obscureText = false;
  String? _errorMessage;
  String _value = '';

  ShadcnInputType _inputType = ShadcnInputType.text;
  ShadcnInputVariant _variant = ShadcnInputVariant.default_;
  ShadcnInputSize _size = ShadcnInputSize.default_;
  bool _enabled = true;
  bool _readOnly = false;

  bool get isFocused => _isFocused;
  bool get isHovered => _isHovered;
  bool get hasError => _hasError;
  bool get obscureText => _obscureText;
  String? get errorMessage => _errorMessage;
  String get value => _value;
  ShadcnInputType get inputType => _inputType;
  ShadcnInputVariant get variant => _variant;
  ShadcnInputSize get size => _size;
  bool get enabled => _enabled;
  bool get readOnly => _readOnly;
  bool get isInteractive => _enabled && !_readOnly;

  void setFocused(bool focused) {
    if (_isFocused != focused) {
      _isFocused = focused;
      notifyListeners();
    }
  }

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      _isHovered = hovered;
      notifyListeners();
    }
  }

  void setValue(String value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  void setError(String? message) {
    _hasError = message != null;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_hasError) {
      _hasError = false;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setObscureText(bool obscure) {
    if (_obscureText != obscure) {
      _obscureText = obscure;
      notifyListeners();
    }
  }

  void setInputType(ShadcnInputType type) {
    if (_inputType != type) {
      _inputType = type;
      if (type == ShadcnInputType.password) {
        _obscureText = true;
      }
      notifyListeners();
    }
  }

  void setVariant(ShadcnInputVariant variant) {
    if (_variant != variant) {
      _variant = variant;
      notifyListeners();
    }
  }

  void setSize(ShadcnInputSize size) {
    if (_size != size) {
      _size = size;
      notifyListeners();
    }
  }

  void setEnabled(bool enabled) {
    if (_enabled != enabled) {
      _enabled = enabled;
      notifyListeners();
    }
  }

  void setReadOnly(bool readOnly) {
    if (_readOnly != readOnly) {
      _readOnly = readOnly;
      notifyListeners();
    }
  }

  Color getBackgroundColor(ColorScheme colorScheme) {
    if (!_enabled) {
      return colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    }

    switch (_variant) {
      case ShadcnInputVariant.filled:
        return colorScheme.surfaceContainerHighest;
      case ShadcnInputVariant.default_:
      case ShadcnInputVariant.outlined:
      case ShadcnInputVariant.underlined:
      case ShadcnInputVariant.borderless:
        return Colors.transparent;
    }
  }

  Color getBorderColor(ColorScheme colorScheme) {
    if (!_enabled) {
      return colorScheme.outline.withValues(alpha: 0.3);
    }
    if (_hasError) {
      return colorScheme.error;
    }
    if (_isFocused) {
      return colorScheme.primary;
    }
    if (_isHovered) {
      return colorScheme.outline;
    }
    return colorScheme.outline.withValues(alpha: 0.5);
  }

  double getBorderWidth() {
    if (_isFocused) return 2.0;
    return 1.0;
  }

  EdgeInsets getPadding() {
    switch (_size) {
      case ShadcnInputSize.sm:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      case ShadcnInputSize.default_:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
      case ShadcnInputSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    }
  }

  double getHeight() {
    switch (_size) {
      case ShadcnInputSize.sm:
        return 36;
      case ShadcnInputSize.default_:
        return 44;
      case ShadcnInputSize.lg:
        return 52;
    }
  }

  double getFontSize() {
    switch (_size) {
      case ShadcnInputSize.sm:
        return 13;
      case ShadcnInputSize.default_:
        return 14;
      case ShadcnInputSize.lg:
        return 16;
    }
  }

  TextInputType getKeyboardType() {
    switch (_inputType) {
      case ShadcnInputType.email:
        return TextInputType.emailAddress;
      case ShadcnInputType.password:
        return TextInputType.visiblePassword;
      case ShadcnInputType.number:
        return TextInputType.number;
      case ShadcnInputType.phone:
        return TextInputType.phone;
      case ShadcnInputType.url:
        return TextInputType.url;
      case ShadcnInputType.multiline:
        return TextInputType.multiline;
      case ShadcnInputType.date:
      case ShadcnInputType.time:
      case ShadcnInputType.datetime:
        return TextInputType.datetime;
      case ShadcnInputType.text:
      case ShadcnInputType.search:
      default:
        return TextInputType.text;
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validate(String value) {
    if (_inputType == ShadcnInputType.email) {
      return validateEmail(value);
    }
    return null;
  }
}
