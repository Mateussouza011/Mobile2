import 'package:flutter/material.dart';

/// ViewModel para a tela de Login
/// Contém apenas dados e estados, sem lógica de negócio
class LoginViewModel extends ChangeNotifier {
  // Estados do formulário
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  
  // Estados de UI
  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  
  bool get isFormValid => 
      _email.isNotEmpty && 
      _password.isNotEmpty &&
      _emailError == null &&
      _passwordError == null;

  // Setters com notificação
  void setEmail(String value) {
    _email = value;
    _validateEmail();
    _clearGeneralError();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    _clearGeneralError();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setEmailError(String? error) {
    _emailError = error;
    notifyListeners();
  }

  void setPasswordError(String? error) {
    _passwordError = error;
    notifyListeners();
  }

  // Validações
  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = null;
      return;
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(_email)) {
      _emailError = 'Email inválido';
    } else {
      _emailError = null;
    }
  }

  void _validatePassword() {
    if (_password.isEmpty) {
      _passwordError = null;
      return;
    }
    
    if (_password.length < 6) {
      _passwordError = 'Mínimo 6 caracteres';
    } else {
      _passwordError = null;
    }
  }

  void _clearGeneralError() {
    if (_errorMessage != null) {
      _errorMessage = null;
    }
  }

  /// Limpa todos os estados
  void clear() {
    _email = '';
    _password = '';
    _isPasswordVisible = false;
    _isLoading = false;
    _errorMessage = null;
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }

  /// Valida todo o formulário antes do submit
  bool validateForm() {
    bool isValid = true;
    
    if (_email.isEmpty) {
      _emailError = 'Email é obrigatório';
      isValid = false;
    } else {
      _validateEmail();
      if (_emailError != null) isValid = false;
    }
    
    if (_password.isEmpty) {
      _passwordError = 'Senha é obrigatória';
      isValid = false;
    } else {
      _validatePassword();
      if (_passwordError != null) isValid = false;
    }
    
    notifyListeners();
    return isValid;
  }
}
