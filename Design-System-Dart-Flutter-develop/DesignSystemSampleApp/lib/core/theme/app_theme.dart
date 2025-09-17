import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// Cores principais do design system (shadcn adaptado)
  static const Color primaryColor = Color(0xFF22C55E); // Verde shadcn
  static const Color secondaryColor = Color(0xFF3B82F6); // Azul
  static const Color destructiveColor = Color(0xFFEF4444); // Vermelho

  /// Tema claro
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey.shade100,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Colors.black87),
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: destructiveColor,
      surface: Colors.white,
      onSurface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
  );

  /// Tema escuro
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: destructiveColor,
      surface: Colors.black,
      onSurface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    ),
  );

}
