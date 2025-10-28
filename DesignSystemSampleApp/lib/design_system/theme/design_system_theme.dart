import 'package:flutter/material.dart';

/// Tema do Design System
/// Centraliza todas as cores e configurações de tema
class DesignSystemTheme {
  // Cores primárias
  final Color primaryColor;
  final Color onPrimaryColor;
  
  // Cores secundárias
  final Color secondaryColor;
  final Color onSecondaryColor;
  
  // Cores terciárias
  final Color tertiaryColor;
  final Color onTertiaryColor;
  
  // Cores de superfície
  final Color surfaceColor;
  final Color onSurfaceColor;
  
  // Cores de background
  final Color backgroundColor;
  final Color onBackgroundColor;
  
  // Cores de erro
  final Color errorColor;
  final Color onErrorColor;
  
  // Cores de sucesso
  final Color successColor;
  final Color onSuccessColor;
  
  // Cores de aviso
  final Color warningColor;
  final Color onWarningColor;
  
  // Cores de informação
  final Color infoColor;
  final Color onInfoColor;
  
  // Cores de borda e divisores
  final Color borderColor;
  final Color dividerColor;
  
  // Cores de texto
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textDisabledColor;
  
  // Brightness
  final Brightness brightness;

  const DesignSystemTheme({
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.secondaryColor,
    required this.onSecondaryColor,
    required this.tertiaryColor,
    required this.onTertiaryColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.backgroundColor,
    required this.onBackgroundColor,
    required this.errorColor,
    required this.onErrorColor,
    required this.successColor,
    required this.onSuccessColor,
    required this.warningColor,
    required this.onWarningColor,
    required this.infoColor,
    required this.onInfoColor,
    required this.borderColor,
    required this.dividerColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textDisabledColor,
    required this.brightness,
  });

  /// Tema claro padrão
  static const DesignSystemTheme light = DesignSystemTheme(
    primaryColor: Color(0xFF6366F1), // Indigo
    onPrimaryColor: Color(0xFFFFFFFF),
    secondaryColor: Color(0xFF8B5CF6), // Purple
    onSecondaryColor: Color(0xFFFFFFFF),
    tertiaryColor: Color(0xFFEC4899), // Pink
    onTertiaryColor: Color(0xFFFFFFFF),
    surfaceColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1F2937),
    backgroundColor: Color(0xFFF9FAFB),
    onBackgroundColor: Color(0xFF1F2937),
    errorColor: Color(0xFFEF4444),
    onErrorColor: Color(0xFFFFFFFF),
    successColor: Color(0xFF10B981),
    onSuccessColor: Color(0xFFFFFFFF),
    warningColor: Color(0xFFF59E0B),
    onWarningColor: Color(0xFFFFFFFF),
    infoColor: Color(0xFF3B82F6),
    onInfoColor: Color(0xFFFFFFFF),
    borderColor: Color(0xFFE5E7EB),
    dividerColor: Color(0xFFE5E7EB),
    textPrimaryColor: Color(0xFF1F2937),
    textSecondaryColor: Color(0xFF6B7280),
    textDisabledColor: Color(0xFF9CA3AF),
    brightness: Brightness.light,
  );

  /// Tema escuro padrão
  static const DesignSystemTheme dark = DesignSystemTheme(
    primaryColor: Color(0xFF818CF8), // Indigo light
    onPrimaryColor: Color(0xFF1F2937),
    secondaryColor: Color(0xFFA78BFA), // Purple light
    onSecondaryColor: Color(0xFF1F2937),
    tertiaryColor: Color(0xFFF472B6), // Pink light
    onTertiaryColor: Color(0xFF1F2937),
    surfaceColor: Color(0xFF1F2937),
    onSurfaceColor: Color(0xFFF9FAFB),
    backgroundColor: Color(0xFF111827),
    onBackgroundColor: Color(0xFFF9FAFB),
    errorColor: Color(0xFFF87171),
    onErrorColor: Color(0xFF1F2937),
    successColor: Color(0xFF34D399),
    onSuccessColor: Color(0xFF1F2937),
    warningColor: Color(0xFFFBBF24),
    onWarningColor: Color(0xFF1F2937),
    infoColor: Color(0xFF60A5FA),
    onInfoColor: Color(0xFF1F2937),
    borderColor: Color(0xFF374151),
    dividerColor: Color(0xFF374151),
    textPrimaryColor: Color(0xFFF9FAFB),
    textSecondaryColor: Color(0xFFD1D5DB),
    textDisabledColor: Color(0xFF6B7280),
    brightness: Brightness.dark,
  );

  /// Obtém o tema do contexto
  static DesignSystemTheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Cria uma cópia do tema com valores modificados
  DesignSystemTheme copyWith({
    Color? primaryColor,
    Color? onPrimaryColor,
    Color? secondaryColor,
    Color? onSecondaryColor,
    Color? tertiaryColor,
    Color? onTertiaryColor,
    Color? surfaceColor,
    Color? onSurfaceColor,
    Color? backgroundColor,
    Color? onBackgroundColor,
    Color? errorColor,
    Color? onErrorColor,
    Color? successColor,
    Color? onSuccessColor,
    Color? warningColor,
    Color? onWarningColor,
    Color? infoColor,
    Color? onInfoColor,
    Color? borderColor,
    Color? dividerColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textDisabledColor,
    Brightness? brightness,
  }) {
    return DesignSystemTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      onTertiaryColor: onTertiaryColor ?? this.onTertiaryColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
      errorColor: errorColor ?? this.errorColor,
      onErrorColor: onErrorColor ?? this.onErrorColor,
      successColor: successColor ?? this.successColor,
      onSuccessColor: onSuccessColor ?? this.onSuccessColor,
      warningColor: warningColor ?? this.warningColor,
      onWarningColor: onWarningColor ?? this.onWarningColor,
      infoColor: infoColor ?? this.infoColor,
      onInfoColor: onInfoColor ?? this.onInfoColor,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      textDisabledColor: textDisabledColor ?? this.textDisabledColor,
      brightness: brightness ?? this.brightness,
    );
  }
}
