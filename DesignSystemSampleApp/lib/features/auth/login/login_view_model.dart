import 'package:flutter/material.dart';
import '../../../core/data/services/auth_service.dart';

/// Delegate para a tela de Login
abstract class LoginDelegate {
  void onLoginSuccess();
  void onNavigateToRegister();
  void onNavigateToForgotPassword();
  void onShowError(String message);
  void onShowSuccess(String message);
}

/// ViewModel para a tela de Login
class LoginViewModel extends ChangeNotifier {
  final LoginDelegate delegate;
  final AuthService _authService = AuthService.instance;
  
  LoginViewModel({required this.delegate});
  
  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Estado
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  
  String? _usernameError;
  String? get usernameError => _usernameError;
  
  String? _passwordError;
  String? get passwordError => _passwordError;
  
  /// Alterna visibilidade da senha
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
  
  /// Limpa erros
  void clearErrors() {
    if (_usernameError != null || _passwordError != null) {
      _usernameError = null;
      _passwordError = null;
      notifyListeners();
    }
  }
  
  /// Valida campos
  bool _validate() {
    bool isValid = true;
    
    final usernameError = _authService.validateUsername(usernameController.text);
    if (usernameError != null) {
      _usernameError = usernameError;
      isValid = false;
    }
    
    if (passwordController.text.isEmpty) {
      _passwordError = 'Senha é obrigatória';
      isValid = false;
    }
    
    notifyListeners();
    return isValid;
  }
  
  /// Executa o login
  Future<void> login() async {
    if (!_validate()) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.login(
        usernameController.text.trim(),
        passwordController.text,
      );
      
      if (result.success) {
        delegate.onLoginSuccess();
      } else {
        delegate.onShowError(result.message ?? 'Erro ao fazer login');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Navega para cadastro
  void goToRegister() {
    delegate.onNavigateToRegister();
  }
  
  /// Navega para recuperação de senha
  void goToForgotPassword() {
    delegate.onNavigateToForgotPassword();
  }
  
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
