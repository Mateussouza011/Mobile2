import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../../../../data/datasources/local/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_audit_log.dart';

class AdminAuditRepository {
  final DatabaseHelper _databaseHelper;

  AdminAuditRepository(this._databaseHelper);

  /// Busca logs de auditoria com filtros
  Future<Either<Failure, List<AdminAuditLog>>> getAuditLogs({
    AuditLogFilters? filters,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      // Build query
      final where = <String>[];
      final whereArgs = <dynamic>[];

      if (filters != null) {
        // Search query
        if (filters.searchQuery?.isNotEmpty == true) {
          where.add('(action LIKE ? OR user_name LIKE ? OR target_name LIKE ?)');
          final searchTerm = '%${filters.searchQuery}%';
          whereArgs.addAll([searchTerm, searchTerm, searchTerm]);
        }

        // Category
        if (filters.category != null) {
          where.add('category = ?');
          whereArgs.add(filters.category!.name);
        }

        // Severity
        if (filters.severity != null) {
          where.add('severity = ?');
          whereArgs.add(filters.severity!.name);
        }

        // User ID
        if (filters.userId?.isNotEmpty == true) {
          where.add('user_id = ?');
          whereArgs.add(filters.userId);
        }

        // Target type
        if (filters.targetType?.isNotEmpty == true) {
          where.add('target_type = ?');
          whereArgs.add(filters.targetType);
        }

        // Date range
        if (filters.startDate != null) {
          where.add('created_at >= ?');
          whereArgs.add(filters.startDate!.toIso8601String());
        }
        if (filters.endDate != null) {
          where.add('created_at <= ?');
          whereArgs.add(filters.endDate!.toIso8601String());
        }
      }

      // Sort
      final sortColumn = _getSortColumn(filters?.sortBy ?? AuditLogSortBy.createdAt);
      final sortOrder = (filters?.ascending ?? false) ? 'ASC' : 'DESC';

      final results = await db.query(
        'audit_logs',
        where: where.isEmpty ? null : where.join(' AND '),
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: '$sortColumn $sortOrder',
        limit: limit,
        offset: offset,
      );

      final logs = results.map(_mapToAuditLog).toList();
      return Right(logs);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar logs de auditoria: $e'));
    }
  }

  /// Busca um log específico por ID
  Future<Either<Failure, AdminAuditLog>> getAuditLogById(String id) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      final results = await db.query(
        'audit_logs',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return const Left(DatabaseFailure('Log não encontrado'));
      }

