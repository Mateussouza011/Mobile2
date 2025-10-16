import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tipos de entrada personalizados
enum ShadcnInputType {
  text,
  email,
  password,
  number,
  phone,
  url,
  multiline,
  search,
  date,
  time,
  datetime,
}

/// Variantes visuais do input
enum ShadcnInputVariant {
  default_,
  filled,
  outlined,
  underlined,
  borderless,
}

/// Tamanhos do input
enum ShadcnInputSize {
  sm,
  default_,
  lg,
}

/// Posições de ícones e widgets
enum ShadcnInputIconPosition {
  prefix,
  suffix,
  leading,
  trailing,
}

/// Componente Input baseado no Shadcn/UI - Versão Genérica e Flexível
class ShadcnInput extends StatefulWidget {
  // Conteúdo e controle
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  
  // Callbacks e eventos
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<bool>? onFocusChange;
  
  // Validação avançada
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? customValidator;
  final bool validateOnChange;
  final bool validateOnFocusLoss;
  
  // Tipo e comportamento
  final ShadcnInputType inputType;
  final ShadcnInputVariant variant;
  final ShadcnInputSize size;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool enableSuggestions;
  
  // Layout e dimensões
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double? width;
  final double? height;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  
  // Ícones e widgets personalizados
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final String? prefixText;
  final String? suffixText;
  final Widget? counter;
  
  // Customização visual avançada
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
  
  // Estados visuais
  final bool showCounter;
  final bool dense;
  final bool floating;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double? elevation;
  
