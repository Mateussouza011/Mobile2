import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../constants/api_constants.dart';

/// Gerenciador do banco de dados SQLite local
class LocalDatabase {
  static Database? _database;
  static final LocalDatabase instance = LocalDatabase._internal();

  LocalDatabase._internal();

  /// Obtém a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, StorageConstants.databaseName);

    return await openDatabase(
      path,
      version: StorageConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Cria as tabelas do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE ${StorageConstants.usersTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Tabela de histórico de predições
    await db.execute('''
      CREATE TABLE ${StorageConstants.predictionHistoryTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        carat REAL NOT NULL,
        cut TEXT NOT NULL,
        color TEXT NOT NULL,
        clarity TEXT NOT NULL,
        depth REAL NOT NULL,
        table_value REAL NOT NULL,
        x REAL NOT NULL,
        y REAL NOT NULL,
        z REAL NOT NULL,
        predicted_price REAL NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES ${StorageConstants.usersTable}(id)
          ON DELETE CASCADE
      )
    ''');

    // Índices para melhor performance
    await db.execute('''
      CREATE INDEX idx_prediction_user_id 
      ON ${StorageConstants.predictionHistoryTable}(user_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_prediction_created_at 
      ON ${StorageConstants.predictionHistoryTable}(created_at DESC)
    ''');

    await db.execute('''
      CREATE UNIQUE INDEX idx_users_email 
      ON ${StorageConstants.usersTable}(email)
    ''');
  }

  /// Atualiza o banco de dados para novas versões
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Adicione migrações futuras aqui
    // if (oldVersion < 2) { ... }
  }

  /// Fecha o banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Limpa todos os dados (para logout ou reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(StorageConstants.predictionHistoryTable);
    await db.delete(StorageConstants.usersTable);
  }

  /// Reseta o banco de dados (recria do zero)
  Future<void> resetDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, StorageConstants.databaseName);
    
    await close();
    await deleteDatabase(path);
    _database = await _initDatabase();
  }
}
