/// Sistema de tipografia shadcn/ui
/// Define estilos de texto, tamanhos de fonte, pesos e line heights
library;

import 'package:flutter/material.dart';

// ==================== FAMÍLIA DE FONTE ====================

/// Família de fonte principal (Inter ou Geist Sans)
const String fontFamily = 'Inter';

/// Família de fonte monoespaçada para código
const String fontFamilyMono = 'JetBrains Mono';

// ==================== TAMANHOS DE FONTE ====================

/// 10px - Extra extra small
const double fontSize2XS = 10.0;

/// 12px - Extra small
const double fontSizeXS = 12.0;

/// 14px - Small
const double fontSizeSM = 14.0;

/// 16px - Base (padrão)
const double fontSizeBase = 16.0;

/// 18px - Large
const double fontSizeLG = 18.0;

/// 20px - Extra large
const double fontSizeXL = 20.0;

/// 24px - 2X large
const double fontSize2XL = 24.0;

/// 30px - 3X large
const double fontSize3XL = 30.0;

/// 36px - 4X large
const double fontSize4XL = 36.0;

/// 48px - 5X large
const double fontSize5XL = 48.0;

// ==================== LINE HEIGHTS ====================

/// 1.25 - Altura de linha compacta
const double lineHeightTight = 1.25;

/// 1.5 - Altura de linha normal
const double lineHeightNormal = 1.5;

/// 1.75 - Altura de linha relaxada
const double lineHeightRelaxed = 1.75;

// ==================== LETTER SPACING ====================

/// -0.5 - Espaçamento de letra compacto
const double letterSpacingTight = -0.5;

/// 0.0 - Espaçamento de letra normal
const double letterSpacingNormal = 0.0;

/// 0.5 - Espaçamento de letra largo
const double letterSpacingWide = 0.5;

// ==================== ESTILOS DE HEADING ====================

/// Estilo H1 - Título principal (48px, extrabold)
const TextStyle headingH1 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSize5XL,
  fontWeight: FontWeight.w800,
  height: lineHeightTight,
  letterSpacing: letterSpacingTight,
);

/// Estilo H2 - Título secundário (36px, bold)
const TextStyle headingH2 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSize4XL,
  fontWeight: FontWeight.w700,
  height: lineHeightTight,
  letterSpacing: letterSpacingTight,
);

/// Estilo H3 - Título terciário (30px, semibold)
const TextStyle headingH3 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSize3XL,
  fontWeight: FontWeight.w600,
  height: lineHeightNormal,
);

/// Estilo H4 - Título quaternário (24px, semibold)
const TextStyle headingH4 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSize2XL,
  fontWeight: FontWeight.w600,
  height: lineHeightNormal,
);

/// Estilo H5 - Título quinário (20px, semibold)
const TextStyle headingH5 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeXL,
  fontWeight: FontWeight.w600,
  height: lineHeightNormal,
);

/// Estilo H6 - Título sextário (18px, semibold)
const TextStyle headingH6 = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeLG,
  fontWeight: FontWeight.w600,
  height: lineHeightNormal,
);

// ==================== ESTILOS DE BODY ====================

/// Texto de corpo grande (18px, regular)
const TextStyle bodyLarge = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeLG,
  fontWeight: FontWeight.w400,
  height: lineHeightNormal,
);

/// Texto de corpo base/padrão (16px, regular)
const TextStyle bodyBase = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeBase,
  fontWeight: FontWeight.w400,
  height: lineHeightNormal,
);

/// Texto de corpo pequeno (14px, regular)
const TextStyle bodySmall = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeSM,
  fontWeight: FontWeight.w400,
  height: lineHeightNormal,
);

/// Texto de corpo extra pequeno / caption (12px, regular)
const TextStyle caption = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeXS,
  fontWeight: FontWeight.w400,
  height: lineHeightNormal,
);

// ==================== ESTILOS ESPECIAIS ====================

/// Estilo para código inline ou em bloco
const TextStyle code = TextStyle(
  fontFamily: fontFamilyMono,
  fontSize: fontSizeSM,
  fontWeight: FontWeight.w500,
);

/// Estilo para lead/introdução (texto destacado)
const TextStyle lead = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeLG,
  fontWeight: FontWeight.w400,
  height: lineHeightRelaxed,
  color: Color(0xFF64748B), // mutedForeground
);

/// Estilo para texto muted (menos destaque)
const TextStyle textMuted = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeSM,
  fontWeight: FontWeight.w400,
  height: lineHeightNormal,
  color: Color(0xFF64748B), // mutedForeground
);

/// Estilo para blockquote
const TextStyle blockquote = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeBase,
  fontWeight: FontWeight.w400,
  height: lineHeightRelaxed,
  fontStyle: FontStyle.italic,
);
