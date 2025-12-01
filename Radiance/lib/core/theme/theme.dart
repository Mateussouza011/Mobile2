import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
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
    const darkBackground = Color(0xFF0A0A0B);
    const darkSurface = Color(0xFF0A0A0B);
    const darkCard = Color(0xFF18181B);
    const darkForeground = Color(0xFFFAFAFA);
    const darkMuted = Color(0xFF27272A);
    const darkMutedForeground = Color(0xFFA1A1AA);
    const darkBorder = Color(0xFF27272A);
    const darkPrimary = Color(0xFFFAFAFA);
    const darkPrimaryForeground = Color(0xFF18181B);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        onSurface: darkForeground,
        surfaceContainer: darkCard,
        onSurfaceVariant: darkForeground,
        primary: darkPrimary,
        onPrimary: darkPrimaryForeground,
        secondary: darkMuted,
        onSecondary: darkForeground,
        error: ShadcnColors.destructive,
        onError: ShadcnColors.destructiveForeground,
        outline: darkBorder,
        surfaceContainerHighest: darkMuted,
        inverseSurface: darkMutedForeground,
      ),
      textTheme: ShadcnTypography.getTextTheme().apply(
        bodyColor: darkForeground,
        displayColor: darkForeground,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkForeground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkForeground),
        titleTextStyle: TextStyle(
          color: darkForeground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkPrimaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkForeground,
          side: const BorderSide(color: darkBorder),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkForeground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        labelStyle: const TextStyle(color: darkMutedForeground),
        hintStyle: const TextStyle(color: darkMutedForeground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      iconTheme: const IconThemeData(color: darkForeground),
      listTileTheme: const ListTileThemeData(
        textColor: darkForeground,
        iconColor: darkForeground,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: darkCard,
        titleTextStyle: TextStyle(color: darkForeground, fontSize: 18, fontWeight: FontWeight.w600),
        contentTextStyle: TextStyle(color: darkForeground),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: darkMuted,
        labelStyle: TextStyle(color: darkForeground),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: TextStyle(color: darkForeground),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: darkCard,
        textStyle: TextStyle(color: darkForeground),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(color: darkForeground),
      ),
    );
  }
}
