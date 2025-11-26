import 'package:flutter/material.dart';
import '../../../core/data/services/auth_service.dart';
import '../../../DesignSystem/Components/calendar/calendar_view_model.dart' as calendar;

/// Delegate para a tela de Recuperação de Senha
abstract class ForgotPasswordDelegate {
  void onRecoverySuccess();
  void onNavigateToLogin();
  void onShowError(String message);
  void onShowSuccess(String message);
}

/// Estado da recuperação
enum RecoveryStep {
  verifyData,   // Primeiro passo: verificar dados
  newPassword,  // Segundo passo: criar nova senha
}

/// ViewModel para a tela de Recuperação de Senha
class ForgotPasswordViewModel extends ChangeNotifier implements calendar.CalendarDelegate {
  final ForgotPasswordDelegate delegate;
  final AuthService _authService = AuthService.instance;
  
  // Calendar ViewModel
  late final calendar.CalendarViewModel calendarViewModel;
  
  ForgotPasswordViewModel({required this.delegate}) {
    final now = DateTime.now();
    calendarViewModel = calendar.CalendarViewModel(
      delegate: this,
      initialDate: null,
      minDate: DateTime(1900),
      maxDate: now,
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
  RecoveryStep _step = RecoveryStep.verifyData;
  RecoveryStep get step => _step;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;
  
  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  
  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  
  // Armazena o ID do usuário após verificação bem-sucedida
  int? _verifiedUserId;
  
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
  
  /// Valida dados para verificação
  bool _validateVerifyStep() {
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
    if (_birthDate == null) {
      _birthDateError = 'Data de nascimento é obrigatória';
      isValid = false;
    }
    
    notifyListeners();
    return isValid;
  }
  
  /// Valida nova senha
  bool _validatePasswordStep() {
    bool isValid = true;
    
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
  
  /// Verifica dados para recuperação
  Future<void> verifyData() async {
    clearErrors();
    if (!_validateVerifyStep()) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _authService.verifyRecoveryData(
        fullName: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        birthDate: _birthDate!,
      );
      
      if (result.success) {
        _verifiedUserId = result.user?.id;
        _step = RecoveryStep.newPassword;
        notifyListeners();
      } else {
        delegate.onShowError(result.message ?? 'Dados não conferem');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Atualiza a senha
  Future<void> resetPassword() async {
    clearErrors();
    if (!_validatePasswordStep()) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      if (_verifiedUserId == null) {
        delegate.onShowError('Verificação não concluída');
        return;
      }
      
      final result = await _authService.resetPassword(
        userId: _verifiedUserId!,
        newPassword: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      
      if (result.success) {
        delegate.onShowSuccess('Senha alterada com sucesso!');
        delegate.onRecoverySuccess();
      } else {
        delegate.onShowError(result.message ?? 'Erro ao alterar senha');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Volta para o passo anterior
  void goBack() {
    if (_step == RecoveryStep.newPassword) {
      _step = RecoveryStep.verifyData;
      passwordController.clear();
      confirmPasswordController.clear();
      clearErrors();
    } else {
      delegate.onNavigateToLogin();
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
