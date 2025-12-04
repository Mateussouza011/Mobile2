import 'package:flutter/material.dart';

enum ThemeDisplayMode {
  button,
  switch_,
  segmented,
}

class ThemeToggleViewModel extends ChangeNotifier {
  ThemeMode _themeMode;
  bool _isHovered;
  bool _isAnimating;
  ThemeDisplayMode _displayMode;

  ThemeToggleViewModel({
    ThemeMode themeMode = ThemeMode.system,
    ThemeDisplayMode displayMode = ThemeDisplayMode.button,
  })  : _themeMode = themeMode,
        _displayMode = displayMode,
        _isHovered = false,
        _isAnimating = false;

  ThemeMode get themeMode => _themeMode;
  bool get isHovered => _isHovered;
  bool get isAnimating => _isAnimating;
  ThemeDisplayMode get displayMode => _displayMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  set themeMode(ThemeMode value) {
    if (_themeMode != value) {
      _themeMode = value;
      notifyListeners();
    }
  }

  set displayMode(ThemeDisplayMode value) {
    if (_displayMode != value) {
      _displayMode = value;
      notifyListeners();
    }
  }

  void setHovered(bool value) {
    if (_isHovered != value) {
      _isHovered = value;
      notifyListeners();
    }
  }

  void startAnimation() {
    _isAnimating = true;
    notifyListeners();
  }

  void endAnimation() {
    _isAnimating = false;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    themeMode = mode;
  }

  void setLightMode() {
    themeMode = ThemeMode.light;
  }

  void setDarkMode() {
    themeMode = ThemeMode.dark;
  }

  void setSystemMode() {
    themeMode = ThemeMode.system;
  }

  void cycleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.light;
        break;
    }
    notifyListeners();
  }
}
