import 'package:flutter/material.dart';

/// Provider para gerenciar o estado do tema da aplicação
/// Suporta alternância entre modo claro e escuro
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedLanguage = 'Português';

  /// Modo de tema atual
  ThemeMode get themeMode => _themeMode;

  /// Idioma selecionado
  String get selectedLanguage => _selectedLanguage;

  /// Verifica se está no modo escuro
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Alterna entre tema claro e escuro
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Define um modo de tema específico
  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Define o idioma selecionado
  void setLanguage(String language) {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      notifyListeners();
    }
  }

  /// Lista de idiomas disponíveis
  List<String> get availableLanguages => [
    'Português',
    'Inglês',
    'Espanhol',
  ];
}