/// Input Component (shadcn/ui)
/// Implementação completa do componente Input seguindo design system
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart' as colors;
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants/durations.dart';
import 'input_view_model.dart';
import 'input_delegate.dart';

/// Componente Input do Design System
/// 
/// Implementa input field completo do shadcn/ui com:
/// - Tipos: text, password, email, number, phone, multiline
/// - Estados: normal, error, disabled, readonly, focused
/// - Features: label, placeholder, helper text, error message, icons, prefix/suffix
/// 
/// Exemplo de uso:
/// ```dart
/// class MyScreen extends StatelessWidget implements InputDelegate {
///   @override
///   void onChanged(String value) {
///     print('Value: $value');
///   }
///   
///   @override
///   Widget build(BuildContext context) {
///     return InputComponent(
///       viewModel: InputViewModel.text(
///         label: 'Email',
///         placeholder: 'Enter your email',
///       ),
///       delegate: this,
///     );
///   }
/// }
/// ```
class InputComponent extends StatefulWidget {
  final InputViewModel viewModel;
  final InputDelegate? delegate;

  const InputComponent({
    Key? key,
    required this.viewModel,
    this.delegate,
  }) : super(key: key);

  @override
  State<InputComponent> createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.viewModel.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    if (widget.viewModel.type == InputType.password) {
      _obscureText = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.delegate?.onFocusChanged(_isFocused);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = widget.viewModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (vm.label != null) ...[
          Row(
            children: [
              Text(
                vm.label!,
                style: bodyBase.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? colors.foregroundDark : colors.foreground,
                ),
              ),
              if (vm.required)
                Text(
                  ' *',
                  style: bodyBase.copyWith(
                    color: isDark ? colors.destructiveDark : colors.destructive,
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing2),
        ],

        // Input Field
        AnimatedContainer(
          duration: durationFast,
          decoration: BoxDecoration(
            color: vm.enabled && !vm.readonly
                ? (isDark ? colors.backgroundDark : colors.background)
                : (isDark ? colors.mutedDark : colors.muted),
            border: Border.all(
              color: _getBorderColor(vm, isDark),
              width: _isFocused ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // Leading Icon
              if (vm.leadingIcon != null)
                Padding(
                  padding: EdgeInsets.only(left: spacing3),
                  child: Icon(
                    vm.leadingIcon,
                    size: 18,
                    color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                  ),
                ),

              // Prefix
              if (vm.prefix != null)
                Padding(
                  padding: EdgeInsets.only(left: spacing3),
                  child: Text(
                    vm.prefix!,
                    style: bodyBase.copyWith(
                      color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                    ),
                  ),
                ),

              // TextField
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: vm.enabled && !vm.readonly,
                  obscureText: vm.type == InputType.password && _obscureText,
                  keyboardType: _getKeyboardType(vm.type),
                  maxLines: vm.type == InputType.multiline ? vm.maxLines : 1,
                  maxLength: vm.maxLength,
                  inputFormatters: vm.inputFormatters,
                  style: bodyBase.copyWith(
                    color: isDark ? colors.foregroundDark : colors.foreground,
                  ),
                  decoration: InputDecoration(
                    hintText: vm.placeholder,
                    hintStyle: bodyBase.copyWith(
                      color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing3,
                      vertical: spacing2,
                    ),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    widget.delegate?.onChanged(value);
                  },
                  onSubmitted: (value) {
                    widget.delegate?.onSubmitted(value);
                  },
                ),
              ),

              // Suffix
              if (vm.suffix != null)
                Padding(
                  padding: EdgeInsets.only(right: spacing3),
                  child: Text(
                    vm.suffix!,
                    style: bodyBase.copyWith(
                      color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                    ),
                  ),
                ),

              // Trailing Icon or Password Toggle
              if (vm.type == InputType.password)
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                )
              else if (vm.trailingIcon != null)
                Padding(
                  padding: EdgeInsets.only(right: spacing3),
                  child: Icon(
                    vm.trailingIcon,
                    size: 18,
                    color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                  ),
                ),
            ],
          ),
        ),

        // Helper Text or Error Message
        if (vm.hasError || vm.helperText != null) ...[
          SizedBox(height: spacing1),
          Text(
            vm.hasError ? vm.errorMessage! : vm.helperText!,
            style: bodySmall.copyWith(
              color: vm.hasError
                  ? (isDark ? colors.destructiveDark : colors.destructive)
                  : (isDark ? colors.mutedForegroundDark : colors.mutedForeground),
            ),
          ),
        ],
      ],
    );
  }

  Color _getBorderColor(InputViewModel vm, bool isDark) {
    if (vm.hasError) {
      return isDark ? colors.destructiveDark : colors.destructive;
    }

    if (_isFocused) {
      return isDark ? colors.ringDark : colors.ring;
    }

    if (!vm.enabled || vm.readonly) {
      return isDark ? colors.borderDark.withOpacity(0.5) : colors.border.withOpacity(0.5);
    }

    return isDark ? colors.borderDark : colors.border;
  }

  TextInputType _getKeyboardType(InputType type) {
    switch (type) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.number:
        return TextInputType.number;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}
