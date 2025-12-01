import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:radiance_b2b_professional/data/datasources/local/database_helper.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_audit_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_audit_log.dart';

@GenerateMocks([DatabaseHelper])
import 'admin_audit_repository_test.mocks.dart';

void main() {
  late Database testDatabase;
  late MockDatabaseHelper mockDatabaseHelper;
  late AdminAuditRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    testDatabase = await _createAuditLogsTestDatabase();
    await _seedAuditLogsData(testDatabase);
    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => testDatabase);
    repository = AdminAuditRepository(mockDatabaseHelper);
  });

  tearDown(() async {
    try {
      await testDatabase.close();
    } catch (e) {
      // Database might already be closed in error handling tests
    }
  });

  // ==================== getAuditLogs Tests ====================
  group('AdminAuditRepository - getAuditLogs', () {
    test('should return all audit logs when no filters applied', () async {
      final result = await repository.getAuditLogs();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.length, greaterThanOrEqualTo(5));
        },
      );
    });

    test('should return logs filtered by category', () async {
      final filters = const AuditLogFilters(
        category: AuditLogCategory.user,
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.every((log) => log.category == AuditLogCategory.user), true);
        },
      );
    });

    test('should return logs filtered by severity', () async {
      final filters = const AuditLogFilters(
        severity: AuditLogSeverity.critical,
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.every((log) => log.severity == AuditLogSeverity.critical), true);
        },
      );
    });

    test('should return logs filtered by userId', () async {
      final filters = const AuditLogFilters(
        userId: 'user-1',
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.every((log) => log.userId == 'user-1'), true);
        },
      );
    });

    test('should return logs filtered by targetType', () async {
      final filters = const AuditLogFilters(
        targetType: 'company',
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.every((log) => log.targetType == 'company'), true);
        },
      );
    });

    test('should return logs filtered by search query', () async {
      final filters = const AuditLogFilters(
        searchQuery: 'login',
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          for (final log in logs) {
            final matchesSearch = log.action.toLowerCase().contains('login') ||
                (log.userName?.toLowerCase().contains('login') ?? false) ||
                (log.targetName?.toLowerCase().contains('login') ?? false);
            expect(matchesSearch, true);
          }
        },
      );
    });

    test('should return logs filtered by date range', () async {
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 6, 30);
      final filters = AuditLogFilters(
        startDate: startDate,
        endDate: endDate,
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          for (final log in logs) {
            expect(log.createdAt.isAfter(startDate.subtract(const Duration(days: 1))), true);
            expect(log.createdAt.isBefore(endDate.add(const Duration(days: 1))), true);
          }
        },
      );
    });

    test('should respect limit parameter', () async {
      final result = await repository.getAuditLogs(limit: 2);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.length, lessThanOrEqualTo(2));
        },
      );
    });

    test('should respect offset parameter', () async {
      final firstResult = await repository.getAuditLogs(limit: 2, offset: 0);
      final secondResult = await repository.getAuditLogs(limit: 2, offset: 2);

      expect(firstResult.isRight(), true);
      expect(secondResult.isRight(), true);

      firstResult.fold(
        (l) => fail('Should return success'),
        (firstLogs) {
          secondResult.fold(
            (l) => fail('Should return success'),
            (secondLogs) {
              if (secondLogs.isNotEmpty && firstLogs.isNotEmpty) {
                expect(firstLogs.first.id, isNot(equals(secondLogs.first.id)));
              }
            },
          );
        },
      );
    });

    test('should sort logs by createdAt descending by default', () async {
      final result = await repository.getAuditLogs();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          if (logs.length > 1) {
            for (int i = 0; i < logs.length - 1; i++) {
              expect(
                logs[i].createdAt.isAfter(logs[i + 1].createdAt) ||
                    logs[i].createdAt.isAtSameMomentAs(logs[i + 1].createdAt),
                true,
              );
            }
          }
        },
      );
    });

    test('should sort logs ascending when specified', () async {
      final filters = const AuditLogFilters(ascending: true);
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          if (logs.length > 1) {
            for (int i = 0; i < logs.length - 1; i++) {
              expect(
                logs[i].createdAt.isBefore(logs[i + 1].createdAt) ||
                    logs[i].createdAt.isAtSameMomentAs(logs[i + 1].createdAt),
                true,
              );
            }
          }
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getAuditLogs();

      expect(result.isLeft(), true);
    });
  });

  // ==================== getAuditLogById Tests ====================
  group('AdminAuditRepository - getAuditLogById', () {
    test('should return log when id exists', () async {
      final result = await repository.getAuditLogById('audit-1');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (log) {
          expect(log.id, equals('audit-1'));
        },
      );
    });

    test('should return failure when id does not exist', () async {
      final result = await repository.getAuditLogById('non-existent-id');

      expect(result.isLeft(), true);
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getAuditLogById('audit-1');

      expect(result.isLeft(), true);
    });
  });

  // ==================== createAuditLog Tests ====================
  group('AdminAuditRepository - createAuditLog', () {
    test('should create audit log successfully', () async {
      final result = await repository.createAuditLog(
        action: 'test_action',
        category: AuditLogCategory.system,
        userId: 'test-user',
        userName: 'Test User',
      );

      expect(result.isRight(), true);

      // Verify log was created
      final logsResult = await repository.getAuditLogs(
        filters: const AuditLogFilters(searchQuery: 'test_action'),
      );

      expect(logsResult.isRight(), true);
      logsResult.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs.any((log) => log.action == 'test_action'), true);
        },
      );
    });

    test('should create audit log with all fields', () async {
      final metadata = {'key': 'value', 'number': 123};

      final result = await repository.createAuditLog(
        action: 'full_test_action',
        category: AuditLogCategory.security,
        userId: 'full-test-user',
        userName: 'Full Test User',
        targetId: 'target-123',
        targetType: 'user',
        targetName: 'Target User',
        metadata: metadata,
        ipAddress: '192.168.1.1',
        userAgent: 'Mozilla/5.0',
        severity: AuditLogSeverity.warning,
      );

      expect(result.isRight(), true);

      // Verify log was created with correct data
      final logsResult = await repository.getAuditLogs(
        filters: const AuditLogFilters(searchQuery: 'full_test_action'),
      );

      expect(logsResult.isRight(), true);
      logsResult.fold(
        (l) => fail('Should return success'),
        (logs) {
          final log = logs.firstWhere((l) => l.action == 'full_test_action');
          expect(log.category, equals(AuditLogCategory.security));
          expect(log.userId, equals('full-test-user'));
          expect(log.userName, equals('Full Test User'));
          expect(log.targetId, equals('target-123'));
          expect(log.targetType, equals('user'));
          expect(log.targetName, equals('Target User'));
          expect(log.ipAddress, equals('192.168.1.1'));
          expect(log.userAgent, equals('Mozilla/5.0'));
          expect(log.severity, equals(AuditLogSeverity.warning));
          expect(log.metadata, isNotNull);
          expect(log.metadata!['key'], equals('value'));
        },
      );
    });

    test('should create audit log with default severity info', () async {
      final result = await repository.createAuditLog(
        action: 'default_severity_action',
        category: AuditLogCategory.user,
      );

      expect(result.isRight(), true);

      final logsResult = await repository.getAuditLogs(
        filters: const AuditLogFilters(searchQuery: 'default_severity_action'),
      );

      logsResult.fold(
        (l) => fail('Should return success'),
        (logs) {
          final log = logs.firstWhere((l) => l.action == 'default_severity_action');
          expect(log.severity, equals(AuditLogSeverity.info));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.createAuditLog(
        action: 'test',
        category: AuditLogCategory.system,
      );

      expect(result.isLeft(), true);
    });
  });

  // ==================== getAuditLogStats Tests ====================
  group('AdminAuditRepository - getAuditLogStats', () {
    test('should return stats with correct total count', () async {
      final result = await repository.getAuditLogStats();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.totalLogs, greaterThanOrEqualTo(5));
        },
      );
    });

    test('should return stats with severity counts', () async {
      final result = await repository.getAuditLogStats();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.infoCount, greaterThanOrEqualTo(0));
          expect(stats.warningCount, greaterThanOrEqualTo(0));
          expect(stats.criticalCount, greaterThanOrEqualTo(0));
          expect(
            stats.infoCount + stats.warningCount + stats.criticalCount,
            equals(stats.totalLogs),
          );
        },
      );
    });

    test('should return stats with logs by category', () async {
      final result = await repository.getAuditLogStats();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.logsByCategory, isNotEmpty);
        },
      );
    });

    test('should return stats with top users', () async {
      final result = await repository.getAuditLogStats();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.topUsers, isNotEmpty);
        },
      );
    });

    test('should return stats with top actions', () async {
      final result = await repository.getAuditLogStats();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.topActions, isNotEmpty);
        },
      );
    });

    test('should filter stats by date range', () async {
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 3, 31);
      
      final result = await repository.getAuditLogStats(
        startDate: startDate,
        endDate: endDate,
      );

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.totalLogs, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getAuditLogStats();

      expect(result.isLeft(), true);
    });
  });

  // ==================== exportToCSV Tests ====================
  group('AdminAuditRepository - exportToCSV', () {
    test('should export logs to CSV format', () async {
      final result = await repository.exportToCSV();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (csv) {
          expect(csv.contains('ID,Data/Hora,Ação,Categoria,Severidade,Usuário,Alvo,Tipo Alvo,IP,Metadados'), true);
          expect(csv.split('\n').length, greaterThan(1)); // Header + at least one row
        },
      );
    });

    test('should export filtered logs to CSV', () async {
      final filters = const AuditLogFilters(
        category: AuditLogCategory.user,
      );
      final result = await repository.exportToCSV(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (csv) {
          expect(csv.contains('user'), true);
        },
      );
    });

    test('should respect limit when exporting', () async {
      final result = await repository.exportToCSV(limit: 2);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (csv) {
          final lines = csv.split('\n').where((line) => line.isNotEmpty).toList();
          expect(lines.length, lessThanOrEqualTo(3)); // Header + 2 rows
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.exportToCSV();

      expect(result.isLeft(), true);
    });
  });

  // ==================== deleteOldLogs Tests ====================
  group('AdminAuditRepository - deleteOldLogs', () {
    test('should delete logs before specified date', () async {
      final beforeDate = DateTime(2024, 6, 1);
      
      // Count logs before delete
      final countBefore = await repository.countLogs();
      
      final result = await repository.deleteOldLogs(beforeDate);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (deletedCount) {
          expect(deletedCount, greaterThanOrEqualTo(0));
        },
      );

      // Verify logs were deleted
      final countAfter = await repository.countLogs();
      countBefore.fold(
        (l) => {},
        (before) {
          countAfter.fold(
            (l) => {},
            (after) {
              expect(after, lessThanOrEqualTo(before));
            },
          );
        },
      );
    });

    test('should return 0 when no logs match criteria', () async {
      final beforeDate = DateTime(2020, 1, 1); // Very old date
      
      final result = await repository.deleteOldLogs(beforeDate);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (deletedCount) {
          expect(deletedCount, equals(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.deleteOldLogs(DateTime.now());

      expect(result.isLeft(), true);
    });
  });

  // ==================== countLogs Tests ====================
  group('AdminAuditRepository - countLogs', () {
    test('should return total count of logs', () async {
      final result = await repository.countLogs();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (count) {
          expect(count, greaterThanOrEqualTo(5));
        },
      );
    });

    test('should count logs with category filter', () async {
      final filters = const AuditLogFilters(
        category: AuditLogCategory.user,
      );
      final result = await repository.countLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (count) {
          expect(count, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should count logs with severity filter', () async {
      final filters = const AuditLogFilters(
        severity: AuditLogSeverity.warning,
      );
      final result = await repository.countLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (count) {
          expect(count, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should count logs with search query', () async {
      final filters = const AuditLogFilters(
        searchQuery: 'login',
      );
      final result = await repository.countLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (count) {
          expect(count, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should count logs with date range filter', () async {
      final filters = AuditLogFilters(
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
      );
      final result = await repository.countLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (count) {
          expect(count, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.countLogs();

      expect(result.isLeft(), true);
    });
  });

  // ==================== Combined Filters Tests ====================
  group('AdminAuditRepository - Combined Filters', () {
    test('should apply multiple filters correctly', () async {
      final filters = AuditLogFilters(
        category: AuditLogCategory.user,
        severity: AuditLogSeverity.info,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          for (final log in logs) {
            expect(log.category, equals(AuditLogCategory.user));
            expect(log.severity, equals(AuditLogSeverity.info));
          }
        },
      );
    });

    test('should handle empty results gracefully', () async {
      final filters = const AuditLogFilters(
        searchQuery: 'non_existent_query_xyz',
      );
      final result = await repository.getAuditLogs(filters: filters);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (logs) {
          expect(logs, isEmpty);
        },
      );
    });
  });
}

/// Creates a test database for audit logs testing
Future<Database> _createAuditLogsTestDatabase() async {
  return await openDatabase(
    inMemoryDatabasePath,
    version: 1,
    onCreate: (db, version) async {
      // Audit logs table with correct schema for AdminAuditRepository
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
    },
  );
}

/// Seeds audit logs test data
Future<void> _seedAuditLogsData(Database db) async {
  // Insert test audit logs
  await db.insert('audit_logs', {
    'id': 'audit-1',
    'action': 'user_login',
    'category': 'auth',
    'user_id': 'user-1',
    'user_name': 'John Doe',
    'target_id': null,
    'target_type': null,
    'target_name': null,
    'metadata': null,
    'ip_address': '192.168.1.1',
    'user_agent': 'Mozilla/5.0',
    'severity': 'info',
    'created_at': DateTime(2024, 1, 15, 10, 30).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-2',
    'action': 'user_created',
    'category': 'user',
    'user_id': 'user-1',
    'user_name': 'John Doe',
    'target_id': 'user-2',
    'target_type': 'user',
    'target_name': 'Jane Smith',
    'metadata': '{"role": "admin"}',
    'ip_address': '192.168.1.1',
    'user_agent': 'Mozilla/5.0',
    'severity': 'info',
    'created_at': DateTime(2024, 2, 10, 14, 0).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-3',
    'action': 'company_updated',
    'category': 'company',
    'user_id': 'user-2',
    'user_name': 'Jane Smith',
    'target_id': 'company-1',
    'target_type': 'company',
    'target_name': 'Diamond Corp',
    'metadata': '{"field": "name", "old": "Old Name", "new": "Diamond Corp"}',
    'ip_address': '192.168.1.2',
    'user_agent': 'Chrome/120.0',
    'severity': 'warning',
    'created_at': DateTime(2024, 3, 5, 9, 15).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-4',
    'action': 'subscription_cancelled',
    'category': 'subscription',
    'user_id': 'user-1',
    'user_name': 'John Doe',
    'target_id': 'sub-1',
    'target_type': 'subscription',
    'target_name': 'Enterprise Plan',
    'metadata': '{"reason": "Downgrade"}',
    'ip_address': '192.168.1.1',
    'user_agent': 'Mozilla/5.0',
    'severity': 'warning',
    'created_at': DateTime(2024, 4, 20, 16, 45).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-5',
    'action': 'security_breach_attempt',
    'category': 'security',
    'user_id': 'user-unknown',
    'user_name': 'Unknown',
    'target_id': null,
    'target_type': null,
    'target_name': null,
    'metadata': '{"attempts": 5, "blocked": true}',
    'ip_address': '10.0.0.1',
    'user_agent': 'Bot/1.0',
    'severity': 'critical',
    'created_at': DateTime(2024, 5, 1, 3, 0).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-6',
    'action': 'payment_received',
    'category': 'payment',
    'user_id': 'user-2',
    'user_name': 'Jane Smith',
    'target_id': 'payment-1',
    'target_type': 'payment',
    'target_name': 'Invoice #1234',
    'metadata': '{"amount": 299.99, "currency": "BRL"}',
    'ip_address': '192.168.1.2',
    'user_agent': 'Chrome/120.0',
    'severity': 'info',
    'created_at': DateTime(2024, 6, 15, 11, 30).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-7',
    'action': 'system_maintenance',
    'category': 'system',
    'user_id': 'admin-1',
    'user_name': 'System Admin',
    'target_id': null,
    'target_type': null,
    'target_name': null,
    'metadata': '{"type": "scheduled", "duration": "2h"}',
    'ip_address': '127.0.0.1',
    'user_agent': 'System',
    'severity': 'info',
    'created_at': DateTime(2024, 7, 1, 0, 0).toIso8601String(),
  });

  await db.insert('audit_logs', {
    'id': 'audit-8',
    'action': 'user_role_changed',
    'category': 'user',
    'user_id': 'user-1',
    'user_name': 'John Doe',
    'target_id': 'user-3',
    'target_type': 'user',
    'target_name': 'Bob Wilson',
    'metadata': '{"old_role": "member", "new_role": "admin"}',
    'ip_address': '192.168.1.1',
    'user_agent': 'Mozilla/5.0',
    'severity': 'warning',
    'created_at': DateTime(2024, 8, 10, 15, 20).toIso8601String(),
  });
}
