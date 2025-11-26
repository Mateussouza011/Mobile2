import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// Resultado de autenticação
class AuthResult {
  final bool success;
  final String? message;
  final User? user;
  
  AuthResult({
    required this.success,
    this.message,
    this.user,
  });
  
  factory AuthResult.success(User user) => AuthResult(
    success: true,
    user: user,
  );
  
  factory AuthResult.error(String message) => AuthResult(
    success: false,
    message: message,
  );
}

/// Serviço de Autenticação
/// 
/// Gerencia login, cadastro e recuperação de senha.
class AuthService {
  final UserRepository _userRepository = UserRepository();
  
  // Usuário logado atualmente
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  
  // Instância singleton
  static final AuthService instance = AuthService._internal();
  AuthService._internal();
  
  /// Gera hash da senha usando SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Valida requisitos da senha
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (password.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    if (password.length > 50) {
      return 'Senha deve ter no máximo 50 caracteres';
    }
    return null;
  }
  
  /// Valida requisitos do username
  String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Usuário é obrigatório';
    }
    if (username.length < 3) {
      return 'Usuário deve ter no mínimo 3 caracteres';
    }
    if (username.length > 30) {
      return 'Usuário deve ter no máximo 30 caracteres';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Usuário deve conter apenas letras, números e _';
    }
    return null;
  }
  
  /// Valida nome completo
  String? validateFullName(String fullName) {
    if (fullName.isEmpty) {
      return 'Nome completo é obrigatório';
    }
    if (fullName.trim().split(' ').length < 2) {
      return 'Digite seu nome completo';
    }
    if (fullName.length > 100) {
      return 'Nome muito longo';
    }
    return null;
  }
  
  /// Valida data de nascimento
  String? validateBirthDate(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Data de nascimento é obrigatória';
    }
    
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    
    if (birthDate.isAfter(now)) {
      return 'Data inválida';
    }
    if (age < 13) {
      return 'Idade mínima: 13 anos';
    }
    if (age > 120) {
      return 'Data inválida';
    }
    return null;
  }
  
  /// Realiza login com username e senha
  Future<AuthResult> login(String username, String password) async {
    try {
      // Valida campos
      final usernameError = validateUsername(username);
      if (usernameError != null) {
        return AuthResult.error(usernameError);
      }
      
      if (password.isEmpty) {
        return AuthResult.error('Senha é obrigatória');
      }
      
      // Busca usuário
      final user = await _userRepository.findByUsername(username.toLowerCase());
      if (user == null) {
        return AuthResult.error('Usuário não encontrado');
      }
      
      // Verifica senha
      final passwordHash = _hashPassword(password);
      if (user.passwordHash != passwordHash) {
        return AuthResult.error('Senha incorreta');
      }
      
      // Login bem sucedido
      _currentUser = user;
      return AuthResult.success(user);
      
    } catch (e) {
      return AuthResult.error('Erro ao fazer login: ${e.toString()}');
    }
  }
  
  /// Realiza cadastro de novo usuário
  Future<AuthResult> register({
    required String fullName,
    required String username,
    required DateTime birthDate,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // Valida campos
      final nameError = validateFullName(fullName);
      if (nameError != null) {
        return AuthResult.error(nameError);
      }
      
      final usernameError = validateUsername(username);
      if (usernameError != null) {
        return AuthResult.error(usernameError);
      }
      
      final birthError = validateBirthDate(birthDate);
      if (birthError != null) {
        return AuthResult.error(birthError);
      }
      
      final passwordError = validatePassword(password);
      if (passwordError != null) {
        return AuthResult.error(passwordError);
      }
      
      if (password != confirmPassword) {
        return AuthResult.error('Senhas não conferem');
      }
      
      // Verifica se username já existe
      final exists = await _userRepository.usernameExists(username.toLowerCase());
      if (exists) {
        return AuthResult.error('Este usuário já está em uso');
      }
      
      // Cria usuário
      final user = User(
        fullName: fullName.trim(),
        username: username.toLowerCase().trim(),
        birthDate: birthDate,
        passwordHash: _hashPassword(password),
      );
      
      final id = await _userRepository.insert(user);
      final savedUser = user.copyWith(id: id);
      
      // Auto-login após cadastro
      _currentUser = savedUser;
      return AuthResult.success(savedUser);
      
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return AuthResult.error('Este usuário já está em uso');
      }
      return AuthResult.error('Erro ao cadastrar: ${e.toString()}');
    }
  }
  
  /// Verifica dados para recuperação de senha
  Future<AuthResult> verifyRecoveryData({
    required String fullName,
    required String username,
    required DateTime birthDate,
  }) async {
    try {
      // Busca usuário por username
      final user = await _userRepository.findByUsername(username.toLowerCase());
      if (user == null) {
        return AuthResult.error('Usuário não encontrado');
      }
      
      // Verifica nome completo (case insensitive)
      if (user.fullName.toLowerCase().trim() != fullName.toLowerCase().trim()) {
        return AuthResult.error('Dados não conferem');
      }
      
      // Verifica data de nascimento
      final userDate = DateTime(
        user.birthDate.year,
        user.birthDate.month,
        user.birthDate.day,
      );
      final inputDate = DateTime(
        birthDate.year,
        birthDate.month,
        birthDate.day,
      );
      
      if (userDate != inputDate) {
        return AuthResult.error('Dados não conferem');
      }
      
      return AuthResult.success(user);
      
    } catch (e) {
      return AuthResult.error('Erro ao verificar dados: ${e.toString()}');
    }
  }
  
  /// Redefine a senha do usuário
  Future<AuthResult> resetPassword({
    required int userId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final passwordError = validatePassword(newPassword);
      if (passwordError != null) {
        return AuthResult.error(passwordError);
      }
      
      if (newPassword != confirmPassword) {
        return AuthResult.error('Senhas não conferem');
      }
      
      final newHash = _hashPassword(newPassword);
      await _userRepository.updatePassword(userId, newHash);
      
      // Busca usuário atualizado
      final user = await _userRepository.findById(userId);
      if (user == null) {
        return AuthResult.error('Usuário não encontrado');
      }
      
      return AuthResult.success(user);
      
    } catch (e) {
      return AuthResult.error('Erro ao redefinir senha: ${e.toString()}');
    }
  }
  
  /// Faz logout
  void logout() {
    _currentUser = null;
  }
}
