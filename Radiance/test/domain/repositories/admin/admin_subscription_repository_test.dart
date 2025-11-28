import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:radiance_b2b_professional/data/datasources/local/database_helper.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_subscription_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_subscription_stats.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/subscription.dart';
import '../../../helpers/test_helpers.dart';

@GenerateMocks([DatabaseHelper])
import 'admin_subscription_repository_test.mocks.dart';

void main() {
  late Database testDatabase;
  late MockDatabaseHelper mockDatabaseHelper;
  late AdminSubscriptionRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    testDatabase = await TestHelpers.createTestDatabase();
    await TestHelpers.seedTestDatabase(testDatabase);
    // Remove default subscriptions so we can add our own test data
    await testDatabase.delete('subscriptions');
    await _seedSubscriptionData(testDatabase);
    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => testDatabase);
    repository = AdminSubscriptionRepository(mockDatabaseHelper);
  });

  tearDown(() async {
    try {
      await TestHelpers.cleanupTestDatabase(testDatabase);
      await testDatabase.close();
    } catch (e) {
      // Database might already be closed in error handling tests
    }
  });

  group('AdminSubscriptionRepository - getAllSubscriptions', () {
    test('should return all subscriptions without filters', () async {
      final filters = SubscriptionFilters();
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.length, 3);
          expect(subscriptions.any((s) => s.company.name == 'Diamond Corp'), true);
          expect(subscriptions.any((s) => s.company.name == 'Gem Trading Inc'), true);
          expect(subscriptions.any((s) => s.company.name == 'Inactive Company'), true);
        },
      );
    });

    test('should filter subscriptions by company search', () async {
      final filters = SubscriptionFilters(searchQuery: 'Diamond');
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.length, 1);
          expect(subscriptions.first.company.name, 'Diamond Corp');
        },
      );
    });

    test('should filter subscriptions by tier', () async {
      final filters = SubscriptionFilters(tier: SubscriptionTier.pro);
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.length, 1);
          expect(subscriptions.first.subscription.tier, SubscriptionTier.pro);
        },
      );
    });

    test('should filter subscriptions by status', () async {
      final filters = SubscriptionFilters(status: SubscriptionStatus.active);
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.every((s) => s.subscription.status == SubscriptionStatus.active), true);
        },
      );
    });

    test('should filter subscriptions by creation date range', () async {
      final filters = SubscriptionFilters(
        createdAfter: DateTime(2024, 2, 1),
        createdBefore: DateTime(2024, 3, 1),
      );
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.length, 1);
          expect(subscriptions.first.company.name, 'Gem Trading Inc');
        },
      );
    });

    test('should filter overdue subscriptions', () async {
      final filters = SubscriptionFilters(isOverdue: true);
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.every((s) => s.isOverdue), true);
        },
      );
    });

    test('should sort by company name ascending', () async {
      final filters = SubscriptionFilters(
        sortBy: SubscriptionSortBy.companyName,
        ascending: true,
      );
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.first.company.name, 'Diamond Corp');
          expect(subscriptions.last.company.name, 'Inactive Company');
        },
      );
    });

    test('should sort by tier descending', () async {
      final filters = SubscriptionFilters(
        sortBy: SubscriptionSortBy.tier,
        ascending: false,
      );
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.first.subscription.tier, SubscriptionTier.pro);
        },
      );
    });

    test('should combine multiple filters', () async {
      final filters = SubscriptionFilters(
        status: SubscriptionStatus.active,
        tier: SubscriptionTier.pro,
      );
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.length, 1);
          expect(subscriptions.first.subscription.tier, SubscriptionTier.pro);
          expect(subscriptions.first.subscription.status, SubscriptionStatus.active);
        },
      );
    });

    test('should return empty list when no matches', () async {
      final filters = SubscriptionFilters(
        searchQuery: 'NonExistentCompany',
      );
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          expect(subscriptions.isEmpty, true);
        },
      );
    });

    test('should include payment history in stats', () async {
      final filters = SubscriptionFilters();
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          final withPayments = subscriptions.firstWhere(
            (s) => s.company.name == 'Diamond Corp',
          );
          expect(withPayments.paymentHistory.isNotEmpty, true);
          expect(withPayments.totalRevenue, greaterThan(0));
        },
      );
    });

    test('should calculate MRR correctly', () async {
      final filters = SubscriptionFilters();
      
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (subscriptions) {
          final proSub = subscriptions.firstWhere(
            (s) => s.subscription.tier == SubscriptionTier.pro,
          );
          expect(proSub.monthlyRecurringRevenue, equals(proSub.subscription.amount));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final filters = SubscriptionFilters();
      final result = await repository.getAllSubscriptions(filters);
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao buscar assinaturas')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - getSubscriptionDetails', () {
    test('should return subscription details for existing subscription', () async {
      final result = await repository.getSubscriptionDetails('sub-1');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.subscription.id, 'sub-1');
          expect(stats.company.name, 'Diamond Corp');
          expect(stats.subscription.tier, SubscriptionTier.pro);
          expect(stats.subscription.status, SubscriptionStatus.active);
        },
      );
    });

    test('should return failure for non-existent subscription', () async {
      final result = await repository.getSubscriptionDetails('non-existent');
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('não encontrada')),
        (r) => fail('Should return failure'),
      );
    });

    test('should include payment history in details', () async {
      final result = await repository.getSubscriptionDetails('sub-1');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.paymentHistory.isNotEmpty, true);
          expect(stats.totalRevenue, greaterThan(0));
        },
      );
    });

    test('should calculate metrics correctly', () async {
      final result = await repository.getSubscriptionDetails('sub-1');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.monthlyRecurringRevenue, greaterThan(0));
          expect(stats.daysUntilRenewal, isNotNull);
          expect(stats.lastPaymentDate, isNotNull);
        },
      );
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.getSubscriptionDetails('sub-1');
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao buscar detalhes')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - updateSubscriptionTier', () {
    test('should upgrade subscription tier successfully', () async {
      final result = await repository.updateSubscriptionTier(
        'sub-2', 
        SubscriptionTier.pro,
        'admin-1',
        'Customer upgrade request',
      );
      
      expect(result.isRight(), true);
      
      // Verify tier was updated
      final updated = await testDatabase.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: ['sub-2'],
      );
      expect(updated.first['tier'], 'pro');
    });

    test('should downgrade subscription tier successfully', () async {
      final result = await repository.updateSubscriptionTier(
        'sub-1',
        SubscriptionTier.free,
        'admin-1',
        'Customer downgrade',
      );
      
      expect(result.isRight(), true);
      
      // Verify tier was updated
      final updated = await testDatabase.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: ['sub-1'],
      );
      expect(updated.first['tier'], 'free');
    });

    test('should log tier change action', () async {
      await repository.updateSubscriptionTier(
        'sub-1',
        SubscriptionTier.enterprise,
        'admin-1',
        'Enterprise upgrade',
      );
      
      // Verify action was logged
      final actions = await testDatabase.query(
        'subscription_actions',
        where: 'subscription_id = ? AND type = ?',
        whereArgs: ['sub-1', 'upgrade'],
      );
      expect(actions.isNotEmpty, true);
      expect(actions.first['new_tier'], 'enterprise');
      expect(actions.first['reason'], 'Enterprise upgrade');
    });

    test('should return failure for non-existent subscription', () async {
      final result = await repository.updateSubscriptionTier(
        'non-existent',
        SubscriptionTier.pro,
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('não encontrada')),
        (r) => fail('Should return failure'),
      );
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.updateSubscriptionTier(
        'sub-1',
        SubscriptionTier.pro,
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao atualizar')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - cancelSubscription', () {
    test('should cancel active subscription successfully', () async {
      final result = await repository.cancelSubscription(
        'sub-1',
        'admin-1',
        'Customer request',
      );
      
      expect(result.isRight(), true);
      
      // Verify status was updated
      final updated = await testDatabase.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: ['sub-1'],
      );
      expect(updated.first['status'], 'cancelled');
      expect(updated.first['cancelled_at'], isNotNull);
    });

    test('should log cancellation action', () async {
      await repository.cancelSubscription(
        'sub-1',
        'admin-1',
        'Financial issues',
      );
      
      // Verify action was logged
      final actions = await testDatabase.query(
        'subscription_actions',
        where: 'subscription_id = ? AND type = ?',
        whereArgs: ['sub-1', 'cancel'],
      );
      expect(actions.isNotEmpty, true);
      expect(actions.first['reason'], 'Financial issues');
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.cancelSubscription(
        'sub-1',
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao cancelar')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - reactivateSubscription', () {
    test('should reactivate cancelled subscription successfully', () async {
      // First cancel the subscription
      await repository.cancelSubscription('sub-1', 'admin-1', 'Test');
      
      // Then reactivate it
      final result = await repository.reactivateSubscription(
        'sub-1',
        'admin-1',
        'Customer returned',
      );
      
      expect(result.isRight(), true);
      
      // Verify status was updated
      final updated = await testDatabase.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: ['sub-1'],
      );
      expect(updated.first['status'], 'active');
      expect(updated.first['cancelled_at'], isNull);
    });

    test('should log reactivation action', () async {
      await repository.cancelSubscription('sub-1', 'admin-1', 'Test');
      await repository.reactivateSubscription(
        'sub-1',
        'admin-1',
        'Payment received',
      );
      
      // Verify action was logged
      final actions = await testDatabase.query(
        'subscription_actions',
        where: 'subscription_id = ? AND type = ?',
        whereArgs: ['sub-1', 'reactivate'],
      );
      expect(actions.isNotEmpty, true);
      expect(actions.first['reason'], 'Payment received');
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.reactivateSubscription(
        'sub-1',
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao reativar')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - suspendSubscription', () {
    test('should suspend active subscription successfully', () async {
      final result = await repository.suspendSubscription(
        'sub-1',
        'admin-1',
        'Payment overdue',
      );
      
      expect(result.isRight(), true);
      
      // Verify status was updated
      final updated = await testDatabase.query(
        'subscriptions',
        where: 'id = ?',
        whereArgs: ['sub-1'],
      );
      expect(updated.first['status'], 'suspended');
    });

    test('should log suspension action', () async {
      await repository.suspendSubscription(
        'sub-1',
        'admin-1',
        'Fraudulent activity detected',
      );
      
      // Verify action was logged
      final actions = await testDatabase.query(
        'subscription_actions',
        where: 'subscription_id = ? AND type = ?',
        whereArgs: ['sub-1', 'suspend'],
      );
      expect(actions.isNotEmpty, true);
      expect(actions.first['reason'], 'Fraudulent activity detected');
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.suspendSubscription(
        'sub-1',
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao suspender')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - processRefund', () {
    test('should process refund successfully', () async {
      final result = await repository.processRefund(
        'pay-1',
        'admin-1',
        'Duplicate charge',
      );
      
      expect(result.isRight(), true);
      
      // Verify payment status was updated
      final updated = await testDatabase.query(
        'payment_records',
        where: 'id = ?',
        whereArgs: ['pay-1'],
      );
      expect(updated.first['status'], 'refunded');
      expect(updated.first['processed_at'], isNotNull);
    });

    test('should log refund action', () async {
      await repository.processRefund(
        'pay-1',
        'admin-1',
        'Customer complaint',
      );
      
      // Verify action was logged
      final actions = await testDatabase.query(
        'subscription_actions',
        where: 'type = ?',
        whereArgs: ['refund'],
      );
      expect(actions.isNotEmpty, true);
      expect(actions.first['reason'], 'Customer complaint');
    });

    test('should return failure for non-existent payment', () async {
      final result = await repository.processRefund(
        'non-existent',
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('não encontrado')),
        (r) => fail('Should return failure'),
      );
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.processRefund(
        'pay-1',
        'admin-1',
        null,
      );
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao processar')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - getSystemSubscriptionStats', () {
    test('should return system-wide subscription statistics', () async {
      final result = await repository.getSystemSubscriptionStats();
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats['totalSubscriptions'], 3);
          expect(stats['active'], greaterThan(0));
          expect(stats['totalMRR'], greaterThan(0));
        },
      );
    });

    test('should count subscriptions by tier', () async {
      final result = await repository.getSystemSubscriptionStats();
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats['freeTier'], greaterThan(0));
          expect(stats['proTier'], greaterThan(0));
        },
      );
    });

    test('should count subscriptions by status', () async {
      final result = await repository.getSystemSubscriptionStats();
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats['active'], greaterThan(0));
          expect(stats['trial'], greaterThanOrEqualTo(0));
        },
      );
    });

    test('should handle database errors gracefully', () async {
      await testDatabase.close();
      
      final result = await repository.getSystemSubscriptionStats();
      
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Erro ao buscar estatísticas')),
        (r) => fail('Should return failure'),
      );
    });
  });

  group('AdminSubscriptionRepository - Edge Cases', () {
    test('should handle subscription with no payment history', () async {
      final result = await repository.getSubscriptionDetails('sub-3');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.paymentHistory.isEmpty, true);
          expect(stats.totalRevenue, 0);
          expect(stats.lastPaymentDate, isNull);
        },
      );
    });

    test('should handle subscription with past next billing date', () async {
      // Insert subscription with past billing date
      await testDatabase.insert('subscriptions', {
        'id': 'sub-overdue',
        'company_id': 'company-1',
        'tier': 'pro',
        'status': 'past_due',
        'billing_interval': 'monthly',
        'amount': 9900.0,
        'currency': 'BRL',
        'start_date': DateTime(2024, 1, 1).toIso8601String(),
        'current_period_start': DateTime(2024, 1, 1).toIso8601String(),
        'current_period_end': DateTime(2024, 2, 1).toIso8601String(),
        'next_billing_date': DateTime(2024, 1, 15).toIso8601String(),
        'max_predictions_per_month': 100,
        'max_users': 5,
        'created_at': DateTime(2024, 1, 1).toIso8601String(),
        'updated_at': DateTime(2024, 1, 1).toIso8601String(),
      });
      
      final result = await repository.getSubscriptionDetails('sub-overdue');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.isOverdue, true);
          expect(stats.daysUntilRenewal, lessThan(0));
        },
      );
    });

    test('should handle yearly billing interval MRR calculation', () async {
      // Insert yearly subscription
      await testDatabase.insert('subscriptions', {
        'id': 'sub-yearly',
        'company_id': 'company-2',
        'tier': 'enterprise',
        'status': 'active',
        'billing_interval': 'yearly',
        'amount': 120000.0, // R$ 1200/year
        'currency': 'BRL',
        'start_date': DateTime(2024, 1, 1).toIso8601String(),
        'current_period_start': DateTime(2024, 1, 1).toIso8601String(),
        'current_period_end': DateTime(2025, 1, 1).toIso8601String(),
        'next_billing_date': DateTime(2025, 1, 1).toIso8601String(),
        'max_predictions_per_month': -1,
        'max_users': -1,
        'created_at': DateTime(2024, 1, 1).toIso8601String(),
        'updated_at': DateTime(2024, 1, 1).toIso8601String(),
      });
      
      final result = await repository.getSubscriptionDetails('sub-yearly');
      
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return success'),
        (stats) {
          expect(stats.monthlyRecurringRevenue, equals(10000.0)); // 120000 / 12
        },
      );
    });
  });
}