      return Right(_mapToAuditLog(results.first));
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar log: $e'));
    }
  }

  /// Cria um novo log de auditoria
  Future<Either<Failure, void>> createAuditLog({
    required String action,
    required AuditLogCategory category,
    String? userId,
    String? userName,
    String? targetId,
    String? targetType,
    String? targetName,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    String? userAgent,
    AuditLogSeverity severity = AuditLogSeverity.info,
  }) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now().toIso8601String();

      await db.insert('audit_logs', {
        'id': id,
        'action': action,
        'category': category.name,
        'user_id': userId,
        'user_name': userName,
        'target_id': targetId,
        'target_type': targetType,
        'target_name': targetName,
        'metadata': metadata != null ? jsonEncode(metadata) : null,
        'ip_address': ipAddress,
        'user_agent': userAgent,
        'severity': severity.name,
        'created_at': now,
      });

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao criar log: $e'));
    }
  }

  /// Busca estatísticas de logs
  Future<Either<Failure, AuditLogStats>> getAuditLogStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      final where = <String>[];
      final whereArgs = <dynamic>[];

      if (startDate != null) {
        where.add('created_at >= ?');
        whereArgs.add(startDate.toIso8601String());
      }
      if (endDate != null) {
        where.add('created_at <= ?');
        whereArgs.add(endDate.toIso8601String());
      }

      // Total and severity counts
      final severityResults = await db.rawQuery('''
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN severity = 'info' THEN 1 ELSE 0 END) as info_count,
          SUM(CASE WHEN severity = 'warning' THEN 1 ELSE 0 END) as warning_count,
          SUM(CASE WHEN severity = 'critical' THEN 1 ELSE 0 END) as critical_count
        FROM audit_logs
        ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ''', whereArgs.isEmpty ? null : whereArgs);

      final severityData = severityResults.first;

      // Logs by category
      final categoryResults = await db.rawQuery('''
        SELECT category, COUNT(*) as count
        FROM audit_logs
        ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
        GROUP BY category
      ''', whereArgs.isEmpty ? null : whereArgs);

      final logsByCategory = <AuditLogCategory, int>{};
      for (final row in categoryResults) {
        final categoryName = row['category'] as String;
        final category = AuditLogCategory.values.firstWhere(
          (c) => c.name == categoryName,
          orElse: () => AuditLogCategory.system,
        );
        logsByCategory[category] = row['count'] as int;
      }

      // Top users
      final topUsersResults = await db.rawQuery('''
        SELECT user_name, COUNT(*) as count
        FROM audit_logs
        WHERE user_name IS NOT NULL
        ${where.isEmpty ? '' : 'AND ${where.join(' AND ')}'}
        GROUP BY user_name
        ORDER BY count DESC
        LIMIT 10
      ''', whereArgs.isEmpty ? null : whereArgs);

      final topUsers = <String, int>{};
      for (final row in topUsersResults) {
        final userName = row['user_name'] as String?;
        if (userName != null) {
          topUsers[userName] = row['count'] as int;
        }
      }

      // Top actions
      final topActionsResults = await db.rawQuery('''
        SELECT action, COUNT(*) as count
        FROM audit_logs
        ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
        GROUP BY action
        ORDER BY count DESC
        LIMIT 10
      ''', whereArgs.isEmpty ? null : whereArgs);

      final topActions = <String, int>{};
      for (final row in topActionsResults) {
        topActions[row['action'] as String] = row['count'] as int;
      }

      final stats = AuditLogStats(
        totalLogs: severityData['total'] as int? ?? 0,
        infoCount: severityData['info_count'] as int? ?? 0,
        warningCount: severityData['warning_count'] as int? ?? 0,
        criticalCount: severityData['critical_count'] as int? ?? 0,
        logsByCategory: logsByCategory,
        topUsers: topUsers,
        topActions: topActions,
      );

      return Right(stats);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar estatísticas: $e'));
    }
  }

  /// Exporta logs para CSV
  Future<Either<Failure, String>> exportToCSV({
    AuditLogFilters? filters,
    int? limit,
  }) async {
    try {
      final logsResult = await getAuditLogs(filters: filters, limit: limit ?? 10000);

      return logsResult.fold(
        (failure) => Left(failure),
        (logs) {
          final csv = StringBuffer();
          
          // Header
          csv.writeln('ID,Data/Hora,Ação,Categoria,Severidade,Usuário,Alvo,Tipo Alvo,IP,Metadados');

          // Rows
          for (final log in logs) {
            csv.writeln([
              log.id,
              log.createdAt.toIso8601String(),
              _escapeCsv(log.action),
              log.category.name,
              log.severity.name,
              _escapeCsv(log.userName ?? ''),
              _escapeCsv(log.targetName ?? ''),
              _escapeCsv(log.targetType ?? ''),
              _escapeCsv(log.ipAddress ?? ''),
              _escapeCsv(log.formattedMetadata),
            ].join(','));
          }

          return Right(csv.toString());
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Erro ao exportar CSV: $e'));
    }
  }

  /// Deleta logs antigos
  Future<Either<Failure, int>> deleteOldLogs(DateTime beforeDate) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      final deletedCount = await db.delete(
        'audit_logs',
        where: 'created_at < ?',
        whereArgs: [beforeDate.toIso8601String()],
      );

      return Right(deletedCount);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao deletar logs: $e'));
    }
  }

  /// Conta total de logs com filtros
  Future<Either<Failure, int>> countLogs({AuditLogFilters? filters}) async {
    try {
      final db = await _databaseHelper.database;
      await _ensureAuditLogsTableExists(db);

      final where = <String>[];
      final whereArgs = <dynamic>[];

      if (filters != null) {
        if (filters.searchQuery?.isNotEmpty == true) {
          where.add('(action LIKE ? OR user_name LIKE ? OR target_name LIKE ?)');
          final searchTerm = '%${filters.searchQuery}%';
          whereArgs.addAll([searchTerm, searchTerm, searchTerm]);
        }

        if (filters.category != null) {
          where.add('category = ?');
          whereArgs.add(filters.category!.name);
        }

        if (filters.severity != null) {
          where.add('severity = ?');
          whereArgs.add(filters.severity!.name);
        }

        if (filters.userId?.isNotEmpty == true) {
          where.add('user_id = ?');
          whereArgs.add(filters.userId);
        }

        if (filters.targetType?.isNotEmpty == true) {
          where.add('target_type = ?');
          whereArgs.add(filters.targetType);
        }

        if (filters.startDate != null) {
          where.add('created_at >= ?');
          whereArgs.add(filters.startDate!.toIso8601String());
        }
        if (filters.endDate != null) {
          where.add('created_at <= ?');
          whereArgs.add(filters.endDate!.toIso8601String());
        }
      }

      final result = await db.rawQuery('''
        SELECT COUNT(*) as count
        FROM audit_logs
        ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ''', whereArgs.isEmpty ? null : whereArgs);

      return Right(result.first['count'] as int? ?? 0);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao contar logs: $e'));
    }
  }

  // ==================== HELPERS ====================

  AdminAuditLog _mapToAuditLog(Map<String, dynamic> map) {
    return AdminAuditLog(
      id: map['id'] as String,
      action: map['action'] as String,
      category: AuditLogCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => AuditLogCategory.system,
      ),
      userId: map['user_id'] as String?,
      userName: map['user_name'] as String?,
      targetId: map['target_id'] as String?,
      targetType: map['target_type'] as String?,
      targetName: map['target_name'] as String?,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : null,
      ipAddress: map['ip_address'] as String?,
      userAgent: map['user_agent'] as String?,
      severity: AuditLogSeverity.values.firstWhere(
        (s) => s.name == map['severity'],
        orElse: () => AuditLogSeverity.info,
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  String _getSortColumn(AuditLogSortBy sortBy) {
    switch (sortBy) {
      case AuditLogSortBy.createdAt:
        return 'created_at';
      case AuditLogSortBy.action:
        return 'action';
      case AuditLogSortBy.category:
        return 'category';
      case AuditLogSortBy.severity:
        return 'severity';
      case AuditLogSortBy.userName:
        return 'user_name';
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<void> _ensureAuditLogsTableExists(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS audit_logs (
        id TEXT PRIMARY KEY,
        action TEXT NOT NULL,
        category TEXT NOT NULL,
        user_id TEXT,
        user_name TEXT,
        target_id TEXT,
        target_type TEXT,
        target_name TEXT,
        metadata TEXT,
        ip_address TEXT,
        user_agent TEXT,
        severity TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at 
      ON audit_logs(created_at)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_audit_logs_category 
      ON audit_logs(category)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_audit_logs_severity 
      ON audit_logs(severity)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id 
      ON audit_logs(user_id)
    ''');
  }
}
