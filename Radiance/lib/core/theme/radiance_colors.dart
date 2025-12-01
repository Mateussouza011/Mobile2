import 'package:flutter/material.dart';

/// Radiance B2B Professional Color Palette
/// Design system com cores profissionais para aplicações SaaS
class RadianceColors {
  // Previne instanciação
  RadianceColors._();

  // ============================================
  // PRIMARY COLORS - Blue (Confiança & Profissionalismo)
  // ============================================
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF1E40AF); // Blue 700
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // ============================================
  // SECONDARY COLORS - Purple (Inovação)
  // ============================================
  static const Color secondary = Color(0xFF7C3AED); // Purple 600
  static const Color secondaryLight = Color(0xFF8B5CF6); // Purple 500
  static const Color secondaryDark = Color(0xFF6D28D9); // Purple 700
  static const Color secondaryForeground = Color(0xFFFFFFFF);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  static const Color success = Color(0xFF059669); // Green 600
  static const Color successLight = Color(0xFF10B981); // Green 500
  static const Color successForeground = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFF59E0B); // Amber 500
  static const Color warningForeground = Color(0xFFFFFFFF);

  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorLight = Color(0xFFEF4444); // Red 500
  static const Color errorForeground = Color(0xFFFFFFFF);

  static const Color info = Color(0xFF0891B2); // Cyan 600
  static const Color infoLight = Color(0xFF06B6D4); // Cyan 500
  static const Color infoForeground = Color(0xFFFFFFFF);

  // ============================================
  // LIGHT MODE - Background & Surface
  // ============================================
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9FAFB); // Gray 50
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Gray 100
  static const Color card = Color(0xFFFFFFFF);

  // ============================================
  // LIGHT MODE - Text Colors
  // ============================================
  static const Color textPrimary = Color(0xFF111827); // Gray 900
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color textTertiary = Color(0xFF9CA3AF); // Gray 400
  static const Color textDisabled = Color(0xFFD1D5DB); // Gray 300

  // ============================================
  // LIGHT MODE - Border & Divider
  // ============================================
  static const Color border = Color(0xFFE5E7EB); // Gray 200
  static const Color borderLight = Color(0xFFF3F4F6); // Gray 100
  static const Color divider = Color(0xFFE5E7EB); // Gray 200

  // ============================================
  // DARK MODE - Background & Surface
  // ============================================
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkCard = Color(0xFF1E293B); // Slate 800

  // ============================================
  // DARK MODE - Text Colors
  // ============================================
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextTertiary = Color(0xFF64748B); // Slate 500
  static const Color darkTextDisabled = Color(0xFF475569); // Slate 600

  // ============================================
  // DARK MODE - Border & Divider
  // ============================================
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkBorderLight = Color(0xFF475569); // Slate 600
  static const Color darkDivider = Color(0xFF334155); // Slate 700

  // ============================================
  // SUBSCRIPTION TIER COLORS
  // ============================================
  static const Color tierFree = Color(0xFF6B7280); // Gray 500
  static const Color tierPro = Color(0xFF2563EB); // Blue 600 (Primary)
  static const Color tierEnterprise = Color(0xFF7C3AED); // Purple 600 (Secondary)

  // ============================================
  // STATUS COLORS
  // ============================================
  static const Color statusActive = Color(0xFF059669); // Green 600
  static const Color statusPending = Color(0xFFD97706); // Amber 600
  static const Color statusCancelled = Color(0xFF6B7280); // Gray 500
  static const Color statusExpired = Color(0xFFDC2626); // Red 600
  static const Color statusTrial = Color(0xFF0891B2); // Cyan 600

  // ============================================
  // CHART COLORS (for Analytics)
  // ============================================
  static const List<Color> chartColors = [
    Color(0xFF2563EB), // Blue 600
    Color(0xFF7C3AED), // Purple 600
    Color(0xFF059669), // Green 600
    Color(0xFFD97706), // Amber 600
    Color(0xFFDC2626), // Red 600
    Color(0xFF0891B2), // Cyan 600
    Color(0xFFEC4899), // Pink 600
    Color(0xFF8B5CF6), // Purple 500
  ];

  // ============================================
  // GRADIENTS
  // ============================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // OPACITY HELPERS
  // ============================================
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // ============================================
  // UTILITY METHODS
  // ============================================
  
  /// Retorna a cor do tier baseado no nome
  static Color getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return tierFree;
      case 'pro':
        return tierPro;
      case 'enterprise':
        return tierEnterprise;
      default:
        return tierFree;
    }
  }

  /// Retorna a cor do status baseado no nome
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return statusActive;
      case 'pending':
        return statusPending;
      case 'cancelled':
        return statusCancelled;
      case 'expired':
        return statusExpired;
      case 'trial':
        return statusTrial;
      default:
        return textSecondary;
    }
  }

  // ============================================
  // UI SEMANTIC COLORS (for consistent styling)
  // ============================================
  
  /// Cor de ícone desabilitado/muted
  static const Color iconMuted = textSecondary;
  static const Color darkIconMuted = darkTextSecondary;
  
  /// Cor de fundo de hover em listas
  static const Color listHover = surfaceVariant;
  static const Color darkListHover = darkSurfaceVariant;
  
  /// Cor de fundo de item selecionado
  static const Color selectedBackground = Color(0xFFEFF6FF); // Blue 50
  static const Color darkSelectedBackground = Color(0xFF1E3A5F); // Blue 900/20
  
  /// Cor de badge/chip neutro
  static const Color chipBackground = surfaceVariant;
  static const Color darkChipBackground = darkSurfaceVariant;
  
  /// Destructive action color
  static const Color destructive = Color(0xFFEF4444); // Red 500
  static const Color destructiveForeground = Color(0xFFFFFFFF);
  
  /// Card background color
  static const Color cardBackground = surfaceVariant;
  static const Color darkCardBackground = darkSurfaceVariant;
  
  /// Input border color
  static const Color inputBorder = border;
  static const Color darkInputBorder = darkBorder;

  // ============================================
  // SHADCN-STYLE CONSTANTS
  // ============================================
  
  /// Border radius padrão para botões
  static const double buttonRadius = 6.0;
  
  /// Border radius padrão para cards
  static const double cardRadius = 12.0;
  
  /// Border radius padrão para inputs
  static const double inputRadius = 6.0;
  
  /// Border radius para chips/badges
  static const double chipRadius = 9999.0; // Full rounded
  
  /// Sombra sutil para cards (shadcn style)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
  
  /// Sombra para dropdowns/popovers
  static List<BoxShadow> get dropdownShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
