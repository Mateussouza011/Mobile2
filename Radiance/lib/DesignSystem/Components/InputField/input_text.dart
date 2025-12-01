import 'package:flutter/material.dart';
import 'input_text_view_model.dart';
import '../../../core/theme/radiance_colors.dart';

class StyledInputField extends StatefulWidget {
  final InputTextViewModel viewModel;

  const StyledInputField._({required this.viewModel});

  @override
  StyledInputFieldState createState() => StyledInputFieldState();

  static Widget instantiate({required InputTextViewModel viewModel}) {
    return StyledInputField._(viewModel: viewModel);
  }
}

class StyledInputFieldState extends State<StyledInputField> {
  late bool obscureText;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    obscureText = widget.viewModel.password;
    widget.viewModel.controller.addListener(validateInput);
  }

  void validateInput() {
    final errorText = widget.viewModel.validator?.call(widget.viewModel.controller.text);
    setState(() {
      errorMsg = errorText;
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    widget.viewModel.controller.removeListener(validateInput);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      filled: true,
      suffixIcon: widget.viewModel.password
          ? IconButton(
              icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: togglePasswordVisibility,
            )
          : widget.viewModel.suffixIcon,
      fillColor: widget.viewModel.isEnabled ? RadianceColors.background : RadianceColors.surfaceVariant,
      labelText: widget.viewModel.placeholder.isNotEmpty ? widget.viewModel.placeholder : null,
      labelStyle: TextStyle(color: RadianceColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadianceColors.inputRadius),
        borderSide: BorderSide(color: RadianceColors.border),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadianceColors.inputRadius),
        borderSide: BorderSide(color: RadianceColors.error),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadianceColors.inputRadius),
        borderSide: BorderSide(color: RadianceColors.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadianceColors.inputRadius),
        borderSide: BorderSide(color: RadianceColors.border),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadianceColors.inputRadius),
        borderSide: BorderSide(color: RadianceColors.textDisabled),
      ),
      errorText: errorMsg,
    );

    return TextFormField(
      controller: widget.viewModel.controller,
      obscureText: obscureText,
      decoration: decoration,
      style: TextStyle(color: RadianceColors.textPrimary),
      enabled: widget.viewModel.isEnabled,
    );
  }
}