/// Seeds subscription-specific test data
Future<void> _seedSubscriptionData(Database db) async {
  // Subscription 1: Active Pro (Diamond Corp)
  await db.insert('subscriptions', {
    'id': 'sub-1',
    'company_id': 'company-1',
    'tier': 'pro',
    'status': 'active',
    'billing_interval': 'monthly',
    'amount': 9900.0, // R$ 99.00
    'currency': 'BRL',
    'start_date': DateTime(2024, 1, 1).toIso8601String(),
    'current_period_start': DateTime(2024, 1, 1).toIso8601String(),
    'current_period_end': DateTime(2024, 2, 1).toIso8601String(),
    'next_billing_date': DateTime.now().add(const Duration(days: 15)).toIso8601String(),
    'max_predictions_per_month': 100,
    'max_users': 5,
    'has_export_features': 1,
    'has_advanced_analytics': 1,
    'created_at': DateTime(2024, 1, 1).toIso8601String(),
    'updated_at': DateTime(2024, 1, 1).toIso8601String(),
  });

  // Subscription 2: Trial Free (Gem Trading)
  await db.insert('subscriptions', {
    'id': 'sub-2',
    'company_id': 'company-2',
    'tier': 'free',
    'status': 'trialing',
    'billing_interval': 'monthly',
    'amount': 0.0,
    'currency': 'BRL',
    'start_date': DateTime(2024, 2, 1).toIso8601String(),
    'trial_ends_at': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    'current_period_start': DateTime(2024, 2, 1).toIso8601String(),
    'current_period_end': DateTime(2024, 3, 1).toIso8601String(),
    'next_billing_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
    'max_predictions_per_month': 10,
    'max_users': 1,
    'created_at': DateTime(2024, 2, 1).toIso8601String(),
    'updated_at': DateTime(2024, 2, 1).toIso8601String(),
  });

  // Subscription 3: Cancelled (Inactive Company)
  await db.insert('subscriptions', {
    'id': 'sub-3',
    'company_id': 'company-3',
    'tier': 'free',
    'status': 'cancelled',
    'billing_interval': 'monthly',
    'amount': 0.0,
    'currency': 'BRL',
    'start_date': DateTime(2023, 1, 1).toIso8601String(),
    'cancelled_at': DateTime(2023, 6, 1).toIso8601String(),
    'current_period_start': DateTime(2023, 6, 1).toIso8601String(),
    'current_period_end': DateTime(2023, 7, 1).toIso8601String(),
    'max_predictions_per_month': 10,
    'max_users': 1,
    'created_at': DateTime(2023, 1, 1).toIso8601String(),
    'updated_at': DateTime(2023, 6, 1).toIso8601String(),
  });

  // Payment records for sub-1
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
      processed_at TEXT,
      FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE
    )
  ''');

  await db.insert('payment_records', {
    'id': 'pay-1',
    'subscription_id': 'sub-1',
    'amount': 9900.0,
    'status': 'success',
    'transaction_id': 'txn-123',
    'payment_method': 'credit_card',
    'created_at': DateTime(2024, 1, 1).toIso8601String(),
    'processed_at': DateTime(2024, 1, 1).toIso8601String(),
  });

  await db.insert('payment_records', {
    'id': 'pay-2',
    'subscription_id': 'sub-1',
    'amount': 9900.0,
    'status': 'success',
    'transaction_id': 'txn-456',
    'payment_method': 'credit_card',
    'created_at': DateTime(2024, 2, 1).toIso8601String(),
    'processed_at': DateTime(2024, 2, 1).toIso8601String(),
  });

  // Create subscription_actions table
  await db.execute('''
    CREATE TABLE IF NOT EXISTS subscription_actions (
      id TEXT PRIMARY KEY,
      subscription_id TEXT NOT NULL,
      type TEXT NOT NULL,
      new_tier TEXT,
      reason TEXT,
      performed_by TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      FOREIGN KEY (subscription_id) REFERENCES subscriptions (id) ON DELETE CASCADE
    )
  ''');
}
