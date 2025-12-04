import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'input_view_model.dart';
import 'input_delegate.dart';

class ShadcnInputView extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<bool>? onFocusChange;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? customValidator;
  final bool validateOnChange;
  final bool validateOnFocusLoss;
  final ShadcnInputType inputType;
  final ShadcnInputVariant variant;
  final ShadcnInputSize size;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final String? prefixText;
  final String? suffixText;
  final Widget? counter;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;
  final double? borderWidth;
  final double? focusedBorderWidth;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final bool showCounter;
  final bool dense;
  final bool floating;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double? elevation;

  const ShadcnInputView({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onFocusChange,
    this.validator,
    this.inputFormatters,
    this.customValidator,
    this.validateOnChange = false,
    this.validateOnFocusLoss = true,
    this.inputType = ShadcnInputType.text,
    this.variant = ShadcnInputVariant.default_,
    this.size = ShadcnInputSize.default_,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.width,
    this.height,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.prefixIcon,
    this.suffixIcon,
    this.leadingWidget,
    this.trailingWidget,
    this.prefixText,
    this.suffixText,
    this.counter,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.borderRadius,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.helperStyle,
    this.showCounter = false,
    this.dense = false,
    this.floating = false,
    this.gradient,
    this.boxShadow,
    this.elevation,
  });

  const ShadcnInputView.email({
    super.key,
    this.label = 'Email',
    this.placeholder = 'Digite seu email',
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.variant = ShadcnInputVariant.default_,
    this.size = ShadcnInputSize.default_,
    this.prefixIcon = const Icon(Icons.email_outlined),
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
  })  : inputType = ShadcnInputType.email,
        obscureText = false,
        onTap = null,
        onEditingComplete = null,
        onFocusChange = null,
        validator = null,
        inputFormatters = null,
        customValidator = null,
        validateOnChange = true,
        validateOnFocusLoss = true,
        readOnly = false,
        autofocus = false,
        autocorrect = false,
        enableSuggestions = true,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        height = null,
        contentPadding = null,
        textAlign = TextAlign.start,
        textAlignVertical = null,
        suffixIcon = null,
        leadingWidget = null,
        trailingWidget = null,
        prefixText = null,
        suffixText = null,
        counter = null,
        errorBorderColor = null,
        textColor = null,
        hintColor = null,
        labelColor = null,
        borderWidth = null,
        focusedBorderWidth = null,
        borderRadius = null,
        textStyle = null,
        labelStyle = null,
        hintStyle = null,
        errorStyle = null,
        helperStyle = null,
        showCounter = false,
        dense = false,
        floating = false,
        gradient = null,
        boxShadow = null,
        elevation = null;

  const ShadcnInputView.password({
    super.key,
    this.label = 'Senha',
    this.placeholder = 'Digite sua senha',
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.variant = ShadcnInputVariant.default_,
    this.size = ShadcnInputSize.default_,
    this.prefixIcon = const Icon(Icons.lock_outline),
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
  })  : inputType = ShadcnInputType.password,
        obscureText = true,
        onTap = null,
        onEditingComplete = null,
        onFocusChange = null,
        validator = null,
        inputFormatters = null,
        customValidator = null,
        validateOnChange = false,
        validateOnFocusLoss = true,
        readOnly = false,
        autofocus = false,
        autocorrect = false,
        enableSuggestions = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        height = null,
        contentPadding = null,
        textAlign = TextAlign.start,
        textAlignVertical = null,
        suffixIcon = null,
        leadingWidget = null,
        trailingWidget = null,
        prefixText = null,
        suffixText = null,
        counter = null,
        errorBorderColor = null,
        textColor = null,
        hintColor = null,
        labelColor = null,
        borderWidth = null,
        focusedBorderWidth = null,
        borderRadius = null,
        textStyle = null,
        labelStyle = null,
        hintStyle = null,
        errorStyle = null,
        helperStyle = null,
        showCounter = false,
        dense = false,
        floating = false,
        gradient = null,
        boxShadow = null,
        elevation = null;

  const ShadcnInputView.search({
    super.key,
    this.label,
    this.placeholder = 'Buscar...',
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.variant = ShadcnInputVariant.default_,
    this.size = ShadcnInputSize.default_,
    this.prefixIcon = const Icon(Icons.search),
    this.width,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  })  : inputType = ShadcnInputType.search,
        obscureText = false,
        onTap = null,
        onEditingComplete = null,
        onFocusChange = null,
        validator = null,
        inputFormatters = null,
        customValidator = null,
        validateOnChange = false,
        validateOnFocusLoss = false,
        readOnly = false,
        autofocus = false,
        autocorrect = true,
        enableSuggestions = true,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        height = null,
        contentPadding = null,
        textAlign = TextAlign.start,
        textAlignVertical = null,
        suffixIcon = null,
        leadingWidget = null,
        trailingWidget = null,
        prefixText = null,
        suffixText = null,
        counter = null,
        borderColor = null,
        focusedBorderColor = null,
        errorBorderColor = null,
        textColor = null,
        hintColor = null,
        labelColor = null,
        borderWidth = null,
        focusedBorderWidth = null,
        textStyle = null,
        labelStyle = null,
        hintStyle = null,
        errorStyle = null,
        helperStyle = null,
        showCounter = false,
        dense = false,
        floating = false,
        gradient = null,
        boxShadow = null,
        elevation = null;

  @override
  State<ShadcnInputView> createState() => _ShadcnInputViewState();
}

