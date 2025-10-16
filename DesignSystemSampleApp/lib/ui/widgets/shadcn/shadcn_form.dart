import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Componente de formulário avançado com validação automática
class ShadcnForm extends StatefulWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;
  final bool autovalidateMode;
  final VoidCallback? onChanged;
  final VoidCallback? onValidationChanged;

  const ShadcnForm({
    super.key,
    required this.child,
    this.formKey,
    this.autovalidateMode = false,
    this.onChanged,
    this.onValidationChanged,
  });

  @override
  State<ShadcnForm> createState() => _ShadcnFormState();

  static ShadcnFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ShadcnFormState>();
  }
}

class _ShadcnFormState extends State<ShadcnForm> implements ShadcnFormState {
  late GlobalKey<FormState> _formKey;
  final Map<String, String?> _fieldErrors = {};
  final Map<String, dynamic> _fieldValues = {};

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
  }

  @override
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void save() {
    _formKey.currentState?.save();
  }

  @override
  void reset() {
    _formKey.currentState?.reset();
    _fieldErrors.clear();
    _fieldValues.clear();
    setState(() {});
  }

  @override
  void setFieldError(String field, String? error) {
    setState(() {
      _fieldErrors[field] = error;
    });
    widget.onValidationChanged?.call();
  }

  @override
  void setFieldValue(String field, dynamic value) {
    _fieldValues[field] = value;
    widget.onChanged?.call();
  }

  @override
  String? getFieldError(String field) {
    return _fieldErrors[field];
  }

  @override
  dynamic getFieldValue(String field) {
    return _fieldValues[field];
  }

  @override
  Map<String, dynamic> getAllValues() {
    return Map.from(_fieldValues);
  }

  @override
  bool get hasErrors => _fieldErrors.values.any((error) => error != null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode 
          ? AutovalidateMode.onUserInteraction 
          : AutovalidateMode.disabled,
      child: widget.child,
    );
  }
}

abstract class ShadcnFormState {
  bool validate();
  void save();
  void reset();
  void setFieldError(String field, String? error);
  void setFieldValue(String field, dynamic value);
  String? getFieldError(String field);
  dynamic getFieldValue(String field);
  Map<String, dynamic> getAllValues();
  bool get hasErrors;
}

/// Campo de formulário aprimorado com integração ao ShadcnForm
class ShadcnFormField extends StatefulWidget {
  final String name;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final TextEditingController? controller;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool required;
  final String? requiredMessage;

  const ShadcnFormField({
    super.key,
    required this.name,
    this.label,
    this.placeholder,
    this.helperText,
    this.controller,
    this.initialValue,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.required = false,
    this.requiredMessage,
  });

  @override
  State<ShadcnFormField> createState() => _ShadcnFormFieldState();
}

class _ShadcnFormFieldState extends State<ShadcnFormField> {
  late TextEditingController _controller;
  ShadcnFormState? _formState;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = ShadcnForm.of(context);
    if (_formState != null && widget.initialValue != null) {
      _formState!.setFieldValue(widget.name, widget.initialValue);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  String? _validate(String? value) {
    // Validação de obrigatório
    if (widget.required && (value == null || value.isEmpty)) {
      return widget.requiredMessage ?? '${widget.label ?? 'Campo'} é obrigatório';
    }

    // Validação customizada
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (widget.required)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        
        TextFormField(
          controller: _controller,
          validator: _validate,
          onChanged: (value) {
            _formState?.setFieldValue(widget.name, value);
            widget.onChanged?.call(value);
          },
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// Input de máscara para CPF
class ShadcnCpfInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const ShadcnCpfInput({
    super.key,
    this.label = 'CPF',
    this.placeholder = '000.000.000-00',
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnFormField(
      name: 'cpf',
      label: label,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      validator: validator ?? _validateCpf,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      prefixIcon: const Icon(Icons.person_outline),
    );
  }

  String? _validateCpf(String? value) {
    if (value == null || value.isEmpty) return null;
    
    String cpf = value.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    // Validação básica de CPF
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return 'CPF inválido';
    }
    
    return null;
  }
}

/// Input de máscara para CNPJ
class ShadcnCnpjInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const ShadcnCnpjInput({
    super.key,
    this.label = 'CNPJ',
    this.placeholder = '00.000.000/0000-00',
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnFormField(
      name: 'cnpj',
      label: label,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      validator: validator ?? _validateCnpj,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ],
      prefixIcon: const Icon(Icons.business_outlined),
    );
  }

  String? _validateCnpj(String? value) {
    if (value == null || value.isEmpty) return null;
    
    String cnpj = value.replaceAll(RegExp(r'\D'), '');
    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    
    return null;
  }
}

/// Input de telefone com máscara
class ShadcnPhoneInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const ShadcnPhoneInput({
    super.key,
    this.label = 'Telefone',
    this.placeholder = '(00) 00000-0000',
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnFormField(
      name: 'phone',
      label: label,
      placeholder: placeholder,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        PhoneInputFormatter(),
      ],
      prefixIcon: const Icon(Icons.phone_outlined),
    );
  }
}

/// Input de CEP com busca automática
class ShadcnCepInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<Map<String, String>>? onAddressFound;
  final FormFieldValidator<String>? validator;

  const ShadcnCepInput({
    super.key,
    this.label = 'CEP',
    this.placeholder = '00000-000',
    this.controller,
    this.onChanged,
    this.onAddressFound,
    this.validator,
  });

  @override
  State<ShadcnCepInput> createState() => _ShadcnCepInputState();
}

class _ShadcnCepInputState extends State<ShadcnCepInput> {
  bool _isLoading = false;

  void _onCepChanged(String value) {
    widget.onChanged?.call(value);
    
    String cep = value.replaceAll(RegExp(r'\D'), '');
    if (cep.length == 8) {
      _searchAddress(cep);
    }
  }

  Future<void> _searchAddress(String cep) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular busca de endereço
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock de dados de endereço
      final address = {
        'street': 'Rua das Flores, 123',
        'district': 'Centro',
        'city': 'São Paulo',
        'state': 'SP',
      };
      
      widget.onAddressFound?.call(address);
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnFormField(
      name: 'cep',
      label: widget.label,
      placeholder: widget.placeholder,
      controller: widget.controller,
      onChanged: _onCepChanged,
      validator: widget.validator,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ],
      prefixIcon: const Icon(Icons.location_on_outlined),
      suffixIcon: _isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }
}

// Formatadores personalizados
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '.${digits[i]}';
      } else if (i == 9) {
        formatted += '-${digits[i]}';
      } else {
        formatted += digits[i];
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length > 14) {
      digits = digits.substring(0, 14);
    }
    
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5) {
        formatted += '.${digits[i]}';
      } else if (i == 8) {
        formatted += '/${digits[i]}';
      } else if (i == 12) {
        formatted += '-${digits[i]}';
      } else {
        formatted += digits[i];
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 0) {
        formatted += '(${digits[i]}';
      } else if (i == 2) {
        formatted += ') ${digits[i]}';
      } else if (digits.length == 11 && i == 7) {
        formatted += '-${digits[i]}';
      } else if (digits.length == 10 && i == 6) {
        formatted += '-${digits[i]}';
      } else {
        formatted += digits[i];
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }
    
    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 5) {
        formatted += '-${digits[i]}';
      } else {
        formatted += digits[i];
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}