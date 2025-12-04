import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database/local_database.dart';
import '../database/web_storage.dart';
import '../models/user_model.dart';
import '../../constants/api_constants.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  static AuthRepository get instance => _instance;
  
  factory AuthRepository() => _instance;
  
  AuthRepository._internal()
      : _localDatabase = LocalDatabase.instance,
        _webStorage = WebStorage.instance;

  final LocalDatabase _localDatabase;
  final WebStorage _webStorage;
  UserModel? _currentUser;

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
      return 'Password must be at least 6 characters';
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
        return AuthResult.failure('Name is required');
      }
      
      if (!_isValidEmail(email)) {
        return AuthResult.failure('Invalid email');
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
        return AuthResult.failure('This email is already registered');
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
      return AuthResult.failure('Registration error: ${e.toString()}');
    }
  }
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthResult.failure('Invalid email');
      }

      if (password.isEmpty) {
        return AuthResult.failure('Password is required');
      }

      final passwordHash = _hashPassword(password);
      if (kIsWeb) {
        final user = await _webStorage.login(email.toLowerCase(), passwordHash);
        if (user != null) {
          return AuthResult.success(user);
        }
        return AuthResult.failure('Incorrect email or password');
      }
      final db = await _localDatabase.database;

      final users = await db.query(
        StorageConstants.usersTable,
        where: 'email = ? AND password_hash = ?',
        whereArgs: [email.toLowerCase(), passwordHash],
      );

      if (users.isEmpty) {
        return AuthResult.failure('Incorrect email or password');
      }

      final user = UserModel.fromMap(users.first);
      _currentUser = user;

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Login error: ${e.toString()}');
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
          return AuthResult.successMessage('Password updated successfully');
        }
        return AuthResult.failure('User not found');
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
        return AuthResult.failure('User not found');
      }

      return AuthResult.successMessage('Password updated successfully');
    } catch (e) {
      return AuthResult.failure('Error updating password: ${e.toString()}');
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
