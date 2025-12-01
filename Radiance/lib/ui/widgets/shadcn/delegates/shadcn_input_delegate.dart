import 'package:flutter/material.dart';
abstract class ShadcnInputDelegate {
  void onTextChanged(String text) {}
  void onInputTapped() {}
  void onInputSubmitted(String text) {}
  void onEditingComplete() {}
  String? validateInput(String? value) {
    return null; 
  }
  String formatInput(String input) {
    return input; 
  }
  bool isEnabled() {
    return true; 
  }
  String? getHelperText(String currentText) {
    return null; 
  }
  Widget? getPrefixIcon(String currentText) {
    return null; 
  }
  Widget? getSuffixIcon(String currentText) {
    return null; 
  }
}
class DefaultShadcnInputDelegate implements ShadcnInputDelegate {
  @override
  void onTextChanged(String text) {
  }
  
  @override
  void onInputTapped() {
  }
  
  @override
  void onInputSubmitted(String text) {
  }
  
  @override
  void onEditingComplete() {
  }
  
  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
  
  @override
  String formatInput(String input) {
    return input; 
  }
  
  @override
  bool isEnabled() {
    return true;
  }
  
  @override
  String? getHelperText(String currentText) {
    return null;
  }
  
  @override
  Widget? getPrefixIcon(String currentText) {
    return null;
  }
  
  @override
  Widget? getSuffixIcon(String currentText) {
    return null;
  }
}
class CPFInputDelegate extends DefaultShadcnInputDelegate {
  @override
  String formatInput(String input) {
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    final limitedNumbers = numbers.substring(0, numbers.length > 11 ? 11 : numbers.length);
    if (limitedNumbers.isEmpty) return '';
    if (limitedNumbers.length <= 3) return limitedNumbers;
    if (limitedNumbers.length <= 6) {
      return '${limitedNumbers.substring(0, 3)}.${limitedNumbers.substring(3)}';
    }
    if (limitedNumbers.length <= 9) {
      return '${limitedNumbers.substring(0, 3)}.${limitedNumbers.substring(3, 6)}.${limitedNumbers.substring(6)}';
    }
    return '${limitedNumbers.substring(0, 3)}.${limitedNumbers.substring(3, 6)}.${limitedNumbers.substring(6, 9)}-${limitedNumbers.substring(9)}';
  }
  
  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    if (RegExp(r'^(\d)\1{10}$').hasMatch(numbers)) {
      return 'CPF inválido';
    }
    
    return null;
  }
  
  @override
  String? getHelperText(String currentText) {
    return 'Formato: 000.000.000-00';
  }
  
  @override
  Widget? getPrefixIcon(String currentText) {
    return const Icon(Icons.badge_outlined);
  }
}
class EmailInputDelegate extends DefaultShadcnInputDelegate {
  @override
  String formatInput(String input) {
    return input.trim().toLowerCase();
  }
  
  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  @override
  String? getHelperText(String currentText) {
    return 'exemplo@email.com';
  }
  
  @override
  Widget? getPrefixIcon(String currentText) {
    return const Icon(Icons.email_outlined);
  }
  
  @override
  Widget? getSuffixIcon(String currentText) {
    if (currentText.contains('@') && currentText.contains('.')) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
    return null;
  }
}
class PhoneInputDelegate extends DefaultShadcnInputDelegate {
  @override
  String formatInput(String input) {
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    final limitedNumbers = numbers.substring(0, numbers.length > 11 ? 11 : numbers.length);
    
    if (limitedNumbers.isEmpty) return '';
    if (limitedNumbers.length <= 2) return '($limitedNumbers';
    if (limitedNumbers.length <= 7) {
      return '(${limitedNumbers.substring(0, 2)}) ${limitedNumbers.substring(2)}';
    }
    return '(${limitedNumbers.substring(0, 2)}) ${limitedNumbers.substring(2, 7)}-${limitedNumbers.substring(7)}';
  }
  
  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length < 10 || numbers.length > 11) {
      return 'Telefone inválido';
    }
    
    return null;
  }
  
  @override
  String? getHelperText(String currentText) {
    return 'Formato: (00) 00000-0000';
  }
  
  @override
  Widget? getPrefixIcon(String currentText) {
    return const Icon(Icons.phone_outlined);
  }
}
class PasswordInputDelegate extends DefaultShadcnInputDelegate {
  bool _obscureText = true;
  
  bool get obscureText => _obscureText;
  
  void toggleObscureText() {
    _obscureText = !_obscureText;
  }
  
  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Senha deve conter pelo menos uma letra maiúscula';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Senha deve conter pelo menos uma letra minúscula';
    }
    
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Senha deve conter pelo menos um número';
    }
    
    return null;
  }
  
  @override
  String? getHelperText(String currentText) {
    if (currentText.isEmpty) {
      return 'Mínimo 8 caracteres, com maiúsculas, minúsculas e números';
    }
    
    int strength = 0;
    if (currentText.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(currentText)) strength++;
    if (RegExp(r'[a-z]').hasMatch(currentText)) strength++;
    if (RegExp(r'[0-9]').hasMatch(currentText)) strength++;
    
    switch (strength) {
      case 1:
        return 'Senha fraca';
      case 2:
        return 'Senha média';
      case 3:
        return 'Senha boa';
      case 4:
        return 'Senha forte';
      default:
        return 'Digite a senha';
    }
  }
  
  @override
  Widget? getPrefixIcon(String currentText) {
    return const Icon(Icons.lock_outlined);
  }
  
  @override
  Widget? getSuffixIcon(String currentText) {
    return Icon(
      _obscureText ? Icons.visibility_off : Icons.visibility,
    );
  }
}
