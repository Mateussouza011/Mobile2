import 'package:flutter/material.dart';

import 'input_view_model.dart';

abstract class ShadcnInputDelegate {
  void onValueChanged(String value);
  void onSubmitted(String value);
  void onFocusChanged(bool hasFocus);
  void onTap();
  String? validate(String value);
  void clear();
  void togglePasswordVisibility();
}

class ShadcnInputService implements ShadcnInputDelegate {
  final ShadcnInputViewModel viewModel;
  final TextEditingController controller;
  final ValueChanged<String>? onChangedCallback;
  final ValueChanged<String>? onSubmittedCallback;
  final ValueChanged<bool>? onFocusCallback;
  final VoidCallback? onTapCallback;
  final String? Function(String?)? customValidator;
  final bool validateOnChange;
  final bool validateOnFocusLoss;

  ShadcnInputService({
    required this.viewModel,
    required this.controller,
    this.onChangedCallback,
    this.onSubmittedCallback,
    this.onFocusCallback,
    this.onTapCallback,
    this.customValidator,
    this.validateOnChange = false,
    this.validateOnFocusLoss = true,
  });

  @override
  void onValueChanged(String value) {
    viewModel.setValue(value);
    onChangedCallback?.call(value);

    if (validateOnChange) {
      final error = validate(value);
      viewModel.setError(error);
    } else {
      if (viewModel.hasError && value.isNotEmpty) {
        viewModel.clearError();
      }
    }
  }

  @override
  void onSubmitted(String value) {
    final error = validate(value);
    viewModel.setError(error);
    
    if (error == null) {
      onSubmittedCallback?.call(value);
    }
  }

  @override
  void onFocusChanged(bool hasFocus) {
    viewModel.setFocused(hasFocus);
    onFocusCallback?.call(hasFocus);

    if (!hasFocus && validateOnFocusLoss) {
      final error = validate(controller.text);
      viewModel.setError(error);
    }
  }

  @override
  void onTap() {
    onTapCallback?.call();
  }

  @override
  String? validate(String value) {
    if (customValidator != null) {
      return customValidator!(value);
    }
    return viewModel.validate(value);
  }

  @override
  void clear() {
    controller.clear();
    viewModel.setValue('');
    viewModel.clearError();
  }

  @override
  void togglePasswordVisibility() {
    viewModel.toggleObscureText();
  }
}
