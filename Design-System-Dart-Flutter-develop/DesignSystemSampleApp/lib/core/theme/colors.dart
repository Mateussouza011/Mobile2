/// Paleta de cores shadcn/ui
/// Implementação completa do sistema de cores do design system shadcn/ui
/// Inclui variantes para tema claro e escuro
library;

import 'package:flutter/material.dart';

// ==================== CORES DE BASE (SLATE) ====================

/// Slate 50 - Tom mais claro
const Color slate50 = Color(0xFFF8FAFC);

/// Slate 100
const Color slate100 = Color(0xFFF1F5F9);

/// Slate 200
const Color slate200 = Color(0xFFE2E8F0);

/// Slate 300
const Color slate300 = Color(0xFFCBD5E1);

/// Slate 400
const Color slate400 = Color(0xFF94A3B8);

/// Slate 500 - Tom médio
const Color slate500 = Color(0xFF64748B);

/// Slate 600
const Color slate600 = Color(0xFF475569);

/// Slate 700
const Color slate700 = Color(0xFF334155);

/// Slate 800
const Color slate800 = Color(0xFF1E293B);

/// Slate 900
const Color slate900 = Color(0xFF0F172A);

/// Slate 950 - Tom mais escuro
const Color slate950 = Color(0xFF020617);

// ==================== TEMA CLARO ====================

/// Cor de fundo principal (tema claro)
const Color background = Color(0xFFFFFFFF);

/// Cor de texto sobre fundo (tema claro)
const Color foreground = Color(0xFF020617);

/// Cor de fundo de cartões (tema claro)
const Color card = Color(0xFFFFFFFF);

/// Cor de texto sobre cartões (tema claro)
const Color cardForeground = Color(0xFF020617);

/// Cor de fundo de popover (tema claro)
const Color popover = Color(0xFFFFFFFF);

/// Cor de texto sobre popover (tema claro)
const Color popoverForeground = Color(0xFF020617);

/// Cor primária (tema claro)
const Color primary = Color(0xFF0F172A);

/// Cor de texto sobre cor primária (tema claro)
const Color primaryForeground = Color(0xFFF8FAFC);

/// Cor secundária (tema claro)
const Color secondary = Color(0xFFF1F5F9);

/// Cor de texto sobre cor secundária (tema claro)
const Color secondaryForeground = Color(0xFF0F172A);

/// Cor muted - para elementos menos destacados (tema claro)
const Color muted = Color(0xFFF1F5F9);

/// Cor de texto muted (tema claro)
const Color mutedForeground = Color(0xFF64748B);

/// Cor de destaque/accent (tema claro)
const Color accent = Color(0xFFF1F5F9);

/// Cor de texto sobre accent (tema claro)
const Color accentForeground = Color(0xFF0F172A);

/// Cor destrutiva - para ações perigosas (tema claro)
const Color destructive = Color(0xFFEF4444);

/// Cor de texto sobre cor destrutiva (tema claro)
const Color destructiveForeground = Color(0xFFF8FAFC);

/// Cor de borda (tema claro)
const Color border = Color(0xFFE2E8F0);

/// Cor de borda de inputs (tema claro)
const Color input = Color(0xFFE2E8F0);

/// Cor de anel de foco (tema claro)
const Color ring = Color(0xFF020617);

// ==================== TEMA ESCURO ====================

/// Cor de fundo principal (tema escuro)
const Color backgroundDark = Color(0xFF020617);

/// Cor de texto sobre fundo (tema escuro)
const Color foregroundDark = Color(0xFFF8FAFC);

/// Cor de fundo de cartões (tema escuro)
const Color cardDark = Color(0xFF020617);

/// Cor de texto sobre cartões (tema escuro)
const Color cardForegroundDark = Color(0xFFF8FAFC);

/// Cor de fundo de popover (tema escuro)
const Color popoverDark = Color(0xFF020617);

/// Cor de texto sobre popover (tema escuro)
const Color popoverForegroundDark = Color(0xFFF8FAFC);

/// Cor primária (tema escuro)
const Color primaryDark = Color(0xFFF8FAFC);

/// Cor de texto sobre cor primária (tema escuro)
const Color primaryForegroundDark = Color(0xFF0F172A);

/// Cor secundária (tema escuro)
const Color secondaryDark = Color(0xFF1E293B);

/// Cor de texto sobre cor secundária (tema escuro)
const Color secondaryForegroundDark = Color(0xFFF8FAFC);

/// Cor muted - para elementos menos destacados (tema escuro)
const Color mutedDark = Color(0xFF1E293B);

/// Cor de texto muted (tema escuro)
const Color mutedForegroundDark = Color(0xFF94A3B8);

/// Cor de destaque/accent (tema escuro)
const Color accentDark = Color(0xFF1E293B);

/// Cor de texto sobre accent (tema escuro)
const Color accentForegroundDark = Color(0xFFF8FAFC);

/// Cor destrutiva - para ações perigosas (tema escuro)
const Color destructiveDark = Color(0xFF7F1D1D);

/// Cor de texto sobre cor destrutiva (tema escuro)
const Color destructiveForegroundDark = Color(0xFFF8FAFC);

/// Cor de borda (tema escuro)
const Color borderDark = Color(0xFF1E293B);

/// Cor de borda de inputs (tema escuro)
const Color inputDark = Color(0xFF1E293B);

/// Cor de anel de foco (tema escuro)
const Color ringDark = Color(0xFFD4D4D8);

// ==================== CORES DE SUCESSO ====================

/// Verde para indicar sucesso (tema claro)
const Color success = Color(0xFF22C55E);

/// Cor de texto sobre verde de sucesso (tema claro)
const Color successForeground = Color(0xFFF8FAFC);

/// Verde para indicar sucesso (tema escuro)
const Color successDark = Color(0xFF16A34A);

/// Cor de texto sobre verde de sucesso (tema escuro)
const Color successForegroundDark = Color(0xFFF8FAFC);

// ==================== CORES DE AVISO ====================

/// Amarelo/laranja para avisos (tema claro)
const Color warning = Color(0xFFF59E0B);

/// Cor de texto sobre amarelo de aviso (tema claro)
const Color warningForeground = Color(0xFF0F172A);

/// Amarelo/laranja para avisos (tema escuro)
const Color warningDark = Color(0xFFD97706);

/// Cor de texto sobre amarelo de aviso (tema escuro)
const Color warningForegroundDark = Color(0xFF0F172A);

// ==================== CORES DE INFORMAÇÃO ====================

/// Azul para informações (tema claro)
const Color info = Color(0xFF3B82F6);

/// Cor de texto sobre azul de informação (tema claro)
const Color infoForeground = Color(0xFFF8FAFC);

/// Azul para informações (tema escuro)
const Color infoDark = Color(0xFF2563EB);

/// Cor de texto sobre azul de informação (tema escuro)
const Color infoForegroundDark = Color(0xFFF8FAFC);