class _ShadcnInputViewState extends State<ShadcnInputView> {
  late final ShadcnInputViewModel _viewModel;
  late final ShadcnInputService _service;
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    _viewModel = ShadcnInputViewModel();
    _viewModel.setInputType(widget.inputType);
    _viewModel.setVariant(widget.variant);
    _viewModel.setSize(widget.size);
    _viewModel.setEnabled(widget.enabled);
    _viewModel.setReadOnly(widget.readOnly);
    _viewModel.setObscureText(widget.obscureText);

    _service = ShadcnInputService(
      viewModel: _viewModel,
      controller: _controller,
      onChangedCallback: widget.onChanged,
      onSubmittedCallback: widget.onSubmitted,
      onFocusCallback: widget.onFocusChange,
      onTapCallback: widget.onTap,
      customValidator: widget.customValidator,
      validateOnChange: widget.validateOnChange,
      validateOnFocusLoss: widget.validateOnFocusLoss,
    );

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    _service.onFocusChanged(_focusNode.hasFocus);
  }

  @override
  void didUpdateWidget(ShadcnInputView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inputType != oldWidget.inputType) {
      _viewModel.setInputType(widget.inputType);
    }
    if (widget.variant != oldWidget.variant) {
      _viewModel.setVariant(widget.variant);
    }
    if (widget.size != oldWidget.size) {
      _viewModel.setSize(widget.size);
    }
    if (widget.enabled != oldWidget.enabled) {
      _viewModel.setEnabled(widget.enabled);
    }
    if (widget.readOnly != oldWidget.readOnly) {
      _viewModel.setReadOnly(widget.readOnly);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ShadcnInputViewModel>(
        builder: (context, viewModel, child) {
          return _buildInput(context, viewModel);
        },
      ),
    );
  }

  Widget _buildInput(BuildContext context, ShadcnInputViewModel viewModel) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bgColor = widget.backgroundColor ?? viewModel.getBackgroundColor(colorScheme);
    Color borderColorNormal = widget.borderColor ?? viewModel.getBorderColor(colorScheme);
    Color borderColorFocused = widget.focusedBorderColor ?? colorScheme.primary;
    Color borderColorError = widget.errorBorderColor ?? colorScheme.error;
    Color textColorFinal = widget.textColor ??
        (viewModel.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.5));
    Color hintColorFinal = widget.hintColor ?? colorScheme.inverseSurface;
    Color labelColorFinal = widget.labelColor ?? colorScheme.onSurface;

    EdgeInsets padding = widget.contentPadding ?? viewModel.getPadding();
    BorderRadius borderRadius = widget.borderRadius ?? BorderRadius.circular(12);
    double borderWidthNormal = widget.borderWidth ?? 1;
    double borderWidthFocused = widget.focusedBorderWidth ?? 2;

    String? finalError = widget.errorText ?? viewModel.errorMessage;

    Widget? finalSuffixIcon = widget.suffixIcon;
    if (viewModel.inputType == ShadcnInputType.password) {
      finalSuffixIcon = IconButton(
        icon: Icon(
          viewModel.obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: colorScheme.inverseSurface,
          size: 20,
        ),
        onPressed: () => _service.togglePasswordVisibility(),
      );
    }

    Widget inputField = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: borderRadius,
        boxShadow: widget.boxShadow ??
            (viewModel.isFocused
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) => _service.onValueChanged(value),
        onFieldSubmitted: (value) => _service.onSubmitted(value),
        onTap: () => _service.onTap(),
        onEditingComplete: widget.onEditingComplete,
        obscureText: viewModel.obscureText,
        keyboardType: viewModel.getKeyboardType(),
        inputFormatters: widget.inputFormatters ?? _getDefaultFormatters(),
        enabled: viewModel.enabled,
        readOnly: viewModel.readOnly,
        autofocus: widget.autofocus,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines ?? (viewModel.inputType == ShadcnInputType.multiline ? null : 1),
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        style: widget.textStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: textColorFinal,
              fontSize: viewModel.getFontSize(),
            ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: widget.hintStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: hintColorFinal,
                fontSize: viewModel.getFontSize(),
              ),
          prefixIcon: widget.prefixIcon != null
              ? IconTheme(
                  data: IconThemeData(
                    color: viewModel.isFocused ? colorScheme.onSurface : colorScheme.inverseSurface,
                    size: 20,
                  ),
                  child: widget.prefixIcon!,
                )
              : null,
          suffixIcon: finalSuffixIcon,
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,
          counter: widget.showCounter ? widget.counter : const SizedBox.shrink(),
          filled: viewModel.variant == ShadcnInputVariant.filled,
          fillColor: bgColor,
          contentPadding: padding,
          isDense: widget.dense,
          floatingLabelBehavior: widget.floating ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
          border: _getBorder(borderRadius, borderColorNormal, borderWidthNormal),
          enabledBorder: _getBorder(borderRadius, borderColorNormal, borderWidthNormal),
          focusedBorder: _getBorder(borderRadius, borderColorFocused, borderWidthFocused),
          errorBorder: _getBorder(borderRadius, borderColorError, borderWidthNormal),
          focusedErrorBorder: _getBorder(borderRadius, borderColorError, borderWidthFocused),
          disabledBorder: _getBorder(borderRadius, borderColorNormal.withValues(alpha: 0.5), borderWidthNormal),
          errorText: null,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leadingWidget != null) ...[
          widget.leadingWidget!,
          const SizedBox(height: 8),
        ],
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: labelColorFinal,
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 8),
        ],
        inputField,
        if (finalError != null) ...[
          const SizedBox(height: 6),
          Text(
            finalError,
            style: widget.errorStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                  fontSize: 13,
                ),
          ),
        ],
        if (widget.helperText != null && finalError == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: widget.helperStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.inverseSurface,
                ),
          ),
        ],
        if (widget.trailingWidget != null) ...[
          const SizedBox(height: 8),
          widget.trailingWidget!,
        ],
      ],
    );
  }

  List<TextInputFormatter>? _getDefaultFormatters() {
    switch (widget.inputType) {
      case ShadcnInputType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
            if (digits.length >= 11) {
              return TextEditingValue(
                text: '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}',
                selection: const TextSelection.collapsed(offset: 15),
              );
            } else if (digits.length >= 10) {
              return TextEditingValue(
                text: '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}',
                selection: TextSelection.collapsed(offset: digits.length + 5),
              );
            }
            return newValue;
          }),
        ];
      case ShadcnInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  InputBorder _getBorder(BorderRadius borderRadius, Color color, double width) {
    switch (widget.variant) {
      case ShadcnInputVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
      case ShadcnInputVariant.borderless:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }
}
