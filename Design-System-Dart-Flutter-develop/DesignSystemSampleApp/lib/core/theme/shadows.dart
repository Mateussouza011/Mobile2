/// Sistema de sombras shadcn/ui
/// Define elevações e sombras padrão do design system
library;

import 'package:flutter/material.dart';

// ==================== SOMBRAS ====================

/// Sombra pequena - para elementos sutilmente elevados
final List<BoxShadow> shadowSM = [
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 2,
    offset: const Offset(0, 1),
  ),
];

/// Sombra média - para cards e elementos padrão
final List<BoxShadow> shadowMD = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 3,
    offset: const Offset(0, 4),
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.06),
    blurRadius: 2,
    offset: const Offset(0, 2),
  ),
];

/// Sombra grande - para modais e elementos destacados
final List<BoxShadow> shadowLG = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 15,
    offset: const Offset(0, 10),
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 6,
    offset: const Offset(0, 4),
  ),
];

/// Sombra extra grande - para overlays e elementos muito elevados
final List<BoxShadow> shadowXL = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 25,
    offset: const Offset(0, 20),
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.04),
    blurRadius: 10,
    offset: const Offset(0, 8),
  ),
];

/// Sombra 2x extra grande - para elementos muito destacados
final List<BoxShadow> shadow2XL = [
  BoxShadow(
    color: Colors.black.withOpacity(0.25),
    blurRadius: 50,
    offset: const Offset(0, 25),
  ),
];

/// Sem sombra
const List<BoxShadow> shadowNone = [];
