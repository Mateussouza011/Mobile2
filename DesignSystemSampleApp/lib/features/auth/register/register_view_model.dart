import 'package:flutter/material.dart';
import '../../../core/data/services/auth_service.dart';
import '../../../DesignSystem/Components/calendar/calendar_view_model.dart' as calendar;

/// Delegate para a tela de Cadastro
abstract class RegisterDelegate {
  void onRegisterSuccess();
  void onNavigateToLogin();
  void onShowError(String message);
  void onShowSuccess(String message);
}

/// ViewModel para a tela de Cadastro
class RegisterViewModel extends ChangeNotifier implements calendar.CalendarDelegate {
  final RegisterDelegate delegate;
  final AuthService _authService = AuthService.instance;
  
  // Calendar ViewModel
  late final calendar.CalendarViewModel calendarViewModel;
  
  RegisterViewModel({required this.delegate}) {
    final now = DateTime.now();
    calendarViewModel = calendar.CalendarViewModel(
      delegate: this,
      initialDate: null,
      minDate: DateTime(1900),
      maxDate: now, // Não pode selecionar data futura
    );
  }
  
  @override
  void onDateSelected(DateTime date) {
    setBirthDate(date);
  }
  
  // Controllers
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Estado
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  
  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  
  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  
  // Erros
  String? _fullNameError;
  String? get fullNameError => _fullNameError;
  
  String? _usernameError;
  String? get usernameError => _usernameError;
  
  String? _birthDateError;
  String? get birthDateError => _birthDateError;
  
  String? _passwordError;
  String? get passwordError => _passwordError;
  
  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;
  
  /// Alterna visibilidade da senha
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
  
  /// Alterna visibilidade da confirmação de senha
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }
  
  /// Define a data de nascimento
  void setBirthDate(DateTime date) {
    _birthDate = date;
    _birthDateError = null;
    notifyListeners();
  }
  
  /// Formata a data de nascimento para exibição
  String get formattedBirthDate {
    if (_birthDate == null) return '';
    return '${_birthDate!.day.toString().padLeft(2, '0')}/'
           '${_birthDate!.month.toString().padLeft(2, '0')}/'
           '${_birthDate!.year}';
  }
  
  /// Limpa todos os erros
  void clearErrors() {
    _fullNameError = null;
    _usernameError = null;
    _birthDateError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }
  
  /// Valida todos os campos
  bool _validate() {
    bool isValid = true;
    
    // Nome completo
    final nameError = _authService.validateFullName(fullNameController.text);
    if (nameError != null) {
      _fullNameError = nameError;
      isValid = false;
    }
    
    // Username
    final usernameError = _authService.validateUsername(usernameController.text);
    if (usernameError != null) {
      _usernameError = usernameError;
      isValid = false;
    }
    
    // Data de nascimento
    final birthError = _authService.validateBirthDate(_birthDate);
    if (birthError != null) {
      _birthDateError = birthError;
      isValid = false;
    }
    
    // Senha
    final passwordError = _authService.validatePassword(passwordController.text);
    if (passwordError != null) {
      _passwordError = passwordError;
      isValid = false;
    }
    
    // Confirmação de senha
    if (confirmPasswordController.text.isEmpty) {
      _confirmPasswordError = 'Confirme sua senha';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      _confirmPasswordError = 'Senhas não conferem';
      isValid = false;
    }
    
    notifyListeners();
    return isValid;
  }
  
  /// Executa o cadastro
  Future<void> register() async {
    clearErrors();
    if (!_validate()) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.register(
        fullName: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        birthDate: _birthDate!,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      
      if (result.success) {
        delegate.onShowSuccess('Conta criada com sucesso!');
        delegate.onRegisterSuccess();
      } else {
        delegate.onShowError(result.message ?? 'Erro ao criar conta');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Navega para login
  void goToLogin() {
    delegate.onNavigateToLogin();
  }
  
  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
