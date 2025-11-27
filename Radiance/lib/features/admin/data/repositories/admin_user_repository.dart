import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../data/datasources/local/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../multi_tenant/domain/entities/company_user.dart';
import '../../domain/entities/admin_user_stats.dart';

class AdminUserRepository {
  final DatabaseHelper _databaseHelper;

  AdminUserRepository(this._databaseHelper);

  /// Lista todos os usuários com filtros
  Future<Either<Failure, List<AdminUserStats>>> getAllUsers(
    UserFilters filters,
  ) async {
    try {
      final db = await _databaseHelper.database;

      // Query base com JOINs
      var query = '''
        SELECT 
          u.*,
          u.created_at as user_created_at,
          u.is_active as user_is_active,
          COALESCE(COUNT(DISTINCT ph.id), 0) as total_predictions,
          COALESCE(SUM(CASE 
            WHEN ph.created_at >= date('now', 'start of month') 
            THEN 1 ELSE 0 
          END), 0) as predictions_this_month,
          MAX(ph.created_at) as last_activity
        FROM users u
        LEFT JOIN prediction_history ph ON ph.user_id = u.id
        WHERE 1=1
      ''';

      final args = <dynamic>[];

      // Filtro de busca
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        query += ' AND (u.name LIKE ? OR u.email LIKE ?)';
        final searchTerm = '%${filters.searchQuery}%';
        args.add(searchTerm);
        args.add(searchTerm);
      }

      // Filtro de ativo/inativo
      if (filters.isActive != null) {
        query += ' AND u.is_active = ?';
        args.add(filters.isActive! ? 1 : 0);
      }

      // Filtro de data de criação
      if (filters.createdAfter != null) {
        query += ' AND u.created_at >= ?';
        args.add(filters.createdAfter!.toIso8601String());
      }

      if (filters.createdBefore != null) {
        query += ' AND u.created_at <= ?';
        args.add(filters.createdBefore!.toIso8601String());
      }

      query += ' GROUP BY u.id';

      // Ordenação
      switch (filters.sortBy) {
        case UserSortBy.name:
          query += ' ORDER BY u.name';
          break;
        case UserSortBy.email:
          query += ' ORDER BY u.email';
          break;
        case UserSortBy.createdAt:
          query += ' ORDER BY u.created_at';
          break;
        case UserSortBy.lastLogin:
          query += ' ORDER BY u.last_login';
          break;
        case UserSortBy.totalPredictions:
          query += ' ORDER BY total_predictions';
          break;
      }

      query += filters.ascending ? ' ASC' : ' DESC';

      final results = await db.rawQuery(query, args);

      final users = <AdminUserStats>[];
      for (final row in results) {
        final user = _mapToUser(row);
        
        // Buscar empresas do usuário
        final companies = await _getUserCompanies(db, user.id);

        // Aplicar filtros pós-query
        if (filters.companyId != null) {
          if (!companies.any((c) => c.companyId == filters.companyId)) {
            continue;
          }
        }

        if (filters.role != null) {
          if (!companies.any((c) => c.role == filters.role)) {
            continue;
          }
        }

        // Buscar último login (da tabela user_activity_logs se existir)
        final lastLogin = await _getLastLogin(db, user.id);

        users.add(AdminUserStats(
          user: user,
          companies: companies,
          totalPredictions: row['total_predictions'] as int? ?? 0,
          predictionsThisMonth: row['predictions_this_month'] as int? ?? 0,
          lastActivity: row['last_activity'] != null
              ? DateTime.parse(row['last_activity'] as String)
              : null,
          lastLogin: lastLogin,
          isActive: (row['user_is_active'] as int? ?? 1) == 1,
          createdAt: DateTime.parse(row['user_created_at'] as String),
        ));
      }

      return Right(users);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar usuários: $e'));
    }
  }

  /// Busca detalhes de um usuário
  Future<Either<Failure, AdminUserStats>> getUserDetails(String userId) async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (results.isEmpty) {
        return Left(DatabaseFailure('Usuário não encontrado'));
      }

      final user = _mapToUser(results.first);
      final companies = await _getUserCompanies(db, userId);
      final lastLogin = await _getLastLogin(db, userId);

      // Contar previsões
      final predictions = await db.rawQuery('''
        SELECT 
          COUNT(*) as total,
          SUM(CASE 
            WHEN created_at >= date('now', 'start of month') 
            THEN 1 ELSE 0 
          END) as this_month,
          MAX(created_at) as last_activity
        FROM prediction_history
        WHERE user_id = ?
      ''', [userId]);

      final stats = AdminUserStats(
        user: user,
        companies: companies,
        totalPredictions: predictions.first['total'] as int? ?? 0,
        predictionsThisMonth: predictions.first['this_month'] as int? ?? 0,
        lastActivity: predictions.first['last_activity'] != null
            ? DateTime.parse(predictions.first['last_activity'] as String)
            : null,
        lastLogin: lastLogin,
        isActive: (results.first['is_active'] as int? ?? 1) == 1,
        createdAt: DateTime.parse(results.first['created_at'] as String),
      );

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar detalhes: $e'));
    }
  }

  /// Desativa um usuário
  Future<Either<Failure, void>> disableUser(String userId) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'users',
        {'is_active': 0, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );

      // Log da ação
      await _logActivity(db, userId, 'account_disabled', 'Conta desativada por admin');

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao desativar usuário: $e'));
    }
  }

  /// Reativa um usuário
  Future<Either<Failure, void>> enableUser(String userId) async {
    try {
      final db = await _databaseHelper.database;
      
      await db.update(
        'users',
        {'is_active': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );

      // Log da ação
      await _logActivity(db, userId, 'account_enabled', 'Conta reativada por admin');

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao reativar usuário: $e'));
    }
  }

  /// Reseta a senha do usuário
  Future<Either<Failure, String>> resetPassword(String userId) async {
    try {
      final db = await _databaseHelper.database;
      
      // Gerar senha temporária (8 caracteres)
      final tempPassword = _generateTempPassword();
      
      // Atualizar senha (em produção, usar hash apropriado)
      await db.update(
        'users',
        {
          'password': tempPassword, // TODO: Hash adequado
          'password_reset_required': 1,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      // Log da ação
      await _logActivity(db, userId, 'password_reset', 'Senha resetada por admin');

      return Right(tempPassword);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao resetar senha: $e'));
    }
  }

  /// Busca logs de atividade do usuário
  Future<Either<Failure, List<UserActivityLog>>> getUserActivityLogs(
    String userId, {
    int days = 30,
  }) async {
    try {
      final db = await _databaseHelper.database;
      
      // Verificar se tabela existe
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='user_activity_logs'",
      );

      if (tables.isEmpty) {
        // Criar tabela se não existir
        await _createActivityLogsTable(db);
        return const Right([]);
      }

      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      
      final results = await db.query(
        'user_activity_logs',
        where: 'user_id = ? AND timestamp >= ?',
        whereArgs: [userId, cutoffDate.toIso8601String()],
        orderBy: 'timestamp DESC',
        limit: 100,
      );

      final logs = results.map((row) => UserActivityLog(
        id: row['id'] as String,
        userId: row['user_id'] as String,
        action: row['action'] as String,
        details: row['details'] as String?,
        companyId: row['company_id'] as String?,
        timestamp: DateTime.parse(row['timestamp'] as String),
      )).toList();

      return Right(logs);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar logs: $e'));
    }
  }

  /// Estatísticas gerais do sistema
  Future<Either<Failure, Map<String, dynamic>>> getSystemUserStats() async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_users,
          SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_users,
          SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) as disabled_users,
          COUNT(DISTINCT CASE 
            WHEN last_login >= date('now', '-7 days') 
            THEN id 
          END) as active_this_week,
          COUNT(DISTINCT CASE 
            WHEN created_at >= date('now', 'start of month') 
            THEN id 
          END) as new_this_month
        FROM users
      ''');

      final stats = results.first;

      return Right({
        'totalUsers': stats['total_users'] ?? 0,
        'activeUsers': stats['active_users'] ?? 0,
        'disabledUsers': stats['disabled_users'] ?? 0,
        'activeThisWeek': stats['active_this_week'] ?? 0,
        'newThisMonth': stats['new_this_month'] ?? 0,
      });
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar estatísticas: $e'));
    }
  }

  // ==================== HELPERS ====================

  User _mapToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String? ?? '',
      cpf: map['cpf'] as String?,
      phoneNumber: map['phone_number'] as String?,
      profilePictureUrl: map['profile_picture_url'] as String?,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      lastLogin: map['last_login'] != null
          ? DateTime.parse(map['last_login'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Future<List<CompanyUser>> _getUserCompanies(
    Database db,
    String userId,
  ) async {
    final results = await db.query(
      'company_users',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return results.map((row) => CompanyUser(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      userId: row['user_id'] as String,
      role: row['role'] as String,
      isActive: (row['is_active'] as int? ?? 1) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: row['updated_at'] != null
          ? DateTime.parse(row['updated_at'] as String)
          : null,
    )).toList();
  }

  Future<DateTime?> _getLastLogin(Database db, String userId) async {
    final result = await db.query(
      'users',
      columns: ['last_login'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isEmpty || result.first['last_login'] == null) {
      return null;
    }

    return DateTime.parse(result.first['last_login'] as String);
  }

  Future<void> _logActivity(
    Database db,
    String userId,
    String action,
    String? details,
  ) async {
    // Verificar se tabela existe
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='user_activity_logs'",
    );

    if (tables.isEmpty) {
      await _createActivityLogsTable(db);
    }

    await db.insert('user_activity_logs', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'action': action,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _createActivityLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_activity_logs (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        action TEXT NOT NULL,
        details TEXT,
        company_id TEXT,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  String _generateTempPassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var password = '';
    
    for (var i = 0; i < 8; i++) {
      password += chars[(random + i) % chars.length];
    }
    
    return password;
  }
}
