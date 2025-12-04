import 'package:flutter/material.dart';
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedLanguage = 'English';
  ThemeMode get themeMode => _themeMode;
  String get selectedLanguage => _selectedLanguage;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  void setTheme(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
  void setLanguage(String language) {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      notifyListeners();
    }
  }
  List<String> get availableLanguages => [
    'English',
    'Portuguese',
    'Spanish',
  ];
}