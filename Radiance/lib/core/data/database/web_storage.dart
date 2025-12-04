import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../models/prediction_model.dart';

class WebStorage {
  static final WebStorage instance = WebStorage._internal();
  WebStorage._internal();

  final List<UserModel> _users = [];
  int _userIdCounter = 1;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String passwordHash,
  }) async {
    final existingUser = _users.where((u) => u.email == email).firstOrNull;
    if (existingUser != null) {
      throw Exception('Email already registered');
    }

    final user = UserModel(
      id: _userIdCounter++,
      name: name,
      email: email,
      passwordHash: passwordHash,
      createdAt: DateTime.now(),
    );

    _users.add(user);
    _currentUser = user; // Auto-login after registration
    _log('User registered: ${user.email} (ID: ${user.id})');
    _log('User auto-logged in after registration');
    return user;
  }

  Future<UserModel?> findUserByEmail(String email) async {
    return _users.where((u) => u.email == email).firstOrNull;
  }

  Future<UserModel?> login(String email, String passwordHash) async {
    final user = await findUserByEmail(email);
    if (user != null && user.passwordHash == passwordHash) {
      _currentUser = user;
      _log('Login successful: ${user.email}');
      return user;
    }
    return null;
  }

  Future<void> logout() async {
    _log('Logout: ${_currentUser?.email}');
    _currentUser = null;
  }

  Future<bool> updatePassword(String email, String newPasswordHash) async {
    final index = _users.indexWhere((u) => u.email == email);
    if (index != -1) {
      final oldUser = _users[index];
      _users[index] = oldUser.copyWith(
        passwordHash: newPasswordHash,
        updatedAt: DateTime.now(),
      );
      _log('Password updated: $email');
      return true;
    }
    return false;
  }

  List<UserModel> get allUsers => List.unmodifiable(_users);

  final List<PredictionHistoryModel> _predictions = [];
  int _predictionIdCounter = 1;

  Future<PredictionHistoryModel> savePrediction(PredictionHistoryModel prediction) async {
    final newPrediction = prediction.copyWith(id: _predictionIdCounter++);
    _predictions.add(newPrediction);
    _log('Prediction saved: ID ${newPrediction.id}, Price: \$${newPrediction.predictedPrice.toStringAsFixed(2)}');
    return newPrediction;
  }

  Future<List<PredictionHistoryModel>> getPredictionsForUser(int userId) async {
    return _predictions
        .where((p) => p.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<PredictionHistoryModel>> getPaginatedPredictions({
    required int userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final userPredictions = await getPredictionsForUser(userId);
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    
    if (start >= userPredictions.length) return [];
    return userPredictions.sublist(start, end.clamp(0, userPredictions.length));
  }

  Future<int> countPredictionsForUser(int userId) async {
    return _predictions.where((p) => p.userId == userId).length;
  }

  Future<double> getAveragePrice(int userId) async {
    final userPredictions = _predictions.where((p) => p.userId == userId).toList();
    if (userPredictions.isEmpty) return 0.0;
    
    final total = userPredictions.fold<double>(0, (sum, p) => sum + p.predictedPrice);
    return total / userPredictions.length;
  }

  Future<PredictionHistoryModel?> getLastPrediction(int userId) async {
    final userPredictions = await getPredictionsForUser(userId);
    return userPredictions.isNotEmpty ? userPredictions.first : null;
  }

  Future<bool> deletePrediction(int id) async {
    final index = _predictions.indexWhere((p) => p.id == id);
    if (index != -1) {
      _predictions.removeAt(index);
      _log('Prediction deleted: ID $id');
      return true;
    }
    return false;
  }

  Future<bool> clearHistoryForUser(int userId) async {
    final countBefore = _predictions.length;
    _predictions.removeWhere((p) => p.userId == userId);
    final removed = countBefore - _predictions.length;
    _log('History cleared for user $userId: $removed predictions removed');
    return true;
  }

  void clearAll() {
    _users.clear();
    _predictions.clear();
    _currentUser = null;
    _userIdCounter = 1;
    _predictionIdCounter = 1;
    _log('All data cleared');
  }

  void _log(String message) {
    if (kIsWeb) {
      print('[WebStorage] $message');
    }
  }

  static bool get isWeb => kIsWeb;

  Future<void> seedTestData() async {
    if (_users.isEmpty) {
      await registerUser(
        name: 'Test User',
        email: 'test@test.com',
        passwordHash: _hashPassword('123456'),
      );
      
      await registerUser(
        name: 'Admin',
        email: 'admin@admin.com',
        passwordHash: _hashPassword('admin123'),
      );
      
      _log('Test data created');
      _log('Test login: test@test.com / 123456');
      _log('Admin login: admin@admin.com / admin123');
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
