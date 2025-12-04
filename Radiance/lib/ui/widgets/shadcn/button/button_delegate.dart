import 'package:flutter/material.dart';

import 'button_view_model.dart';

abstract class ShadcnButtonDelegate {
  void onPressed();
  void onLongPress();
  void onHoverChanged(bool isHovered);
  void onFocusChanged(bool hasFocus);
  void startLoading();
  void stopLoading();
}

class ShadcnButtonService implements ShadcnButtonDelegate {
  final ShadcnButtonViewModel viewModel;
  final VoidCallback? onPressedCallback;
  final VoidCallback? onLongPressCallback;
  final ValueChanged<bool>? onHoverCallback;
  final ValueChanged<bool>? onFocusCallback;

  ShadcnButtonService({
    required this.viewModel,
    this.onPressedCallback,
    this.onLongPressCallback,
    this.onHoverCallback,
    this.onFocusCallback,
  });

  @override
  void onPressed() {
    if (viewModel.isInteractive) {
      onPressedCallback?.call();
    }
  }

  @override
  void onLongPress() {
    if (viewModel.isInteractive) {
      onLongPressCallback?.call();
    }
  }

  @override
  void onHoverChanged(bool isHovered) {
    viewModel.setHovered(isHovered);
    onHoverCallback?.call(isHovered);
  }

  @override
  void onFocusChanged(bool hasFocus) {
    onFocusCallback?.call(hasFocus);
  }

  @override
  void startLoading() {
    viewModel.setLoading(true);
  }

  @override
  void stopLoading() {
    viewModel.setLoading(false);
  }
}
