/// Provider para gerenciamento de tema (claro/escuro)
/// Utiliza ChangeNotifier para notificar mudanças
library;

import 'package:flutter/material.dart';

/// Provider que gerencia o tema da aplicação
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  /// Retorna o modo de tema atual
  ThemeMode get themeMode => _themeMode;

  /// Verifica se o tema escuro está ativado
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Verifica se o tema claro está ativado
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Alterna entre tema claro e escuro
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// Define um tema específico
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Define tema claro
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Define tema escuro
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// Define tema do sistema
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
