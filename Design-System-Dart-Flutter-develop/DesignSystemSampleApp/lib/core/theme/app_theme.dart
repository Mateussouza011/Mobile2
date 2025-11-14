/// Configuração de tema da aplicação
/// Define ThemeData para tema claro e escuro seguindo shadcn/ui
library;

import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';
import 'border_radius.dart';

/// Classe que configura os temas da aplicação
class AppTheme {
  // ==================== TEMA CLARO ====================
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de cores
    colorScheme: const ColorScheme.light(
      background: background,
      onBackground: foreground,
      primary: primary,
      onPrimary: primaryForeground,
      secondary: secondary,
      onSecondary: secondaryForeground,
      error: destructive,
      onError: destructiveForeground,
      surface: card,
      onSurface: cardForeground,
      outline: border,
      outlineVariant: input,
    ),
    
    // Cor de fundo do Scaffold
    scaffoldBackgroundColor: background,
    
    // Família de fonte
    fontFamily: fontFamily,
    
    // Tema de texto
    textTheme: const TextTheme(
      displayLarge: headingH1,
      displayMedium: headingH2,
      displaySmall: headingH3,
      headlineMedium: headingH4,
      headlineSmall: headingH5,
      titleLarge: headingH6,
      bodyLarge: bodyLarge,
      bodyMedium: bodyBase,
      bodySmall: bodySmall,
      labelSmall: caption,
    ),
    
    // Tema de AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: headingH6,
    ),
    
    // Tema de botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de botões outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing3,
        vertical: spacing2,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: ring, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: destructive, width: 2),
      ),
      labelStyle: bodyBase.copyWith(color: mutedForeground),
      hintStyle: bodyBase.copyWith(color: mutedForeground),
      helperStyle: caption.copyWith(color: mutedForeground),
      errorStyle: caption.copyWith(color: destructive),
    ),
    
    // Tema de cards
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLG,
        side: const BorderSide(color: border),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // Tema de Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLG,
      ),
    ),
    
    // Tema de Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: card,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLG)),
      ),
    ),
    
    // Tema de Divider
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
      space: 1,
    ),
    
    // Tema de Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(primaryForeground),
      side: const BorderSide(color: border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
    ),
    
    // Tema de Radio
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return border;
      }),
    ),
    
    // Tema de Switch
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryForeground;
        }
        return mutedForeground;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return muted;
      }),
    ),
  );
  
  // ==================== TEMA ESCURO ====================
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Esquema de cores
    colorScheme: const ColorScheme.dark(
      background: backgroundDark,
      onBackground: foregroundDark,
      primary: primaryDark,
      onPrimary: primaryForegroundDark,
      secondary: secondaryDark,
      onSecondary: secondaryForegroundDark,
      error: destructiveDark,
      onError: destructiveForegroundDark,
      surface: cardDark,
      onSurface: cardForegroundDark,
      outline: borderDark,
      outlineVariant: inputDark,
    ),
    
    // Cor de fundo do Scaffold
    scaffoldBackgroundColor: backgroundDark,
    
    // Família de fonte
    fontFamily: fontFamily,
    
    // Tema de texto
    textTheme: TextTheme(
      displayLarge: headingH1.copyWith(color: foregroundDark),
      displayMedium: headingH2.copyWith(color: foregroundDark),
      displaySmall: headingH3.copyWith(color: foregroundDark),
      headlineMedium: headingH4.copyWith(color: foregroundDark),
      headlineSmall: headingH5.copyWith(color: foregroundDark),
      titleLarge: headingH6.copyWith(color: foregroundDark),
      bodyLarge: bodyLarge.copyWith(color: foregroundDark),
      bodyMedium: bodyBase.copyWith(color: foregroundDark),
      bodySmall: bodySmall.copyWith(color: foregroundDark),
      labelSmall: caption.copyWith(color: mutedForegroundDark),
    ),
    
    // Tema de AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: foregroundDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: headingH6.copyWith(color: foregroundDark),
    ),
    
    // Tema de botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: primaryForegroundDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de botões outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        side: const BorderSide(color: borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusMD,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing2,
        ),
        textStyle: bodyBase.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    
    // Tema de inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing3,
        vertical: spacing2,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: ringDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: destructiveDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadiusMD,
        borderSide: const BorderSide(color: destructiveDark, width: 2),
      ),
      labelStyle: bodyBase.copyWith(color: mutedForegroundDark),
      hintStyle: bodyBase.copyWith(color: mutedForegroundDark),
      helperStyle: caption.copyWith(color: mutedForegroundDark),
      errorStyle: caption.copyWith(color: destructiveDark),
    ),
    
    // Tema de cards
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLG,
        side: const BorderSide(color: borderDark),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // Tema de Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: cardDark,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLG,
      ),
    ),
    
    // Tema de Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardDark,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLG)),
      ),
    ),
    
    // Tema de Divider
    dividerTheme: const DividerThemeData(
      color: borderDark,
      thickness: 1,
      space: 1,
    ),
    
    // Tema de Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(primaryForegroundDark),
      side: const BorderSide(color: borderDark, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
    ),
    
    // Tema de Radio
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return borderDark;
      }),
    ),
    
    // Tema de Switch
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryForegroundDark;
        }
        return mutedForegroundDark;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return mutedDark;
      }),
    ),
  );
}
