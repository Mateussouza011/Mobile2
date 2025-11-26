import '../database/database_service.dart';
import '../models/user_model.dart';

/// Repositório de Usuários
/// 
/// Gerencia operações CRUD de usuários no banco de dados.
class UserRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  
  /// Insere um novo usuário
  Future<int> insert(User user) async {
    // Verifica se username já existe
    final existing = await findByUsername(user.username);
    if (existing != null) {
      throw Exception('Username já existe');
    }
    
    return await _dbService.insert('users', user.toMap());
  }
  
  /// Busca usuário por username
  Future<User?> findByUsername(String username) async {
    final maps = await _dbService.query(
      'users',
      where: 'username = ?',
      whereArgs: [username.toLowerCase()],
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
  
  /// Busca usuário por ID
  Future<User?> findById(int id) async {
    final maps = await _dbService.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }
  
  /// Busca usuário por nome completo e data de nascimento
  /// Usado para recuperação de senha
  Future<User?> findByNameAndBirthDate(String fullName, DateTime birthDate) async {
    // Busca todos os usuários e filtra manualmente para web
    final allUsers = await _dbService.query('users');
    
    final searchName = fullName.toLowerCase().trim();
    final searchDate = birthDate.toIso8601String();
    
    for (var map in allUsers) {
      final name = (map['full_name'] as String?)?.toLowerCase().trim();
      final date = map['birth_date'] as String?;
      
      if (name == searchName && date == searchDate) {
        return User.fromMap(map);
      }
    }
    
    return null;
  }
  
  /// Atualiza a senha do usuário
  Future<int> updatePassword(int userId, String newPasswordHash) async {
    return await _dbService.update(
      'users',
      {'password_hash': newPasswordHash},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  
  /// Atualiza dados do usuário
  Future<int> update(User user) async {
    return await _dbService.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  
  /// Remove um usuário
  Future<int> delete(int id) async {
    return await _dbService.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  /// Lista todos os usuários
  Future<List<User>> findAll() async {
    final maps = await _dbService.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
  
  /// Verifica se username já existe
  Future<bool> usernameExists(String username) async {
    final user = await findByUsername(username);
    return user != null;
  }
}
