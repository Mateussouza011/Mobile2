import 'package:flutter/material.dart';
import 'input_view_model.dart';
import '../../theme/design_system_theme.dart';

/// Componente de Input/TextField reutilizável baseado em ViewModel
class DSInput extends StatefulWidget {
  final InputViewModel viewModel;

  const DSInput({
    super.key,
    required this.viewModel,
  });

  /// Factory method para instanciar o input
  static Widget instantiate({required InputViewModel viewModel}) {
    return DSInput(viewModel: viewModel);
  }

  @override
  State<DSInput> createState() => _DSInputState();
}

class _DSInputState extends State<DSInput> {
  late bool _obscureText;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.viewModel.isPassword || widget.viewModel.obscureText;
    widget.viewModel.controller.addListener(_validateInput);
  }

  void _validateInput() {
    if (widget.viewModel.validator != null) {
      final errorText = widget.viewModel.validator?.call(
        widget.viewModel.controller.text,
      );
      setState(() {
        _errorMsg = errorText;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    widget.viewModel.controller.removeListener(_validateInput);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesignSystemTheme.of(context);
    
    Widget? suffixIconWidget = widget.viewModel.suffixIcon;
    
    // Se for campo de senha, adiciona o botão de mostrar/esconder
    if (widget.viewModel.isPassword) {
      suffixIconWidget = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: _togglePasswordVisibility,
        color: theme.textSecondaryColor,
      );
    }

    final decoration = InputDecoration(
      contentPadding: widget.viewModel.padding ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      filled: true,
      fillColor: widget.viewModel.fillColor ?? 
          (widget.viewModel.isEnabled 
              ? theme.surfaceColor 
              : theme.surfaceColor.withOpacity(0.5)),
      labelText: widget.viewModel.placeholder.isNotEmpty 
          ? widget.viewModel.placeholder 
          : null,
      labelStyle: TextStyle(color: theme.textSecondaryColor),
      helperText: widget.viewModel.helperText,
      helperStyle: TextStyle(color: theme.textSecondaryColor),
      errorText: widget.viewModel.errorText ?? _errorMsg,
      errorStyle: TextStyle(color: theme.errorColor),
      suffixIcon: suffixIconWidget,
      prefixIcon: widget.viewModel.prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.viewModel.borderColor ?? theme.borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.viewModel.borderColor ?? theme.borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: widget.viewModel.focusedBorderColor ?? theme.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.errorColor,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.borderColor.withOpacity(0.5),
        ),
      ),
    );

    final textField = TextFormField(
      controller: widget.viewModel.controller,
      obscureText: _obscureText,
      decoration: decoration,
      style: TextStyle(color: theme.textPrimaryColor),
      enabled: widget.viewModel.isEnabled,
      autofocus: widget.viewModel.autoFocus,
      keyboardType: widget.viewModel.keyboardType,
      maxLines: _obscureText ? 1 : widget.viewModel.maxLines,
      minLines: widget.viewModel.minLines,
      maxLength: widget.viewModel.maxLength,
      onChanged: widget.viewModel.onChanged,
      onFieldSubmitted: widget.viewModel.onSubmitted,
    );

    // Aplica margin se especificado
    if (widget.viewModel.margin != null) {
      return Padding(
        padding: widget.viewModel.margin!,
        child: textField,
      );
    }

    return textField;
  }
}
