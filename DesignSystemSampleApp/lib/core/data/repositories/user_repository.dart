import 'package:sqflite/sqflite.dart';
import '../database/database_service.dart';
import '../models/user_model.dart';

/// Repositório de Usuários
/// 
/// Gerencia operações CRUD de usuários no banco de dados.
class UserRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  
  /// Insere um novo usuário
  Future<int> insert(User user) async {
    final db = await _dbService.database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
  
  /// Busca usuário por username
  Future<User?> findByUsername(String username) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username.toLowerCase()],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
  
  /// Busca usuário por ID
  Future<User?> findById(int id) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
  
  /// Busca usuário por nome completo e data de nascimento
  /// Usado para recuperação de senha
  Future<User?> findByNameAndBirthDate(String fullName, DateTime birthDate) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'users',
      where: 'LOWER(full_name) = ? AND birth_date = ?',
      whereArgs: [
        fullName.toLowerCase().trim(),
        birthDate.toIso8601String(),
      ],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
  
  /// Atualiza a senha do usuário
  Future<int> updatePassword(int userId, String newPasswordHash) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      {'password_hash': newPasswordHash},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  
  /// Atualiza dados do usuário
  Future<int> update(User user) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  
  /// Remove um usuário
  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  /// Lista todos os usuários
  Future<List<User>> findAll() async {
    final db = await _dbService.database;
    final maps = await db.query('users', orderBy: 'created_at DESC');
    return maps.map((map) => User.fromMap(map)).toList();
  }
  
  /// Verifica se username já existe
  Future<bool> usernameExists(String username) async {
    final user = await findByUsername(username);
    return user != null;
  }
}
