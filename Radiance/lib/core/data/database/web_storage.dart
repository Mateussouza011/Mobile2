import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../models/prediction_model.dart';

/// Armazenamento em memória para a versão Web (fase de testes)
/// 
/// Na web, SQLite não funciona diretamente, então usamos
/// armazenamento em memória para simular o comportamento.
/// Os dados são perdidos ao recarregar a página.
class WebStorage {
  static final WebStorage instance = WebStorage._internal();
  WebStorage._internal();

  // ============================================
  // Armazenamento de Usuários
  // ============================================
  final List<UserModel> _users = [];
  int _userIdCounter = 1;
  UserModel? _currentUser;

  /// Usuário atualmente logado
  UserModel? get currentUser => _currentUser;

  /// Registra um novo usuário
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String passwordHash,
  }) async {
    // Verifica se email já existe
    final existingUser = _users.where((u) => u.email == email).firstOrNull;
    if (existingUser != null) {
      throw Exception('Email já cadastrado');
    }

    final user = UserModel(
      id: _userIdCounter++,
      name: name,
      email: email,
      passwordHash: passwordHash,
      createdAt: DateTime.now(),
    );

    _users.add(user);
    _log('Usuário registrado: ${user.email} (ID: ${user.id})');
    return user;
  }

  /// Busca usuário por email
  Future<UserModel?> findUserByEmail(String email) async {
    return _users.where((u) => u.email == email).firstOrNull;
  }

  /// Faz login do usuário
  Future<UserModel?> login(String email, String passwordHash) async {
    final user = await findUserByEmail(email);
    if (user != null && user.passwordHash == passwordHash) {
      _currentUser = user;
      _log('Login realizado: ${user.email}');
      return user;
    }
    return null;
  }

  /// Faz logout
  Future<void> logout() async {
    _log('Logout: ${_currentUser?.email}');
    _currentUser = null;
  }

  /// Atualiza senha do usuário
  Future<bool> updatePassword(String email, String newPasswordHash) async {
    final index = _users.indexWhere((u) => u.email == email);
    if (index != -1) {
      final oldUser = _users[index];
      _users[index] = oldUser.copyWith(
        passwordHash: newPasswordHash,
        updatedAt: DateTime.now(),
      );
      _log('Senha atualizada: $email');
      return true;
    }
    return false;
  }

  /// Lista todos os usuários (para debug)
  List<UserModel> get allUsers => List.unmodifiable(_users);

  // ============================================
  // Armazenamento de Predições
  // ============================================
  final List<PredictionHistoryModel> _predictions = [];
  int _predictionIdCounter = 1;

  /// Salva uma nova predição
  Future<PredictionHistoryModel> savePrediction(PredictionHistoryModel prediction) async {
    final newPrediction = prediction.copyWith(id: _predictionIdCounter++);
    _predictions.add(newPrediction);
    _log('Predição salva: ID ${newPrediction.id}, Preço: \$${newPrediction.predictedPrice.toStringAsFixed(2)}');
    return newPrediction;
  }

  /// Obtém predições de um usuário
  Future<List<PredictionHistoryModel>> getPredictionsForUser(int userId) async {
    return _predictions
        .where((p) => p.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Obtém predições paginadas
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

  /// Conta predições de um usuário
  Future<int> countPredictionsForUser(int userId) async {
    return _predictions.where((p) => p.userId == userId).length;
  }

  /// Calcula preço médio
  Future<double> getAveragePrice(int userId) async {
    final userPredictions = _predictions.where((p) => p.userId == userId).toList();
    if (userPredictions.isEmpty) return 0.0;
    
    final total = userPredictions.fold<double>(0, (sum, p) => sum + p.predictedPrice);
    return total / userPredictions.length;
  }

  /// Obtém última predição
  Future<PredictionHistoryModel?> getLastPrediction(int userId) async {
    final userPredictions = await getPredictionsForUser(userId);
    return userPredictions.isNotEmpty ? userPredictions.first : null;
  }

  /// Deleta uma predição
  Future<bool> deletePrediction(int id) async {
    final index = _predictions.indexWhere((p) => p.id == id);
    if (index != -1) {
      _predictions.removeAt(index);
      _log('Predição deletada: ID $id');
      return true;
    }
    return false;
  }

  /// Limpa todas as predições de um usuário
  Future<bool> clearHistoryForUser(int userId) async {
    final countBefore = _predictions.length;
    _predictions.removeWhere((p) => p.userId == userId);
    final removed = countBefore - _predictions.length;
    _log('Histórico limpo para usuário $userId: $removed predições removidas');
    return true;
  }

  // ============================================
  // Utilitários
  // ============================================
  
  /// Limpa todos os dados (para testes)
  void clearAll() {
    _users.clear();
    _predictions.clear();
    _currentUser = null;
    _userIdCounter = 1;
    _predictionIdCounter = 1;
    _log('Todos os dados foram limpos');
  }

  /// Log para debug
  void _log(String message) {
    if (kIsWeb) {
      // ignore: avoid_print
      print('[WebStorage] $message');
    }
  }

  /// Verifica se está rodando na web
  static bool get isWeb => kIsWeb;

  /// Adiciona usuários de teste
  Future<void> seedTestData() async {
    if (_users.isEmpty) {
      // Usuário de teste padrão
      await registerUser(
        name: 'Usuário Teste',
        email: 'teste@teste.com',
        passwordHash: _hashPassword('123456'),
      );
      
      await registerUser(
        name: 'Admin',
        email: 'admin@admin.com',
        passwordHash: _hashPassword('admin123'),
      );
      
      _log('Dados de teste criados');
      _log('Login de teste: teste@teste.com / 123456');
      _log('Login admin: admin@admin.com / admin123');
    }
  }

  /// Hash simples para senha (mesmo usado no AuthRepository)
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
