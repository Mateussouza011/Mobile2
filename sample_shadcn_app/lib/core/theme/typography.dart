import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografia inspirada no design system shadcn/ui
class ShadcnTypography {
  /// Fonte base para o aplicativo (similar ao Inter usado no shadcn)
  static TextTheme getTextTheme() {
    return GoogleFonts.interTextTheme().copyWith(
      // Display
      displayLarge: GoogleFonts.inter(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.025,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 60,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.025,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.025,
      ),
      
      // Headline
      headlineLarge: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.025,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.025,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.025,
      ),
      
      // Title
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.025,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.025,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.025,
      ),
      
      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      
      // Label
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
