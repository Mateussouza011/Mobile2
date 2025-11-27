import 'package:flutter/material.dart';

/// Delegate para customizar o comportamento do ShadcnInput
/// 
/// Este delegate permite centralizar toda a lógica de validação,
/// formatação e eventos de um campo de entrada, seguindo o
/// padrão Delegate para desacoplamento e reutilização.
abstract class ShadcnInputDelegate {
  /// Chamado quando o texto do input muda
  /// 
  /// Use para realizar ações em tempo real conforme o usuário digita,
  /// como buscar sugestões, validar formato, etc.
  void onTextChanged(String text) {}
  
  /// Chamado quando o input é tocado/focado
  /// 
  /// Útil para tracking de analytics, mostrar teclado customizado, etc.
  void onInputTapped() {}
  
  /// Chamado quando o usuário pressiona Enter/Done no teclado
  /// 
  /// [text] contém o texto final do input
  void onInputSubmitted(String text) {}
  
  /// Chamado quando a edição é completa (campo perde foco)
  void onEditingComplete() {}
  
  /// Validação customizada do input
  /// 
  /// Retorna mensagem de erro se inválido, ou null se válido.
  /// Este método é chamado automaticamente pelo formulário.
  String? validateInput(String? value) {
    return null; // Sem validação por padrão
  }
  
  /// Formata o texto do input conforme o usuário digita
  /// 
  /// Use para aplicar máscaras (CPF, telefone, etc) ou
  /// transformações (uppercase, lowercase, etc).
  /// 
  /// [input] é o texto atual do campo
  /// Retorna o texto formatado
  String formatInput(String input) {
    return input; // Sem formatação por padrão
  }
  
  /// Define se o input pode ser editado
  /// 
  /// Retorna true se o campo está habilitado, false caso contrário.
  /// Útil para lógica condicional de habilitação.
  bool isEnabled() {
    return true; // Habilitado por padrão
  }
  
  /// Retorna o texto de ajuda (helper text) dinamicamente
  /// 
  /// Permite mudar o texto de ajuda baseado no estado do input.
  String? getHelperText(String currentText) {
    return null; // Sem helper text por padrão
  }
  
  /// Retorna o ícone de prefixo dinamicamente
  /// 
  /// Permite mudar o ícone baseado no estado do input.
  Widget? getPrefixIcon(String currentText) {
    return null; // Sem ícone por padrão
  }
  
  /// Retorna o ícone de sufixo dinamicamente
  /// 
  /// Permite mudar o ícone baseado no estado do input.
  Widget? getSuffixIcon(String currentText) {
    return null; // Sem ícone por padrão
  }
}

/// Implementação padrão do ShadcnInputDelegate
/// 
/// Fornece comportamento básico sem customizações.
/// Use como base para criar delegates customizados.
class DefaultShadcnInputDelegate implements ShadcnInputDelegate {
  @override
  void onTextChanged(String text) {
    // Implementação padrão vazia
  }
  
  @override
  void onInputTapped() {
    // Implementação padrão vazia
  }
  
  @override
  void onInputSubmitted(String text) {
    // Implementação padrão vazia
  }
  
  @override
  void onEditingComplete() {
    // Implementação padrão vazia
  }
  
  @override
  String? validateInput(String? value) {
    // Validação básica: campo obrigatório
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
  
  @override
  String formatInput(String input) {
    return input; // Sem formatação
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

/// Delegate especializado para inputs de CPF
/// 
/// Aplica máscara 000.000.000-00 e valida dígitos verificadores.
class CPFInputDelegate extends DefaultShadcnInputDelegate {
  @override
  String formatInput(String input) {
    // Remove tudo que não é número
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 11 dígitos
    final limitedNumbers = numbers.substring(0, numbers.length > 11 ? 11 : numbers.length);
    
    // Aplica máscara
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
    
    // Validação básica de CPF
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

/// Delegate especializado para inputs de Email
/// 
/// Valida formato de email e fornece feedback visual.
class EmailInputDelegate extends DefaultShadcnInputDelegate {
  @override
  String formatInput(String input) {
    // Remove espaços e converte para minúsculas
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
    // Mostra check verde se parece válido
    if (currentText.contains('@') && currentText.contains('.')) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
    return null;
  }
}

/// Delegate especializado para inputs de Telefone
/// 
/// Aplica máscara (00) 00000-0000
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

/// Delegate especializado para inputs de Senha
/// 
/// Valida força da senha e fornece feedback visual.
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
