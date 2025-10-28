import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';
import '../linked_label/linked_label_view_model.dart';
import '../linked_label/linked_label.dart';

/// ViewModel legado para LinkedLabel (compatibilidade)
class LegacyLinkedLabelViewModel extends TextComponentViewModel {
  final String fullText;
  final String linkedText;
  final VoidCallback? onLinkTap;

  LegacyLinkedLabelViewModel({
    required this.fullText,
    required this.linkedText,
    required this.onLinkTap,
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
  }) : super(text: fullText);

  /// Converte para o novo LinkedLabelViewModel
  LinkedLabelViewModel toLinkedLabelViewModel() {
    return LinkedLabelViewModel(
      text: fullText,
      linkedText: linkedText,
      onLinkTap: onLinkTap,
      textStyle: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      id: id,
      isEnabled: isEnabled,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      width: width,
      height: height,
      tooltip: tooltip,
    );
  }
}

/// Widget legado LinkedLabel que usa o novo DSLinkedLabel internamente
class LinkedLabel extends StatelessWidget {
  final LegacyLinkedLabelViewModel viewModel;

  const LinkedLabel._({required this.viewModel});

  static Widget instantiate({required LegacyLinkedLabelViewModel viewModel}) {
    return LinkedLabel._(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return DSLinkedLabel(viewModel: viewModel.toLinkedLabelViewModel());
  }
}
