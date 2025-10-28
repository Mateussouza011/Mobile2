import 'package:flutter/material.dart';
import '../../core/base_component_view_model.dart';
import '../input/input_view_model.dart';
import '../input/input.dart';

/// ViewModel legado para InputText (compatibilidade)
class InputTextViewModel extends InteractiveComponentViewModel {
  final TextEditingController controller;
  final String placeholder;
  final bool password;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final VoidCallback? togglePasswordVisibility;

  InputTextViewModel({
    required this.controller,
    required this.placeholder,
    required this.password,
    this.suffixIcon,
    super.isEnabled = true,
    this.validator,
    this.togglePasswordVisibility,
    super.id,
    super.padding,
    super.margin,
    super.backgroundColor,
    super.width,
    super.height,
    super.tooltip,
  });

  /// Converte para o novo InputViewModel
  InputViewModel toInputViewModel() {
    return InputViewModel(
      controller: controller,
      placeholder: placeholder,
      isPassword: password,
      suffixIcon: suffixIcon,
      validator: validator,
      isEnabled: isEnabled,
      id: id,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      width: width,
      height: height,
      tooltip: tooltip,
    );
  }
}

/// Widget legado StyledInputField que usa o novo DSInput internamente
class StyledInputField extends StatefulWidget {
  final InputTextViewModel viewModel;

  const StyledInputField._({required this.viewModel});

  static Widget instantiate({required InputTextViewModel viewModel}) {
    return StyledInputField._(viewModel: viewModel);
  }

  @override
  StyledInputFieldState createState() => StyledInputFieldState();
}

class StyledInputFieldState extends State<StyledInputField> {
  @override
  Widget build(BuildContext context) {
    return DSInput(viewModel: widget.viewModel.toInputViewModel());
  }
}
