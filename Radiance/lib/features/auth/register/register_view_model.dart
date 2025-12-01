import 'package:flutter/material.dart';
class RegisterViewModel extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get acceptTerms => _acceptTerms;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  
  bool get isFormValid => 
      _name.isNotEmpty && 
      _email.isNotEmpty && 
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty &&
      _acceptTerms &&
      _nameError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null;
  void setName(String value) {
    _name = value;
    _validateName();
    _clearErrors();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _validateEmail();
    _clearErrors();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    _validateConfirmPassword();
    _clearErrors();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _validateConfirmPassword();
    _clearErrors();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void toggleAcceptTerms() {
    _acceptTerms = !_acceptTerms;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void setSuccess(String? message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }
  void _validateName() {
    if (_name.isEmpty) {
      _nameError = null;
      return;
    }
    
    if (_name.trim().length < 2) {
      _nameError = 'Nome muito curto';
    } else {
      _nameError = null;
    }
  }

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

  void _validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = null;
      return;
    }
    
    if (_confirmPassword != _password) {
      _confirmPasswordError = 'Senhas não conferem';
    } else {
      _confirmPasswordError = null;
    }
  }

  void _clearErrors() {
    if (_errorMessage != null) {
      _errorMessage = null;
    }
  }

  bool validateForm() {
    bool isValid = true;
    
    if (_name.isEmpty) {
      _nameError = 'Nome é obrigatório';
      isValid = false;
    }
    
    if (_email.isEmpty) {
      _emailError = 'Email é obrigatório';
      isValid = false;
    }
    
    if (_password.isEmpty) {
      _passwordError = 'Senha é obrigatória';
      isValid = false;
    }
    
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirme sua senha';
      isValid = false;
    }
    
    if (!_acceptTerms) {
      _errorMessage = 'Você deve aceitar os termos de uso';
      isValid = false;
    }
    
    notifyListeners();
    return isValid && _nameError == null && _emailError == null && 
           _passwordError == null && _confirmPasswordError == null;
  }

  void clear() {
    _name = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _acceptTerms = false;
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }
}
