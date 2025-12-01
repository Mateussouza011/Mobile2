import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_metrics_repository.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_metrics_provider.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_metrics_stats.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminMetricsRepository])
import 'admin_metrics_provider_test.mocks.dart';

void main() {
  late MockAdminMetricsRepository mockRepository;
  late AdminMetricsProvider provider;

  final testSystemMetrics = SystemMetrics(
    totalUsers: 1000,
    activeUsers: 800,
    totalCompanies: 100,
    activeCompanies: 80,
    totalSubscriptions: 90,
    activeSubscriptions: 75,
    totalRevenue: 100000.0,
    monthlyRecurringRevenue: 10000.0,
    averageRevenuePerUser: 100.0,
    averageRevenuePerAccount: 1000.0,
    newUsersThisMonth: 50,
    newCompaniesThisMonth: 10,
    growthRate: 5.0,
    churnRate: 2.0,
    totalPredictions: 50000,
    predictionsThisMonth: 5000,
    averagePredictionsPerUser: 50,
    totalApiCalls: 100000,
    apiCallsThisMonth: 10000,
    apiSuccessRate: 99.5,
    systemHealthScore: 95.0,
    failedPayments: 5,
    overdueSubscriptions: 3,
    calculatedAt: DateTime(2024, 1, 15),
  );

  final testRevenueMetrics = RevenueMetrics(
    dailyRevenue: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 300.0),
      TimeSeriesData(date: DateTime(2024, 1, 2), value: 350.0),
    ],
    monthlyRevenue: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 10000.0),
    ],
    mrrHistory: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 9500.0),
    ],
    totalRevenueLastMonth: 9000.0,
    totalRevenueThisMonth: 10000.0,
    revenueGrowthRate: 11.1,
  );

  final testUserGrowthMetrics = UserGrowthMetrics(
    dailySignups: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 10),
      TimeSeriesData(date: DateTime(2024, 1, 2), value: 15),
    ],
    monthlySignups: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 200),
    ],
    activeUsersHistory: [
      TimeSeriesData(date: DateTime(2024, 1, 1), value: 750),
    ],
    signupsLastMonth: 180,
    signupsThisMonth: 200,
    signupGrowthRate: 11.1,
  );

  const testTierDistribution = TierDistribution(
    freeCount: 50,
    proCount: 35,
    enterpriseCount: 15,
    freePercentage: 50.0,
    proPercentage: 35.0,
    enterprisePercentage: 15.0,
  );

  const testUsageMetrics = UsageMetrics(
    dailyPredictions: [],
    monthlyPredictions: [],
    predictionsLastMonth: 4500,
    predictionsThisMonth: 5000,
    predictionsGrowthRate: 11.1,
    predictionsByCompany: {'company-1': 1000, 'company-2': 800},
    predictionsByUser: {'user-1': 500, 'user-2': 400},
  );

  final testHealthMetrics = SystemHealthMetrics(
    overallHealth: 95.0,
    paymentHealth: 98.0,
    userEngagement: 80.0,
    subscriptionHealth: 95.0,
    apiHealth: 99.5,
    criticalIssues: 1,
    warnings: 3,
    alerts: [
      HealthAlert(
        id: 'alert-1',
        type: HealthAlertType.payment,
        severity: HealthAlertSeverity.warning,
        message: '5 failed payments this month',
        createdAt: DateTime(2024, 1, 15),
      ),
    ],
  );

  setUp(() {
    mockRepository = MockAdminMetricsRepository();
    provider = AdminMetricsProvider(mockRepository);
  });

  group('AdminMetricsProvider', () {
    group('Initial State', () {
      test('should have null systemMetrics initially', () {
        expect(provider.systemMetrics, isNull);
      });

      test('should have null revenueMetrics initially', () {
        expect(provider.revenueMetrics, isNull);
      });

      test('should have null userGrowthMetrics initially', () {
        expect(provider.userGrowthMetrics, isNull);
      });

      test('should have null tierDistribution initially', () {
        expect(provider.tierDistribution, isNull);
      });

      test('should have null usageMetrics initially', () {
        expect(provider.usageMetrics, isNull);
      });

      test('should have null healthMetrics initially', () {
        expect(provider.healthMetrics, isNull);
      });

      test('should not be loading initially', () {
        expect(provider.isLoading, false);
      });

      test('should have no error initially', () {
        expect(provider.error, isNull);
      });

      test('should have null lastUpdated initially', () {
        expect(provider.lastUpdated, isNull);
      });

      test('hasData should be false initially', () {
        expect(provider.hasData, false);
      });
    });

    group('Computed Getters - Default Values', () {
      test('totalUsers should return 0 when no metrics', () {
        expect(provider.totalUsers, equals(0));
      });

      test('activeUsers should return 0 when no metrics', () {
        expect(provider.activeUsers, equals(0));
      });

      test('totalCompanies should return 0 when no metrics', () {
        expect(provider.totalCompanies, equals(0));
      });

      test('totalRevenue should return 0 when no metrics', () {
        expect(provider.totalRevenue, equals(0.0));
      });

      test('mrr should return 0 when no metrics', () {
        expect(provider.mrr, equals(0.0));
      });

      test('arpu should return 0 when no metrics', () {
        expect(provider.arpu, equals(0.0));
      });

      test('healthScore should return 0 when no metrics', () {
        expect(provider.healthScore, equals(0.0));
      });

      test('criticalAlerts should return 0 when no health metrics', () {
        expect(provider.criticalAlerts, equals(0));
      });

      test('warnings should return 0 when no health metrics', () {
        expect(provider.warnings, equals(0));
      });

      test('revenueGrowth should return 0 when no revenue metrics', () {
        expect(provider.revenueGrowth, equals(0.0));
      });

      test('userGrowth should return 0 when no user growth metrics', () {
        expect(provider.userGrowth, equals(0.0));
      });

      test('usageGrowth should return 0 when no usage metrics', () {
        expect(provider.usageGrowth, equals(0.0));
      });
    });

    group('loadAllMetrics', () {
      test('should load all metrics successfully', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        await provider.loadAllMetrics();

        expect(provider.systemMetrics, equals(testSystemMetrics));
        expect(provider.revenueMetrics, equals(testRevenueMetrics));
        expect(provider.userGrowthMetrics, equals(testUserGrowthMetrics));
        expect(provider.tierDistribution, equals(testTierDistribution));
        expect(provider.usageMetrics, equals(testUsageMetrics));
        expect(provider.healthMetrics, equals(testHealthMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
        expect(provider.hasData, true);
      });

      test('should set error on failure', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Left(ServerFailure('System metrics error')));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        await provider.loadAllMetrics();

        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });

      test('should notify listeners', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        await provider.loadAllMetrics();

        expect(notifyCount, greaterThan(0));
      });
    });

    group('loadSystemMetrics', () {
      test('should load system metrics successfully', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));

        await provider.loadSystemMetrics();

        expect(provider.systemMetrics, equals(testSystemMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadSystemMetrics();

        expect(provider.systemMetrics, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('loadRevenueMetrics', () {
      test('should load revenue metrics successfully', () async {
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));

        await provider.loadRevenueMetrics();

        expect(provider.revenueMetrics, equals(testRevenueMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadRevenueMetrics();

        expect(provider.revenueMetrics, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('loadUserGrowthMetrics', () {
      test('should load user growth metrics successfully', () async {
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));

        await provider.loadUserGrowthMetrics();

        expect(provider.userGrowthMetrics, equals(testUserGrowthMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadUserGrowthMetrics();

        expect(provider.userGrowthMetrics, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('loadTierDistribution', () {
      test('should load tier distribution successfully', () async {
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));

        await provider.loadTierDistribution();

        expect(provider.tierDistribution, equals(testTierDistribution));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadTierDistribution();

        expect(provider.tierDistribution, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('loadUsageMetrics', () {
      test('should load usage metrics successfully', () async {
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));

        await provider.loadUsageMetrics();

        expect(provider.usageMetrics, equals(testUsageMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadUsageMetrics();

        expect(provider.usageMetrics, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('loadHealthMetrics', () {
      test('should load health metrics successfully', () async {
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        await provider.loadHealthMetrics();

        expect(provider.healthMetrics, equals(testHealthMetrics));
        expect(provider.isLoading, false);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNotNull);
      });

      test('should handle failure', () async {
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadHealthMetrics();

        expect(provider.healthMetrics, isNull);
        expect(provider.error, isNotNull);
        expect(provider.isLoading, false);
      });
    });

    group('Computed Getters - With Data', () {
      setUp(() async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));
      });

      test('should return correct totalUsers', () async {
        await provider.loadAllMetrics();
        expect(provider.totalUsers, equals(1000));
      });

      test('should return correct activeUsers', () async {
        await provider.loadAllMetrics();
        expect(provider.activeUsers, equals(800));
      });

      test('should return correct totalCompanies', () async {
        await provider.loadAllMetrics();
        expect(provider.totalCompanies, equals(100));
      });

      test('should return correct totalRevenue', () async {
        await provider.loadAllMetrics();
        expect(provider.totalRevenue, equals(100000.0));
      });

      test('should return correct mrr', () async {
        await provider.loadAllMetrics();
        expect(provider.mrr, equals(10000.0));
      });

      test('should return correct arpu', () async {
        await provider.loadAllMetrics();
        expect(provider.arpu, equals(100.0));
      });

      test('should return correct healthScore', () async {
        await provider.loadAllMetrics();
        expect(provider.healthScore, equals(95.0));
      });

      test('should return correct criticalAlerts', () async {
        await provider.loadAllMetrics();
        expect(provider.criticalAlerts, equals(1));
      });

      test('should return correct warnings', () async {
        await provider.loadAllMetrics();
        expect(provider.warnings, equals(3));
      });

      test('should return correct revenueGrowth', () async {
        await provider.loadAllMetrics();
        expect(provider.revenueGrowth, equals(11.1));
      });

      test('should return correct userGrowth', () async {
        await provider.loadAllMetrics();
        expect(provider.userGrowth, equals(11.1));
      });

      test('should return correct usageGrowth', () async {
        await provider.loadAllMetrics();
        expect(provider.usageGrowth, equals(11.1));
      });
    });

    group('refresh', () {
      test('should reload all metrics', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        await provider.refresh();

        expect(provider.hasData, true);
        verify(mockRepository.getSystemMetrics()).called(1);
        verify(mockRepository.getRevenueMetrics()).called(1);
        verify(mockRepository.getUserGrowthMetrics()).called(1);
        verify(mockRepository.getTierDistribution()).called(1);
        verify(mockRepository.getUsageMetrics()).called(1);
        verify(mockRepository.getSystemHealthMetrics()).called(1);
      });
    });

    group('clearError', () {
      test('should clear error and notify listeners', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Left(ServerFailure('Error')));

        await provider.loadSystemMetrics();
        expect(provider.error, isNotNull);

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        provider.clearError();

        expect(provider.error, isNull);
        expect(notifyCount, equals(1));
      });
    });

    group('clear', () {
      test('should clear all data and notify listeners', () async {
        when(mockRepository.getSystemMetrics())
            .thenAnswer((_) async => Right(testSystemMetrics));
        when(mockRepository.getRevenueMetrics())
            .thenAnswer((_) async => Right(testRevenueMetrics));
        when(mockRepository.getUserGrowthMetrics())
            .thenAnswer((_) async => Right(testUserGrowthMetrics));
        when(mockRepository.getTierDistribution())
            .thenAnswer((_) async => Right(testTierDistribution));
        when(mockRepository.getUsageMetrics())
            .thenAnswer((_) async => Right(testUsageMetrics));
        when(mockRepository.getSystemHealthMetrics())
            .thenAnswer((_) async => Right(testHealthMetrics));

        await provider.loadAllMetrics();
        expect(provider.hasData, true);

        int notifyCount = 0;
        provider.addListener(() => notifyCount++);

        provider.clear();

        expect(provider.systemMetrics, isNull);
        expect(provider.revenueMetrics, isNull);
        expect(provider.userGrowthMetrics, isNull);
        expect(provider.tierDistribution, isNull);
        expect(provider.usageMetrics, isNull);
        expect(provider.healthMetrics, isNull);
        expect(provider.error, isNull);
        expect(provider.lastUpdated, isNull);
        expect(provider.hasData, false);
        expect(notifyCount, equals(1));
      });
    });
  });
}
