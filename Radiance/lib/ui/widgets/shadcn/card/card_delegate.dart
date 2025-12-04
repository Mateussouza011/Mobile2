import 'package:flutter/material.dart';

import 'card_view_model.dart';

abstract class ShadcnCardDelegate {
  void onTap();
  void onLongPress();
  void onDoubleTap();
  void onHoverChanged(bool isHovered);
  void toggleSelection();
  void toggleExpanded();
}

class ShadcnCardService implements ShadcnCardDelegate {
  final ShadcnCardViewModel viewModel;
  final VoidCallback? onTapCallback;
  final VoidCallback? onLongPressCallback;
  final VoidCallback? onDoubleTapCallback;
  final ValueChanged<bool>? onHoverCallback;
  final ValueChanged<bool>? onSelectionCallback;
  final ValueChanged<bool>? onExpandCallback;

  ShadcnCardService({
    required this.viewModel,
    this.onTapCallback,
    this.onLongPressCallback,
    this.onDoubleTapCallback,
    this.onHoverCallback,
    this.onSelectionCallback,
    this.onExpandCallback,
  });

  @override
  void onTap() {
    if (viewModel.isInteractive) {
      onTapCallback?.call();
    }
  }

  @override
  void onLongPress() {
    if (viewModel.isInteractive) {
      onLongPressCallback?.call();
    }
  }

  @override
  void onDoubleTap() {
    if (viewModel.isInteractive) {
      onDoubleTapCallback?.call();
    }
  }

  @override
  void onHoverChanged(bool isHovered) {
    viewModel.setHovered(isHovered);
    onHoverCallback?.call(isHovered);
  }

  @override
  void toggleSelection() {
    if (viewModel.isInteractive) {
      viewModel.toggleSelection();
      onSelectionCallback?.call(viewModel.isSelected);
    }
  }

  @override
  void toggleExpanded() {
    if (viewModel.isInteractive) {
      viewModel.toggleExpanded();
      onExpandCallback?.call(viewModel.isExpanded);
    }
  }
}
