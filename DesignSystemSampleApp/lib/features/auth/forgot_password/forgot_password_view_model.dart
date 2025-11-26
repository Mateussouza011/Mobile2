import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _emailError;

  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get emailError => _emailError;
  
  bool get isFormValid => _email.isNotEmpty && _emailError == null;

  void setEmail(String value) {
    _email = value;
    _validateEmail();
    _errorMessage = null;
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

  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = null;
      return;
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    _emailError = emailRegex.hasMatch(_email) ? null : 'Email invalido';
  }

  bool validateForm() {
    if (_email.isEmpty) {
      _emailError = 'Email e obrigatorio';
      notifyListeners();
      return false;
    }
    _validateEmail();
    notifyListeners();
    return _emailError == null;
  }

  void clear() {
    _email = '';
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    _emailError = null;
    notifyListeners();
  }
}
