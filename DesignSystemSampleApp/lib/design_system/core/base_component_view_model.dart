import 'package:flutter/material.dart';

/// ViewModel base para todos os componentes do Design System
/// Contém propriedades comuns que podem ser herdadas por componentes específicos
abstract class BaseComponentViewModel {
  /// Identificador único do componente (opcional)
  final String? id;
  
  /// Se o componente está habilitado
  final bool isEnabled;
  
  /// Padding customizado (opcional)
  final EdgeInsetsGeometry? padding;
  
  /// Margem customizada (opcional)
  final EdgeInsetsGeometry? margin;
  
  /// Cor de fundo customizada (opcional)
  final Color? backgroundColor;
  
  /// Largura customizada (opcional)
  final double? width;
  
  /// Altura customizada (opcional)
  final double? height;
  
  /// Tooltip/descrição (opcional)
  final String? tooltip;

  BaseComponentViewModel({
    this.id,
    this.isEnabled = true,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.width,
    this.height,
    this.tooltip,
  });
}

/// ViewModel base para componentes interativos (botões, inputs, etc)
abstract class InteractiveComponentViewModel extends BaseComponentViewModel {
  /// Callback quando o componente é pressionado/interagido
  final VoidCallback? onPressed;
  
  /// Se o componente está em estado de loading
  final bool isLoading;
  
  /// Se o componente tem foco automático
  final bool autoFocus;

  InteractiveComponentViewModel({
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
    this.onPressed,
    this.isLoading = false,
    this.autoFocus = false,
  });
}

/// ViewModel base para componentes com texto
abstract class TextComponentViewModel extends BaseComponentViewModel {
  /// Texto a ser exibido
  final String text;
  
  /// Estilo de texto customizado (opcional)
  final TextStyle? textStyle;
  
  /// Alinhamento do texto
  final TextAlign textAlign;
  
  /// Número máximo de linhas
  final int? maxLines;
  
  /// Comportamento de overflow
  final TextOverflow overflow;

  TextComponentViewModel({
    required this.text,
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });
}

/// ViewModel base para componentes com ícone
abstract class IconComponentViewModel extends BaseComponentViewModel {
  /// Ícone a ser exibido
  final IconData? icon;
  
  /// Tamanho do ícone
  final double iconSize;
  
  /// Cor do ícone
  final Color? iconColor;

  IconComponentViewModel({
    this.icon,
    this.iconSize = 24.0,
    this.iconColor,
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });
}
