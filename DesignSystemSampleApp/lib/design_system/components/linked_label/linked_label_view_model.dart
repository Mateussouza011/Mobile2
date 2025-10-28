import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';

/// ViewModel para componente de Label com link
class LinkedLabelViewModel extends TextComponentViewModel {
  /// Texto que será o link clicável dentro do fullText
  final String linkedText;
  
  /// Callback quando o link é clicado
  final VoidCallback? onLinkTap;
  
  /// Estilo do texto do link
  final TextStyle? linkTextStyle;
  
  /// Cor do link
  final Color? linkColor;

  LinkedLabelViewModel({
    required super.text,
    required this.linkedText,
    this.onLinkTap,
    this.linkTextStyle,
    this.linkColor,
    super.textStyle,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.id,
    super.isEnabled,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Cria uma cópia do ViewModel com valores atualizados
  LinkedLabelViewModel copyWith({
    String? text,
    String? linkedText,
    VoidCallback? onLinkTap,
    TextStyle? linkTextStyle,
    Color? linkColor,
    TextStyle? textStyle,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? id,
    bool? isEnabled,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? width,
    double? height,
    String? tooltip,
  }) {
    return LinkedLabelViewModel(
      text: text ?? this.text,
      linkedText: linkedText ?? this.linkedText,
      onLinkTap: onLinkTap ?? this.onLinkTap,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      linkColor: linkColor ?? this.linkColor,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
      id: id ?? this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      width: width ?? this.width,
      height: height ?? this.height,
      tooltip: tooltip ?? this.tooltip,
    );
  }
}
