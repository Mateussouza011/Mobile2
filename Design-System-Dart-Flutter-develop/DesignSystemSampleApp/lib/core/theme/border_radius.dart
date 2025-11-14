/// Sistema de border radius shadcn/ui
/// Define os raios de borda padrão do design system
library;

import 'package:flutter/material.dart';

// ==================== VALORES DE RADIUS ====================

/// 0px - Sem arredondamento
const double radiusNone = 0.0;

/// 4px (0.25rem) - Arredondamento pequeno
const double radiusSM = 4.0;

/// 6px (0.375rem) - Arredondamento médio (padrão)
const double radiusMD = 6.0;

/// 8px (0.5rem) - Arredondamento grande
const double radiusLG = 8.0;

/// 12px (0.75rem) - Arredondamento extra grande
const double radiusXL = 12.0;

/// 16px (1rem) - Arredondamento 2x grande
const double radius2XL = 16.0;

/// 24px (1.5rem) - Arredondamento 3x grande
const double radius3XL = 24.0;

/// 9999px - Completamente arredondado (circular/pílula)
const double radiusFull = 9999.0;

// ==================== BORDERSRADIUS PRÉ-CONFIGURADOS ====================

/// BorderRadius sem arredondamento
const BorderRadius borderRadiusNone = BorderRadius.all(Radius.circular(radiusNone));

/// BorderRadius pequeno
const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));

/// BorderRadius médio (padrão)
const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));

/// BorderRadius grande
const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));

/// BorderRadius extra grande
const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));

/// BorderRadius 2x grande
const BorderRadius borderRadius2XL = BorderRadius.all(Radius.circular(radius2XL));

/// BorderRadius 3x grande
const BorderRadius borderRadius3XL = BorderRadius.all(Radius.circular(radius3XL));

/// BorderRadius completamente arredondado
const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(radiusFull));
