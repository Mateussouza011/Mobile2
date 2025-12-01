import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database/local_database.dart';
import '../database/web_storage.dart';
import '../models/user_model.dart';
import '../../constants/api_constants.dart';
class AuthRepository {
  final LocalDatabase _localDatabase;
  final WebStorage _webStorage;
  UserModel? _currentUser;

  AuthRepository({LocalDatabase? localDatabase})
      : _localDatabase = localDatabase ?? LocalDatabase.instance,
        _webStorage = WebStorage.instance;
  UserModel? get currentUser => kIsWeb ? _webStorage.currentUser : _currentUser;
  bool get isLoggedIn => currentUser != null;
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
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
      final db = await _localDatabase.database;
      final existingUsers = await db.query(
        StorageConstants.usersTable,
        where: 'email = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (existingUsers.isNotEmpty) {
        return AuthResult.failure('Este email já está cadastrado');
      }
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
      if (kIsWeb) {
        final user = await _webStorage.login(email.toLowerCase(), passwordHash);
        if (user != null) {
          return AuthResult.success(user);
        }
        return AuthResult.failure('Email ou senha incorretos');
      }
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
  Future<void> logout() async {
    if (kIsWeb) {
      _webStorage.logout();
    } else {
      _currentUser = null;
    }
  }
  Future<UserModel?> findUserByEmail(String email) async {
    try {
      if (kIsWeb) {
        return _webStorage.findUserByEmail(email.toLowerCase());
      }
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
  void setCurrentUser(UserModel? user) {
    if (!kIsWeb) {
      _currentUser = user;
    }
  }
}
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