  // Construtor principal
  const ShadcnInput({
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

  // Construtores nomeados para casos específicos
  
  // Input para email com validação
  const ShadcnInput.email({
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
  }) : inputType = ShadcnInputType.email,
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

  // Input para senha com toggle de visibilidade
  const ShadcnInput.password({
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
  }) : inputType = ShadcnInputType.password,
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

  // Input para busca
  const ShadcnInput.search({
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
  }) : inputType = ShadcnInputType.search,
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
  State<ShadcnInput> createState() => _ShadcnInputState();
}

class _ShadcnInputState extends State<ShadcnInput> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _obscureText = false;
  String? _validationError;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureText = widget.obscureText;
    
    _focusNode.addListener(_onFocusChange);
    
    if (widget.validateOnChange) {
      _controller.addListener(_validateOnChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.onFocusChange != null) {
      widget.onFocusChange!(_focusNode.hasFocus);
    }
    
    if (!_focusNode.hasFocus && widget.validateOnFocusLoss) {
      _validateInput();
    }
  }

  void _validateOnChange() {
    if (widget.validateOnChange) {
      _validateInput();
    }
  }

  void _validateInput() {
    String? error;
    
    // Validação customizada
    if (widget.customValidator != null) {
      error = widget.customValidator!(_controller.text);
    }
    
    // Validação padrão por tipo
    error ??= _getDefaultValidation(_controller.text);
    
    // Validação do FormField
    if (error == null && widget.validator != null) {
      error = widget.validator!(_controller.text);
    }
    
    setState(() {
      _validationError = error;
    });
  }

  String? _getDefaultValidation(String value) {
    if (value.isEmpty) return null;
    
    switch (widget.inputType) {
      case ShadcnInputType.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Email inválido';
        }
        break;
      case ShadcnInputType.url:
        final urlRegex = RegExp(r'^https?:\/\/');
        if (!urlRegex.hasMatch(value)) {
          return 'URL inválida';
        }
        break;
      case ShadcnInputType.phone:
        final phoneRegex = RegExp(r'^\(\d{2}\)\s\d{4,5}-\d{4}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Telefone inválido';
        }
        break;
      default:
        break;
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determinar cores baseadas na variante e customização
    Color bgColor = widget.backgroundColor ?? _getBackgroundColor(colorScheme);
    Color borderColorNormal = widget.borderColor ?? _getBorderColor(colorScheme);
    Color borderColorFocused = widget.focusedBorderColor ?? colorScheme.primary;
    Color borderColorError = widget.errorBorderColor ?? colorScheme.error;
    Color textColorFinal = widget.textColor ?? (widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.5));
    Color hintColorFinal = widget.hintColor ?? colorScheme.onSurfaceVariant;
    Color labelColorFinal = widget.labelColor ?? colorScheme.onSurface;
    
    // Determinar padding e dimensões
    EdgeInsets padding = widget.contentPadding ?? _getContentPadding();
    BorderRadius borderRadius = widget.borderRadius ?? BorderRadius.circular(6);
    double borderWidthNormal = widget.borderWidth ?? 1;
    double borderWidthFocused = widget.focusedBorderWidth ?? 2;
    
    // Erro final (widget.errorText tem prioridade sobre validação interna)
    String? finalError = widget.errorText ?? _validationError;
    
    // Tipo de teclado
    TextInputType keyboardType = _getKeyboardType();
    
    // Formatadores de entrada
    List<TextInputFormatter>? formatters = widget.inputFormatters ?? _getDefaultFormatters();
    
    // Construir sufixo para senha
    Widget? finalSuffixIcon = widget.suffixIcon;
    if (widget.inputType == ShadcnInputType.password) {
      finalSuffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    Widget inputField = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: borderRadius,
        boxShadow: widget.boxShadow ?? (widget.elevation != null ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: widget.elevation!,
            offset: Offset(0, widget.elevation! / 2),
          )
        ] : null),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (widget.validateOnChange) {
            _validateInput();
          }
        },
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        obscureText: _obscureText,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines ?? (widget.inputType == ShadcnInputType.multiline ? null : 1),
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        style: widget.textStyle ?? theme.textTheme.bodyMedium?.copyWith(
          color: textColorFinal,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(
            color: hintColorFinal,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: finalSuffixIcon,
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,
          counter: widget.showCounter ? widget.counter : const SizedBox.shrink(),
          filled: widget.variant == ShadcnInputVariant.filled,
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
          errorText: finalError,
          errorStyle: widget.errorStyle ?? theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.error,
          ),
        ),
      ),
    );

    // Construir layout completo
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Leading Widget
        if (widget.leadingWidget != null) ...[
          widget.leadingWidget!,
          const SizedBox(height: 8),
        ],
        
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ?? theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: labelColorFinal,
            ),
          ),
          const SizedBox(height: 6),
        ],
        
        // Input Field
        inputField,
        
        // Helper Text
        if (widget.helperText != null && finalError == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: widget.helperStyle ?? theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        
        // Trailing Widget
        if (widget.trailingWidget != null) ...[
          const SizedBox(height: 8),
          widget.trailingWidget!,
        ],
      ],
    );
  }

  // Métodos auxiliares

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ShadcnInputVariant.filled:
        return colorScheme.surfaceContainerHighest;
      case ShadcnInputVariant.borderless:
        return Colors.transparent;
      default:
        return colorScheme.surface;
    }
  }

  Color _getBorderColor(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ShadcnInputVariant.borderless:
        return Colors.transparent;
      case ShadcnInputVariant.underlined:
        return colorScheme.outline;
      default:
        return colorScheme.outline;
    }
  }

  EdgeInsets _getContentPadding() {
    switch (widget.size) {
      case ShadcnInputSize.sm:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
      case ShadcnInputSize.lg:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      default:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case ShadcnInputType.email:
        return TextInputType.emailAddress;
      case ShadcnInputType.number:
        return TextInputType.number;
      case ShadcnInputType.phone:
        return TextInputType.phone;
      case ShadcnInputType.url:
        return TextInputType.url;
      case ShadcnInputType.multiline:
        return TextInputType.multiline;
      case ShadcnInputType.datetime:
        return TextInputType.datetime;
      default:
        return TextInputType.text;
    }
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
