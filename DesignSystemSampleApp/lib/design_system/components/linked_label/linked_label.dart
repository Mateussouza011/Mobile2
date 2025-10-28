import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'linked_label_view_model.dart';
import '../../theme/design_system_theme.dart';

/// Componente de Label com link clicável baseado em ViewModel
class DSLinkedLabel extends StatelessWidget {
  final LinkedLabelViewModel viewModel;

  const DSLinkedLabel({
    super.key,
    required this.viewModel,
  });

  /// Factory method para instanciar o linked label
  static Widget instantiate({required LinkedLabelViewModel viewModel}) {
    return DSLinkedLabel(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    
    final int startIndex = viewModel.text.indexOf(viewModel.linkedText);
    final int endIndex = startIndex + viewModel.linkedText.length;

    // Se o linked text não for encontrado, retorna apenas o texto normal
    if (startIndex == -1) {
      return Text(
        viewModel.text,
        style: viewModel.textStyle ?? TextStyle(
          color: theme.textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        textAlign: viewModel.textAlign,
        maxLines: viewModel.maxLines,
        overflow: viewModel.overflow,
      );
    }

    final defaultTextStyle = viewModel.textStyle ?? TextStyle(
      color: theme.textPrimaryColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    final defaultLinkStyle = viewModel.linkTextStyle ?? TextStyle(
      color: viewModel.linkColor ?? theme.primaryColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

    Widget richText = RichText(
      text: TextSpan(
        text: viewModel.text.substring(0, startIndex),
        style: defaultTextStyle,
        children: [
          TextSpan(
            text: viewModel.linkedText,
            style: defaultLinkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = viewModel.onLinkTap,
          ),
          TextSpan(
            text: viewModel.text.substring(endIndex),
            style: defaultTextStyle,
          ),
        ],
      ),
      textAlign: viewModel.textAlign,
      maxLines: viewModel.maxLines,
      overflow: viewModel.overflow,
    );

    // Aplica padding se especificado
    if (viewModel.padding != null) {
      richText = Padding(
        padding: viewModel.padding!,
        child: richText,
      );
    }

    // Aplica margin se especificado
    if (viewModel.margin != null) {
      richText = Padding(
        padding: viewModel.margin!,
        child: richText,
      );
    }

    return richText;
  }
}
