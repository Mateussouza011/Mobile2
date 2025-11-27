import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database/local_database.dart';
import '../database/web_storage.dart';
import '../models/user_model.dart';
import '../../constants/api_constants.dart';

/// Repositório para autenticação e gerenciamento de usuários locais
/// Suporta tanto plataformas nativas (SQLite) quanto Web (memória)
class AuthRepository {
  final LocalDatabase _localDatabase;
  final WebStorage _webStorage;
  
  /// Usuário atualmente logado (em memória)
  UserModel? _currentUser;

  AuthRepository({LocalDatabase? localDatabase})
      : _localDatabase = localDatabase ?? LocalDatabase.instance,
        _webStorage = WebStorage.instance;

  /// Obtém o usuário atualmente logado
  UserModel? get currentUser => kIsWeb ? _webStorage.currentUser : _currentUser;

  /// Verifica se há um usuário logado
  bool get isLoggedIn => currentUser != null;

  /// Hash de senha usando SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Valida o formato do email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida a força da senha
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  /// Registra um novo usuário
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Validações
      if (name.trim().isEmpty) {
        return AuthResult.failure('Nome é obrigatório');
      }
      
      if (!_isValidEmail(email)) {
        return AuthResult.failure('Email inválido');
      }

      final passwordError = _validatePassword(password);
      if (passwordError != null) {
        return AuthResult.failure(passwordError);
      }

      final passwordHash = _hashPassword(password);

      // Web: usar WebStorage
      if (kIsWeb) {
        try {
          final user = await _webStorage.registerUser(
            name: name.trim(),
            email: email.toLowerCase().trim(),
            passwordHash: passwordHash,
          );
          return AuthResult.success(user);
        } catch (e) {
          return AuthResult.failure(e.toString());
        }
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;

      // Verifica se o email já existe
      final existingUsers = await db.query(
        StorageConstants.usersTable,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (existingUsers.isNotEmpty) {
        return AuthResult.failure('Este email já está cadastrado');
      }

      // Cria o novo usuário
      final user = UserModel(
        name: name.trim(),
        email: email.toLowerCase().trim(),
        passwordHash: passwordHash,
        createdAt: DateTime.now(),
      );

      final id = await db.insert(
        StorageConstants.usersTable,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      final newUser = user.copyWith(id: id);
      _currentUser = newUser;

      return AuthResult.success(newUser);
    } catch (e) {
      return AuthResult.failure('Erro ao registrar: ${e.toString()}');
    }
  }

  /// Realiza login do usuário
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthResult.failure('Email inválido');
      }

      if (password.isEmpty) {
        return AuthResult.failure('Senha é obrigatória');
      }

      final passwordHash = _hashPassword(password);

      // Web: usar WebStorage
      if (kIsWeb) {
        final user = await _webStorage.login(email.toLowerCase(), passwordHash);
        if (user != null) {
          return AuthResult.success(user);
        }
        return AuthResult.failure('Email ou senha incorretos');
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;

      final users = await db.query(
        StorageConstants.usersTable,
        where: 'email = ? AND password_hash = ?',
        whereArgs: [email.toLowerCase(), passwordHash],
      );

      if (users.isEmpty) {
        return AuthResult.failure('Email ou senha incorretos');
      }

      final user = UserModel.fromMap(users.first);
      _currentUser = user;

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Erro ao fazer login: ${e.toString()}');
    }
  }

  /// Realiza logout do usuário
  Future<void> logout() async {
    if (kIsWeb) {
      _webStorage.logout();
    } else {
      _currentUser = null;
    }
  }

  /// Busca um usuário pelo email
  Future<UserModel?> findUserByEmail(String email) async {
    try {
      // Web: usar WebStorage
      if (kIsWeb) {
        return _webStorage.findUserByEmail(email.toLowerCase());
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;
      final users = await db.query(
        StorageConstants.usersTable,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (users.isEmpty) return null;
      return UserModel.fromMap(users.first);
    } catch (e) {
      return null;
    }
  }

  /// Atualiza a senha do usuário
  Future<AuthResult> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final passwordError = _validatePassword(newPassword);
      if (passwordError != null) {
        return AuthResult.failure(passwordError);
      }

      final passwordHash = _hashPassword(newPassword);

      // Web: usar WebStorage
      if (kIsWeb) {
        final success = await _webStorage.updatePassword(
          email.toLowerCase(),
          passwordHash,
        );
        if (success) {
          return AuthResult.successMessage('Senha atualizada com sucesso');
        }
        return AuthResult.failure('Usuário não encontrado');
      }

      // Nativo: usar SQLite
      final db = await _localDatabase.database;

      final count = await db.update(
        StorageConstants.usersTable,
        {
          'password_hash': passwordHash,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (count == 0) {
        return AuthResult.failure('Usuário não encontrado');
      }

      return AuthResult.successMessage('Senha atualizada com sucesso');
    } catch (e) {
      return AuthResult.failure('Erro ao atualizar senha: ${e.toString()}');
    }
  }

  /// Define o usuário atual (para restaurar sessão)
  void setCurrentUser(UserModel? user) {
    if (!kIsWeb) {
      _currentUser = user;
    }
  }
}

/// Resultado de operações de autenticação
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? message;

  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.message,
  });

  factory AuthResult.success(UserModel user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.successMessage(String message) {
    return AuthResult._(isSuccess: true, message: message);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, message: message);
  }
}
