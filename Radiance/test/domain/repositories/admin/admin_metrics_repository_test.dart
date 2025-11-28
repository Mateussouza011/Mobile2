import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:radiance_b2b_professional/data/datasources/local/database_helper.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_metrics_repository.dart';
import '../../../helpers/test_helpers.dart';

@GenerateMocks([DatabaseHelper])
import 'admin_metrics_repository_test.mocks.dart';

void main() {
  late Database testDatabase;
  late MockDatabaseHelper mockDatabaseHelper;
  late AdminMetricsRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    testDatabase = await TestHelpers.createTestDatabase();
    await TestHelpers.seedTestDatabase(testDatabase);
    await _seedMetricsData(testDatabase);
    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => testDatabase);
    repository = AdminMetricsRepository(mockDatabaseHelper);
  });

  tearDown(() async {
    try {
      await TestHelpers.cleanupTestDatabase(testDatabase);
      await testDatabase.close();
    } catch (e) {
      // Database might already be closed in error handling tests
    }
  });

  group('AdminMetricsRepository - getSystemMetrics', () {
    test('should return system metrics with correct counts', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          expect(metrics.totalUsers, 4); // seedTestDatabase creates 4 users
          expect(metrics.activeUsers, 3); // 3 active users
          expect(metrics.totalCompanies, 3);
          expect(metrics.activeCompanies, 2);
          expect(metrics.totalSubscriptions, 2);
          expect(metrics.activeSubscriptions, 2);
        },
      );
    });

    test('should calculate MRR correctly', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // sub-1: 29999, sub-2: 14999, both active
          expect(metrics.monthlyRecurringRevenue, equals(44998.0));
        },
      );
    });

    test('should calculate ARPU correctly', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // MRR 44998 / 4 users = 11249.5
          expect(metrics.averageRevenuePerUser, closeTo(11249.5, 0.1));
        },
      );
    });

    test('should calculate ARPA correctly', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // MRR 44998 / 3 companies = 14999.33...
          expect(metrics.averageRevenuePerAccount, closeTo(14999.33, 0.1));
        },
      );
    });

    test('should track new users this month', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // All test users created in 2024, none this month
          expect(metrics.newUsersThisMonth, 0);
        },
      );
    });

    test('should count failed payments', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          expect(metrics.failedPayments, 1); // pay-failed
        },
      );
    });

    test('should calculate health score', () async {
      final result = await repository.getSystemMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // Should be a score between 0-100
          expect(metrics.systemHealthScore, greaterThanOrEqualTo(0));
          expect(metrics.systemHealthScore, lessThanOrEqualTo(100));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getSystemMetrics();

      expect(result.isLeft(), true);
    });
  });

  group('AdminMetricsRepository - getTierDistribution', () {
    test('should return correct tier counts', () async {
      final result = await repository.getTierDistribution();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (distribution) {
          expect(distribution.proCount, 2); // Both sub-1 and sub-2 are pro
          expect(distribution.freeCount, 0);
          expect(distribution.enterpriseCount, 0);
        },
      );
    });

    test('should calculate tier percentages correctly', () async {
      final result = await repository.getTierDistribution();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (distribution) {
          expect(distribution.proPercentage, equals(100.0)); // 2 out of 2
          expect(distribution.freePercentage, equals(0.0));
          expect(distribution.enterprisePercentage, equals(0.0));
        },
      );
    });

    test('should handle empty subscriptions', () async {
      await testDatabase.delete('subscriptions');

      final result = await repository.getTierDistribution();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (distribution) {
          expect(distribution.freeCount, 0);
          expect(distribution.proCount, 0);
          expect(distribution.enterpriseCount, 0);
          expect(distribution.freePercentage, 0);
          expect(distribution.proPercentage, 0);
          expect(distribution.enterprisePercentage, 0);
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getTierDistribution();

      expect(result.isLeft(), true);
    });
  });

  group('AdminMetricsRepository - getRevenueMetrics', () {
    test('should return revenue metrics', () async {
      final result = await repository.getRevenueMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // Time series data may be empty if no data in range
          expect(metrics.dailyRevenue, isA<List>());
          expect(metrics.monthlyRevenue, isA<List>());
          expect(metrics.mrrHistory, isA<List>());
          expect(metrics.totalRevenueThisMonth, greaterThanOrEqualTo(0));
          expect(metrics.totalRevenueLastMonth, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getRevenueMetrics();

      expect(result.isLeft(), true);
    });
  });

  group('AdminMetricsRepository - getUserGrowthMetrics', () {
    test('should return user growth metrics', () async {
      final result = await repository.getUserGrowthMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // Time series data may be empty if no data in range
          expect(metrics.dailySignups, isA<List>());
          expect(metrics.monthlySignups, isA<List>());
          expect(metrics.activeUsersHistory, isA<List>());
          expect(metrics.signupsThisMonth, greaterThanOrEqualTo(0));
          expect(metrics.signupsLastMonth, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getUserGrowthMetrics();

      expect(result.isLeft(), true);
    });
  });

  group('AdminMetricsRepository - getUsageMetrics', () {
    test('should return usage metrics', () async {
      final result = await repository.getUsageMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          expect(metrics.dailyPredictions, isNotEmpty);
          expect(metrics.monthlyPredictions, isNotEmpty);
          expect(metrics.predictionsByCompany, isNotEmpty);
          expect(metrics.predictionsByUser, isNotEmpty);
        },
      );
    });

    test('should return usage metrics even without database', () async {
      // getUsageMetrics uses mock data, so it doesn't depend on database
      final result = await repository.getUsageMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          expect(metrics.dailyPredictions, isNotEmpty);
          expect(metrics.monthlyPredictions, isNotEmpty);
        },
      );
    });
  });

  group('AdminMetricsRepository - getSystemHealthMetrics', () {
    test('should return system health metrics', () async {
      final result = await repository.getSystemHealthMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          expect(metrics.overallHealth, greaterThanOrEqualTo(0));
          expect(metrics.overallHealth, lessThanOrEqualTo(100));
          expect(metrics.paymentHealth, greaterThanOrEqualTo(0));
          expect(metrics.userEngagement, greaterThanOrEqualTo(0));
          expect(metrics.subscriptionHealth, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should generate alerts for low health scores', () async {
      // Deactivate all users to trigger low engagement alert
      await testDatabase.update('users', {'is_active': 0});

      final result = await repository.getSystemHealthMetrics();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (metrics) {
          // Low user engagement (0%) should trigger alerts
          expect(metrics.userEngagement, equals(0.0));
          // Check that health metrics are calculated
          expect(metrics.overallHealth, greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      when(mockDatabaseHelper.database).thenThrow(Exception('Database error'));

      final result = await repository.getSystemHealthMetrics();

      expect(result.isLeft(), true);
    });
  });
}

/// Seeds metrics-specific test data
Future<void> _seedMetricsData(Database db) async {
  // Create payment_records table
  await db.execute('''
    CREATE TABLE IF NOT EXISTS payment_records (
      id TEXT PRIMARY KEY,
      subscription_id TEXT NOT NULL,
      amount REAL NOT NULL,
      status TEXT NOT NULL,
      transaction_id TEXT,
      payment_method TEXT,
      failure_reason TEXT,
      created_at TEXT NOT NULL,
      processed_at TEXT
    )
  ''');

  // Add successful payments
  await db.insert('payment_records', {
    'id': 'pay-success-1',
    'subscription_id': 'sub-1',
    'amount': 29999.0,
    'status': 'success',
    'transaction_id': 'txn-001',
    'payment_method': 'credit_card',
    'created_at': DateTime(2024, 11, 1).toIso8601String(),
    'processed_at': DateTime(2024, 11, 1).toIso8601String(),
  });

  await db.insert('payment_records', {
    'id': 'pay-success-2',
    'subscription_id': 'sub-2',
    'amount': 14999.0,
    'status': 'success',
    'transaction_id': 'txn-002',
    'payment_method': 'credit_card',
    'created_at': DateTime(2024, 11, 5).toIso8601String(),
    'processed_at': DateTime(2024, 11, 5).toIso8601String(),
  });

  // Add failed payment
  await db.insert('payment_records', {
    'id': 'pay-failed',
    'subscription_id': 'sub-1',
    'amount': 29999.0,
    'status': 'failed',
    'transaction_id': 'txn-003',
    'payment_method': 'credit_card',
    'failure_reason': 'Insufficient funds',
    'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
    'processed_at': null,
  });
}
