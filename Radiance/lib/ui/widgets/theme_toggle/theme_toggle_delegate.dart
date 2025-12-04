import 'package:flutter/material.dart';

abstract class ThemeToggleDelegate {
  void onThemeToggle();
  void onThemeSelected(ThemeMode mode);
  void onAnimationStart();
  void onAnimationEnd();
  void onHoverEnter();
  void onHoverExit();
}

class DefaultThemeToggleDelegate implements ThemeToggleDelegate {
  @override
  void onThemeToggle() {}

  @override
  void onThemeSelected(ThemeMode mode) {}

  @override
  void onAnimationStart() {}

  @override
  void onAnimationEnd() {}

  @override
  void onHoverEnter() {}

  @override
  void onHoverExit() {}
}
