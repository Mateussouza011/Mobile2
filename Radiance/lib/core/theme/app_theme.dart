import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'radiance_colors.dart';

/// Sistema de temas Radiance B2B Professional
class ShadcnTheme {
  // Cores Light Mode - Radiance
  static const Color background = RadianceColors.background;
  static const Color foreground = RadianceColors.textPrimary;
  static const Color card = RadianceColors.card;
  static const Color cardForeground = RadianceColors.textPrimary;
  static const Color popover = RadianceColors.card;
  static const Color popoverForeground = RadianceColors.textPrimary;
  static const Color primary = RadianceColors.primary;
  static const Color primaryForeground = RadianceColors.primaryForeground;
  static const Color secondary = RadianceColors.secondary;
  static const Color secondaryForeground = RadianceColors.secondaryForeground;
  static const Color muted = RadianceColors.surfaceVariant;
  static const Color mutedForeground = RadianceColors.textSecondary;
  static const Color accent = RadianceColors.secondary;
  static const Color accentForeground = RadianceColors.secondaryForeground;
  static const Color destructive = RadianceColors.error;
  static const Color destructiveForeground = RadianceColors.errorForeground;
  static const Color border = RadianceColors.border;
  static const Color input = RadianceColors.border;
  static const Color ring = RadianceColors.primary;
  
  // Cores Dark Mode - Radiance
  static const Color darkBackground = RadianceColors.darkBackground;
  static const Color darkForeground = RadianceColors.darkTextPrimary;
  static const Color darkCard = RadianceColors.darkCard;
  static const Color darkCardForeground = RadianceColors.darkTextPrimary;
  static const Color darkPopover = RadianceColors.darkCard;
  static const Color darkPopoverForeground = RadianceColors.darkTextPrimary;
  static const Color darkPrimary = RadianceColors.primary;
  static const Color darkPrimaryForeground = RadianceColors.primaryForeground;
  static const Color darkSecondary = RadianceColors.darkSurface;
  static const Color darkSecondaryForeground = RadianceColors.darkTextPrimary;
  static const Color darkMuted = RadianceColors.darkSurfaceVariant;
  static const Color darkMutedForeground = RadianceColors.darkTextSecondary;
  static const Color darkAccent = RadianceColors.secondary;
  static const Color darkAccentForeground = RadianceColors.secondaryForeground;
  static const Color darkDestructive = RadianceColors.error;
  static const Color darkDestructiveForeground = RadianceColors.errorForeground;
  static const Color darkBorder = RadianceColors.darkBorder;
  static const Color darkInput = RadianceColors.darkBorder;
  static const Color darkRing = RadianceColors.primary;

  /// Tema claro Shadcn/UI
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Esquema de cores
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        error: destructive,
        onError: destructiveForeground,
        surface: card,
        onSurface: cardForeground,
        surfaceContainerHighest: muted,
        onSurfaceVariant: mutedForeground,
        outline: border,
        outlineVariant: input,
      ),
      
      // Tipografia Shadcn/UI
      textTheme: _buildTextTheme(foreground, mutedForeground),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        iconTheme: const IconThemeData(color: foreground),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      
      // Botões Elevated
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Botões Outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          side: const BorderSide(color: border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Botões Text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: foreground,
        unselectedItemColor: mutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: destructive),
        ),
        labelStyle: GoogleFonts.inter(
          color: mutedForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.inter(
          color: mutedForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: GoogleFonts.inter(
          color: primaryForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        actionTextColor: primaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Tema escuro Shadcn/UI
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Esquema de cores
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: darkPrimary,
        onPrimary: darkPrimaryForeground,
        secondary: darkSecondary,
        onSecondary: darkSecondaryForeground,
        error: darkDestructive,
        onError: darkDestructiveForeground,
        surface: darkCard,
        onSurface: darkCardForeground,
        surfaceContainerHighest: darkMuted,
        onSurfaceVariant: darkMutedForeground,
        outline: darkBorder,
        outlineVariant: darkInput,
      ),
      
      // Tipografia
      textTheme: _buildTextTheme(darkForeground, darkMutedForeground),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkForeground,
        ),
        iconTheme: const IconThemeData(color: darkForeground),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      
      // Botões Elevated
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkPrimaryForeground,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Botões Outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkForeground,
          side: const BorderSide(color: darkBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Botões Text
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: darkForeground,
        unselectedItemColor: darkMutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBackground,
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
          borderSide: const BorderSide(color: darkRing, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: darkDestructive),
        ),
        labelStyle: GoogleFonts.inter(
          color: darkMutedForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.inter(
          color: darkMutedForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkPrimary,
        contentTextStyle: GoogleFonts.inter(
          color: darkPrimaryForeground,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        actionTextColor: darkPrimaryForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Constrói o tema de tipografia Shadcn/UI
  static TextTheme _buildTextTheme(Color foreground, Color mutedForeground) {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.1,
        letterSpacing: -0.02,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: foreground,
        height: 1.2,
        letterSpacing: -0.02,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: foreground,
        height: 1.2,
        letterSpacing: -0.01,
      ),
      
      // Headlines
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: foreground,
        height: 1.25,
        letterSpacing: -0.02,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: foreground,
        height: 1.3,
        letterSpacing: -0.01,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: foreground,
        height: 1.3,
      ),
      
      // Titles
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foreground,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: foreground,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: foreground,
        height: 1.4,
      ),
      
      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: foreground,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: foreground,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mutedForeground,
        height: 1.5,
      ),
      
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: foreground,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: mutedForeground,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: mutedForeground,
        height: 1.4,
      ),
    );
  }
}
