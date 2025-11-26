import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Serviço de Banco de Dados Local
/// 
/// Gerencia a conexão com o SQLite e operações de banco.
class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._internal();
  
  DatabaseService._internal();
  
  /// Obtém a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diamond_app.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  /// Cria as tabelas do banco
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        birth_date TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    // Índice para busca por username
    await db.execute('''
      CREATE INDEX idx_username ON users(username)
    ''');
  }
  
  /// Atualiza o banco em novas versões
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Futuras migrações aqui
  }
  
  /// Fecha a conexão com o banco
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
  
  /// Limpa todos os dados (para testes)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('users');
  }
}
