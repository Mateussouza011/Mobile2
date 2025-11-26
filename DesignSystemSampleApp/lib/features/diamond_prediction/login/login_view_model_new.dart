import 'package:flutter/material.dart';

/// Delegate para a tela de Login
abstract class LoginViewDelegate {
  void onLoginSuccess();
  void onLoginError(String message);
  void onForgotPasswordTapped();
  void onCreateAccountTapped();
}

/// ViewModel para a tela de Login
/// 
/// Gerencia estado e lógica do login seguindo MVVM + Delegate
class LoginViewModel extends ChangeNotifier {
  final LoginViewDelegate delegate;
  
  LoginViewModel({required this.delegate});
  
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Estado
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  
  String? _emailError;
  String? get emailError => _emailError;
  
  String? _passwordError;
  String? get passwordError => _passwordError;
  
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  
  /// Alterna visibilidade da senha
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
  
  /// Alterna "lembrar-me"
  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }
  
  /// Valida email
  bool _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _emailError = 'Digite seu email';
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Email inválido';
      return false;
    }
    _emailError = null;
    return true;
  }
  
  /// Valida senha
  bool _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      _passwordError = 'Digite sua senha';
      return false;
    }
    if (password.length < 6) {
      _passwordError = 'Mínimo 6 caracteres';
      return false;
    }
    _passwordError = null;
    return true;
  }
  
  /// Executa o login
  Future<void> login() async {
    // Valida campos
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();
    notifyListeners();
    
    if (!isEmailValid || !isPasswordValid) {
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simula chamada de API
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Credenciais de demo
      if (emailController.text.trim() == 'demo@email.com' && 
          passwordController.text == '123456') {
        delegate.onLoginSuccess();
      } else {
        delegate.onLoginError('Credenciais inválidas');
      }
    } catch (e) {
      delegate.onLoginError('Erro ao fazer login');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Ação de esqueci a senha
  void forgotPassword() {
    delegate.onForgotPasswordTapped();
  }
  
  /// Ação de criar conta
  void createAccount() {
    delegate.onCreateAccountTapped();
  }
  
  /// Limpa erros ao digitar
  void clearErrors() {
    if (_emailError != null || _passwordError != null) {
      _emailError = null;
      _passwordError = null;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
