import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Helper para gerenciar o banco de dados SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'diamond_predictions.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prediction_history (
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
        timestamp TEXT NOT NULL
      )
    ''');

    // Criar índice para melhor performance
    await db.execute('''
      CREATE INDEX idx_user_timestamp 
      ON prediction_history(user_id, timestamp DESC)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migração de versões futuras
    if (oldVersion < 2) {
      // Exemplo de migração
      // await db.execute('ALTER TABLE prediction_history ADD COLUMN new_field TEXT');
    }
  }

  /// Fecha o banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Limpa todas as tabelas (útil para testes)
  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete('prediction_history');
  }
}
