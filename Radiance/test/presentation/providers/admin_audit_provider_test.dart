import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_audit_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_audit_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_audit_log.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminAuditRepository])
import 'admin_audit_provider_test.mocks.dart';

void main() {
  late AdminAuditProvider provider;
  late MockAdminAuditRepository mockRepository;

  setUp(() {
    mockRepository = MockAdminAuditRepository();
    provider = AdminAuditProvider(mockRepository);
  });

  // Helper to create test audit log
  AdminAuditLog createTestAuditLog({
    String id = 'audit-1',
    String action = 'test_action',
    AuditLogCategory category = AuditLogCategory.system,
    AuditLogSeverity severity = AuditLogSeverity.info,
  }) {
    return AdminAuditLog(
      id: id,
      action: action,
      category: category,
      userId: 'user-1',
      userName: 'Test User',
      targetId: 'target-1',
      targetType: 'user',
      targetName: 'Target User',
      metadata: {'key': 'value'},
      ipAddress: '192.168.1.1',
      userAgent: 'Mozilla/5.0',
      severity: severity,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  // Helper to create test stats
  AuditLogStats createTestStats() {
    return const AuditLogStats(
      totalLogs: 100,
      infoCount: 70,
      warningCount: 25,
      criticalCount: 5,
      logsByCategory: {
        AuditLogCategory.user: 30,
        AuditLogCategory.system: 40,
        AuditLogCategory.security: 30,
      },
      topUsers: {
        'John Doe': 25,
        'Jane Smith': 20,
      },
      topActions: {
        'login': 30,
        'update': 25,
      },
    );
  }

  group('AdminAuditProvider - Initial State', () {
    test('should have empty logs list initially', () {
      expect(provider.logs, isEmpty);
    });

    test('should not be loading initially', () {
      expect(provider.isLoading, false);
    });

    test('should have no error initially', () {
      expect(provider.error, isNull);
    });

    test('should have no selected log initially', () {
      expect(provider.selectedLog, isNull);
    });

    test('should have default filters initially', () {
      expect(provider.filters, equals(const AuditLogFilters()));
    });

    test('should have hasMoreLogs as true initially', () {
      expect(provider.hasMoreLogs, true);
    });
  });

  group('AdminAuditProvider - loadLogs', () {
    test('should load logs successfully', () async {
      final testLogs = [
        createTestAuditLog(id: 'audit-1'),
        createTestAuditLog(id: 'audit-2'),
      ];

      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(testLogs));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(2));

      await provider.loadLogs();

      expect(provider.logs.length, 2);
      expect(provider.error, isNull);
      expect(provider.isLoading, false);
    });

    test('should set loading state during load', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right([createTestAuditLog()]);
      });

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(1));

      final future = provider.loadLogs();
      expect(provider.isLoading, true);

      await future;
      expect(provider.isLoading, false);
    });

    test('should handle error when loading logs', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Left(DatabaseFailure('Database error')));

      await provider.loadLogs();

      expect(provider.error, isNotNull);
    });

    test('should reset logs when reset is true', () async {
      final firstLogs = [createTestAuditLog(id: 'audit-1')];
      final secondLogs = [createTestAuditLog(id: 'audit-2')];

      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(firstLogs));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(1));

      await provider.loadLogs();
      expect(provider.logs.length, 1);
      expect(provider.logs.first.id, 'audit-1');

      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right(secondLogs));

      await provider.loadLogs(reset: true);
      expect(provider.logs.length, 1);
      expect(provider.logs.first.id, 'audit-2');
    });

    test('should notify listeners when logs are loaded', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([createTestAuditLog()]));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(1));

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.loadLogs();

      expect(notificationCount, greaterThanOrEqualTo(2));
    });
  });

  group('AdminAuditProvider - searchLogs', () {
    test('should update search query and reload', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([]));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(0));

      await provider.searchLogs('test query');

      expect(provider.filters.searchQuery, equals('test query'));
    });
  });

  group('AdminAuditProvider - applyFilters', () {
    test('should apply filters and reload logs', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([]));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(0));

      const filters = AuditLogFilters(
        category: AuditLogCategory.security,
        severity: AuditLogSeverity.critical,
      );

      await provider.applyFilters(filters);

      expect(provider.filters, equals(filters));
    });
  });

  group('AdminAuditProvider - clearFilters', () {
    test('should clear filters and reload logs', () async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([]));

      when(mockRepository.countLogs(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(0));

      await provider.applyFilters(const AuditLogFilters(
        category: AuditLogCategory.security,
      ));
      await provider.clearFilters();

      expect(provider.filters, equals(const AuditLogFilters()));
    });
  });

  group('AdminAuditProvider - loadLogDetails', () {
    test('should load log details successfully', () async {
      final testLog = createTestAuditLog();

      when(mockRepository.getAuditLogById(any))
          .thenAnswer((_) async => Right(testLog));

      await provider.loadLogDetails('audit-1');

      expect(provider.selectedLog, isNotNull);
      expect(provider.selectedLog!.id, equals('audit-1'));
      expect(provider.error, isNull);
    });

    test('should handle error when loading log details', () async {
      when(mockRepository.getAuditLogById(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Not found')));

      await provider.loadLogDetails('invalid-id');

      expect(provider.error, isNotNull);
    });
  });

  group('AdminAuditProvider - loadStats', () {
    test('should load stats successfully', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.stats, isNotNull);
      expect(provider.stats!.totalLogs, 100);
      expect(provider.infoCount, 70);
      expect(provider.warningCount, 25);
      expect(provider.criticalCount, 5);
    });

    test('should load stats with date range', () async {
      final testStats = createTestStats();
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats(startDate: startDate, endDate: endDate);

      expect(provider.stats, isNotNull);
    });

    test('should handle error when loading stats', () async {
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Left(DatabaseFailure('Stats error')));

      await provider.loadStats();

      expect(provider.error, isNotNull);
    });
  });

  group('AdminAuditProvider - exportToCSV', () {
    test('should export to CSV successfully', () async {
      const csvContent = 'ID,Action,Category\naudit-1,login,auth';

      when(mockRepository.exportToCSV(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(csvContent));

      final result = await provider.exportToCSV();

      expect(result, isNotNull);
      expect(result, contains('ID,Action,Category'));
    });

    test('should handle error when exporting to CSV', () async {
      when(mockRepository.exportToCSV(filters: anyNamed('filters')))
          .thenAnswer((_) async => Left(DatabaseFailure('Export error')));

      final result = await provider.exportToCSV();

      expect(result, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminAuditProvider - deleteOldLogs', () {
    test('should delete old logs successfully', () async {
      when(mockRepository.deleteOldLogs(any))
          .thenAnswer((_) async => const Right(10));

      final result = await provider.deleteOldLogs(DateTime(2024, 1, 1));

      expect(result, 10);
    });

    test('should handle error when deleting old logs', () async {
      when(mockRepository.deleteOldLogs(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Delete error')));

      final result = await provider.deleteOldLogs(DateTime(2024, 1, 1));

      expect(result, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminAuditProvider - Computed Properties', () {
    test('should return correct infoCount', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.infoCount, 70);
    });

    test('should return correct warningCount', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.warningCount, 25);
    });

    test('should return correct criticalCount', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.criticalCount, 5);
    });

    test('should return correct logsByCategory', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.logsByCategory.length, 3);
      expect(provider.logsByCategory[AuditLogCategory.user], 30);
    });

    test('should return correct topUsers', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.topUsers.length, 2);
      expect(provider.topUsers['John Doe'], 25);
    });

    test('should return correct topActions', () async {
      final testStats = createTestStats();

      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await provider.loadStats();

      expect(provider.topActions.length, 2);
      expect(provider.topActions['login'], 30);
    });
  });
}
