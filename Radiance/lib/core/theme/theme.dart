import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Tema principal da aplicação inspirado no shadcn/ui
class ShadcnTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        surface: ShadcnColors.background,
        onSurface: ShadcnColors.foreground,
        surfaceContainer: ShadcnColors.card,
        onSurfaceVariant: ShadcnColors.cardForeground,
        primary: ShadcnColors.primary,
        onPrimary: ShadcnColors.primaryForeground,
        secondary: ShadcnColors.secondary,
        onSecondary: ShadcnColors.secondaryForeground,
        error: ShadcnColors.destructive,
        onError: ShadcnColors.destructiveForeground,
        outline: ShadcnColors.border,
        surfaceContainerHighest: ShadcnColors.muted,
        inverseSurface: ShadcnColors.mutedForeground,
      ),
      textTheme: ShadcnTypography.getTextTheme(),
      scaffoldBackgroundColor: ShadcnColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: ShadcnColors.background,
        foregroundColor: ShadcnColors.foreground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ShadcnColors.primary,
          foregroundColor: ShadcnColors.primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: ShadcnTypography.getTextTheme().labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ShadcnColors.foreground,
          side: const BorderSide(color: ShadcnColors.border),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: ShadcnTypography.getTextTheme().labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ShadcnColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: ShadcnTypography.getTextTheme().labelLarge,
        ),
      ),
      cardTheme: const CardThemeData(
        color: ShadcnColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: ShadcnColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ShadcnColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ShadcnColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ShadcnColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ShadcnColors.ring, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF020817),
        onSurface: Color(0xFFFAFAFA),
        surfaceContainer: Color(0xFF020817),
        onSurfaceVariant: Color(0xFFFAFAFA),
        primary: Color(0xFFFAFAFA),
        onPrimary: Color(0xFF18181B),
        secondary: Color(0xFF27272A),
        onSecondary: Color(0xFFFAFAFA),
        error: ShadcnColors.destructive,
        onError: ShadcnColors.destructiveForeground,
        outline: Color(0xFF27272A),
        surfaceContainerHighest: Color(0xFF27272A),
        inverseSurface: Color(0xFFA1A1AA),
      ),
      scaffoldBackgroundColor: const Color(0xFF020817),
    );
  }
}
