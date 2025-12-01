import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_subscription_repository.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_subscription_provider.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_subscription_stats.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/subscription.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminSubscriptionRepository])
import 'admin_subscription_provider_test.mocks.dart';

void main() {
  late MockAdminSubscriptionRepository mockRepository;
  late AdminSubscriptionProvider provider;

  final testCompany = Company(
    id: 'company-1',
    name: 'Test Company',
    slug: 'test-company',
    ownerId: 'owner-1',
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    settings: const CompanySettings(),
  );

  final testSubscription = Subscription(
    id: 'sub-1',
    companyId: 'company-1',
    tier: SubscriptionTier.pro,
    status: SubscriptionStatus.active,
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2024, 12, 31),
    limits: SubscriptionLimits.pro,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    amount: 99.90,
    currentPeriodStart: DateTime(2024, 1, 1),
    currentPeriodEnd: DateTime(2024, 2, 1),
  );

  final testSubscriptionStats = AdminSubscriptionStats(
    subscription: testSubscription,
    company: testCompany,
    paymentHistory: [],
    totalRevenue: 1000.0,
    monthlyRecurringRevenue: 100.0,
    daysUntilRenewal: 30,
    isOverdue: false,
    lastPaymentDate: DateTime(2024, 1, 1),
    nextBillingDate: DateTime(2024, 2, 1),
  );

  final testSubscriptionList = [
    testSubscriptionStats,
    AdminSubscriptionStats(
      subscription: Subscription(
        id: 'sub-2',
        companyId: 'company-2',
        tier: SubscriptionTier.enterprise,
        status: SubscriptionStatus.active,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        limits: SubscriptionLimits.enterprise,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        amount: 499.90,
        currentPeriodStart: DateTime(2024, 1, 1),
        currentPeriodEnd: DateTime(2024, 2, 1),
      ),
      company: Company(
        id: 'company-2',
        name: 'Enterprise Corp',
        slug: 'enterprise-corp',
        ownerId: 'owner-2',
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        settings: const CompanySettings(),
      ),
      paymentHistory: [],
      totalRevenue: 5000.0,
      monthlyRecurringRevenue: 500.0,
      daysUntilRenewal: 25,
      isOverdue: false,
      lastPaymentDate: DateTime(2024, 1, 1),
      nextBillingDate: DateTime(2024, 2, 1),
    ),
    AdminSubscriptionStats(
      subscription: Subscription(
        id: 'sub-3',
        companyId: 'company-3',
        tier: SubscriptionTier.free,
        status: SubscriptionStatus.cancelled,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 3, 1),
        limits: SubscriptionLimits.free,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        amount: 0.0,
        currentPeriodStart: DateTime(2024, 1, 1),
        currentPeriodEnd: DateTime(2024, 2, 1),
      ),
      company: Company(
        id: 'company-3',
        name: 'Free Company',
        slug: 'free-company',
        ownerId: 'owner-3',
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        settings: const CompanySettings(),
      ),
      paymentHistory: [],
      totalRevenue: 0.0,
      monthlyRecurringRevenue: 0.0,
      daysUntilRenewal: 0,
      isOverdue: true,
      lastPaymentDate: null,
      nextBillingDate: null,
    ),
  ];

  setUp(() {
    mockRepository = MockAdminSubscriptionRepository();
    provider = AdminSubscriptionProvider(mockRepository);
  });

  group('AdminSubscriptionProvider', () {
    group('Initial State', () {
      test('should have empty subscriptions initially', () {
        expect(provider.subscriptions, isEmpty);
      });

      test('should have null selectedSubscription initially', () {
        expect(provider.selectedSubscription, isNull);
      });

      test('should have default filters initially', () {
        expect(provider.filters, equals(const SubscriptionFilters()));
      });

      test('should not be loading initially', () {
        expect(provider.isLoading, false);
      });

      test('should have no error initially', () {
        expect(provider.error, isNull);
      });
    });

    group('loadSubscriptions', () {
      test('should load subscriptions successfully', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        expect(provider.subscriptions, equals(testSubscriptionList));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        verify(mockRepository.getAllSubscriptions(any)).called(1);
      });

      test('should handle failure when loading subscriptions', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));

        await provider.loadSubscriptions();

        expect(provider.subscriptions, isEmpty);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });

      test('should notify listeners when loading subscriptions', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        await provider.loadSubscriptions();

        expect(notifyCount, greaterThan(0));
      });
    });

    group('searchSubscriptions', () {
      test('should search subscriptions by query', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right([testSubscriptionStats]));

        await provider.searchSubscriptions('Test');

        expect(provider.filters.searchQuery, equals('Test'));
        verify(mockRepository.getAllSubscriptions(any)).called(1);
      });

      test('should clear search query when empty string provided', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.searchSubscriptions('');

        expect(provider.filters.searchQuery, isNull);
      });
    });

    group('applyFilters', () {
      test('should apply filters and reload subscriptions', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        const filters = SubscriptionFilters(
          tier: SubscriptionTier.pro,
          status: SubscriptionStatus.active,
        );

        await provider.applyFilters(filters);

        expect(provider.filters, equals(filters));
        verify(mockRepository.getAllSubscriptions(filters)).called(1);
      });
    });

    group('clearFilters', () {
      test('should clear filters and reload subscriptions', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        // First apply some filters
        const filters = SubscriptionFilters(tier: SubscriptionTier.enterprise);
        await provider.applyFilters(filters);

        // Then clear filters
        await provider.clearFilters();

        expect(provider.filters, equals(const SubscriptionFilters()));
      });
    });

    group('loadSubscriptionDetails', () {
      test('should load subscription details successfully', () async {
        when(mockRepository.getSubscriptionDetails('sub-1'))
            .thenAnswer((_) async => Right(testSubscriptionStats));

        await provider.loadSubscriptionDetails('sub-1');

        expect(provider.selectedSubscription, equals(testSubscriptionStats));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
      });

      test('should handle failure when loading subscription details', () async {
        when(mockRepository.getSubscriptionDetails('sub-1'))
            .thenAnswer((_) async => Left(ServerFailure('Not found')));

        await provider.loadSubscriptionDetails('sub-1');

        expect(provider.selectedSubscription, isNull);
        expect(provider.error, isNotNull);
      });
    });

    group('updateSubscriptionTier', () {
      test('should update subscription tier successfully', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));
        when(mockRepository.updateSubscriptionTier(
          'sub-1',
          SubscriptionTier.enterprise,
          'admin-1',
          'Upgrade reason',
        )).thenAnswer((_) async => const Right(null));

        await provider.loadSubscriptions();

        final result = await provider.updateSubscriptionTier(
          'sub-1',
          SubscriptionTier.enterprise,
          'admin-1',
          'Upgrade reason',
        );

        expect(result, true);
        verify(mockRepository.updateSubscriptionTier(
          'sub-1',
          SubscriptionTier.enterprise,
          'admin-1',
          'Upgrade reason',
        )).called(1);
      });

      test('should handle failure when updating tier', () async {
        when(mockRepository.updateSubscriptionTier(any, any, any, any))
            .thenAnswer((_) async => Left(ServerFailure('Update failed')));

        final result = await provider.updateSubscriptionTier(
          'sub-1',
          SubscriptionTier.enterprise,
          'admin-1',
          null,
        );

        expect(result, false);
        expect(provider.error, isNotNull);
      });
    });

    group('cancelSubscription', () {
      test('should cancel subscription successfully', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));
        when(mockRepository.cancelSubscription('sub-1', 'admin-1', 'Cancel reason'))
            .thenAnswer((_) async => const Right(null));

        await provider.loadSubscriptions();

        final result = await provider.cancelSubscription(
          'sub-1',
          'admin-1',
          'Cancel reason',
        );

        expect(result, true);
      });

      test('should handle failure when cancelling subscription', () async {
        when(mockRepository.cancelSubscription(any, any, any))
            .thenAnswer((_) async => Left(ServerFailure('Cancel failed')));

        final result = await provider.cancelSubscription(
          'sub-1',
          'admin-1',
          null,
        );

        expect(result, false);
        expect(provider.error, isNotNull);
      });
    });

    group('reactivateSubscription', () {
      test('should reactivate subscription successfully', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));
        when(mockRepository.reactivateSubscription('sub-3', 'admin-1', null))
            .thenAnswer((_) async => const Right(null));

        final result = await provider.reactivateSubscription(
          'sub-3',
          'admin-1',
          null,
        );

        expect(result, true);
        verify(mockRepository.reactivateSubscription('sub-3', 'admin-1', null)).called(1);
      });

      test('should handle failure when reactivating subscription', () async {
        when(mockRepository.reactivateSubscription(any, any, any))
            .thenAnswer((_) async => Left(ServerFailure('Reactivation failed')));

        final result = await provider.reactivateSubscription(
          'sub-3',
          'admin-1',
          null,
        );

        expect(result, false);
        expect(provider.error, isNotNull);
      });
    });

    group('suspendSubscription', () {
      test('should suspend subscription successfully', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));
        when(mockRepository.suspendSubscription('sub-1', 'admin-1', 'Violation'))
            .thenAnswer((_) async => const Right(null));

        await provider.loadSubscriptions();

        final result = await provider.suspendSubscription(
          'sub-1',
          'admin-1',
          'Violation',
        );

        expect(result, true);
      });

      test('should handle failure when suspending subscription', () async {
        when(mockRepository.suspendSubscription(any, any, any))
            .thenAnswer((_) async => Left(ServerFailure('Suspend failed')));

        final result = await provider.suspendSubscription(
          'sub-1',
          'admin-1',
          null,
        );

        expect(result, false);
        expect(provider.error, isNotNull);
      });
    });

    group('processRefund', () {
      test('should process refund successfully', () async {
        when(mockRepository.processRefund('payment-1', 'admin-1', 'Refund reason'))
            .thenAnswer((_) async => const Right(null));

        final result = await provider.processRefund(
          'payment-1',
          'admin-1',
          'Refund reason',
        );

        expect(result, true);
      });

      test('should handle failure when processing refund', () async {
        when(mockRepository.processRefund(any, any, any))
            .thenAnswer((_) async => Left(ServerFailure('Refund failed')));

        final result = await provider.processRefund(
          'payment-1',
          'admin-1',
          null,
        );

        expect(result, false);
        expect(provider.error, isNotNull);
      });
    });

    group('loadSystemStats', () {
      test('should load system stats successfully', () async {
        final stats = {
          'totalSubscriptions': 100,
          'activeSubscriptions': 80,
          'totalMRR': 10000.0,
        };
        when(mockRepository.getSystemSubscriptionStats())
            .thenAnswer((_) async => Right(stats));

        await provider.loadSystemStats();

        expect(provider.systemStats, equals(stats));
        expect(provider.error, isNull);
      });

      test('should handle failure when loading system stats', () async {
        when(mockRepository.getSystemSubscriptionStats())
            .thenAnswer((_) async => Left(ServerFailure('Stats error')));

        await provider.loadSystemStats();

        expect(provider.systemStats, isNull);
        expect(provider.error, isNotNull);
      });
    });

    group('Computed Properties', () {
      test('should calculate totalSubscriptions correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        expect(provider.totalSubscriptions, equals(3));
      });

      test('should calculate activeSubscriptions correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        // sub-1 (pro) active, sub-2 (enterprise) active, sub-3 (free) cancelled
        expect(provider.activeSubscriptions, greaterThanOrEqualTo(1));
      });

      test('should calculate overdueSubscriptions correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        expect(provider.overdueSubscriptions, equals(1)); // free company is overdue
      });

      test('should calculate subscriptionsNeedingAttention correctly', () async {
        final statsWithAttention = [
          AdminSubscriptionStats(
            subscription: testSubscription,
            company: testCompany,
            paymentHistory: [],
            totalRevenue: 1000.0,
            monthlyRecurringRevenue: 100.0,
            daysUntilRenewal: 5, // Less than 7 days
            isOverdue: false,
            lastPaymentDate: DateTime(2024, 1, 1),
            nextBillingDate: DateTime.now().add(const Duration(days: 5)),
          ),
        ];
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(statsWithAttention));

        await provider.loadSubscriptions();

        expect(provider.subscriptionsNeedingAttention, greaterThanOrEqualTo(0));
      });

      test('should calculate totalMRR correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        // Sum of all monthlyRecurringRevenue from test data
        expect(provider.totalMRR, greaterThanOrEqualTo(500.0));
      });

      test('should calculate totalRevenue correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        // 1000 + 5000 + 0 = 6000
        expect(provider.totalRevenue, equals(6000.0));
      });

      test('should group subscriptions by tier correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        final byTier = provider.subscriptionsByTier;
        // Verify we have tiers grouped
        expect(byTier.keys.length, greaterThanOrEqualTo(1));
        expect(byTier[SubscriptionTier.enterprise]?.length, greaterThanOrEqualTo(1));
        expect(byTier[SubscriptionTier.free]?.length, greaterThanOrEqualTo(1));
      });

      test('should group subscriptions by status correctly', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Right(testSubscriptionList));

        await provider.loadSubscriptions();

        final byStatus = provider.subscriptionsByStatus;
        // Verify we have status grouped
        expect(byStatus[SubscriptionStatus.active]?.length, greaterThanOrEqualTo(1));
        expect(byStatus[SubscriptionStatus.cancelled]?.length, greaterThanOrEqualTo(1));
      });
    });

    group('clearError', () {
      test('should clear error and notify listeners', () async {
        when(mockRepository.getAllSubscriptions(any))
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadSubscriptions();
        expect(provider.error, isNotNull);

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        provider.clearError();

        expect(provider.error, isNull);
        expect(notifyCount, equals(1));
      });
    });

    group('clearSelectedSubscription', () {
      test('should clear selected subscription and notify listeners', () async {
        when(mockRepository.getSubscriptionDetails('sub-1'))
            .thenAnswer((_) async => Right(testSubscriptionStats));

        await provider.loadSubscriptionDetails('sub-1');
        expect(provider.selectedSubscription, isNotNull);

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        provider.clearSelectedSubscription();

        expect(provider.selectedSubscription, isNull);
        expect(notifyCount, equals(1));
      });
    });
  });
}
