import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_metrics_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_metrics_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_metrics_stats.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminMetricsRepository])
import 'admin_dashboard_page_test.mocks.dart';

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
    predictionsByCompany: {'company-1': 1000},
    predictionsByUser: {'user-1': 500},
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

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AdminMetricsProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  setUp(() {
    mockRepository = MockAdminMetricsRepository();
    provider = AdminMetricsProvider(mockRepository);
  });

  group('AdminDashboardPage', () {
    testWidgets('should display loading indicator initially', (tester) async {
      // Use a Completer to control when the future completes
      final completer = Completer<Either<Failure, SystemMetrics>>();
      
      when(mockRepository.getSystemMetrics())
          .thenAnswer((_) => completer.future);
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Complete the future to avoid pending timers
      completer.complete(Right(testSystemMetrics));
      await tester.pumpAndSettle();
    });

    testWidgets('should display AppBar with correct title', (tester) async {
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard do Sistema'), findsOneWidget);
    });

    testWidgets('should display tabs', (tester) async {
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      expect(find.text('Visão Geral'), findsWidgets);
      expect(find.text('Receita'), findsWidgets);
      expect(find.text('Crescimento'), findsWidgets);
      expect(find.text('Saúde'), findsWidgets);
    });

    testWidgets('should display refresh button', (tester) async {
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display error state correctly', (tester) async {
      when(mockRepository.getSystemMetrics())
          .thenAnswer((_) async => Left(ServerFailure('Erro de conexão')));
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Tentar Novamente'), findsOneWidget);
    });

    testWidgets('should tap on refresh button and reload data', (tester) async {
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      // Should call repository methods again
      verify(mockRepository.getSystemMetrics()).called(greaterThan(1));
    });

    testWidgets('should switch tabs correctly', (tester) async {
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

      await tester.pumpWidget(createTestWidget(child: const AdminDashboardPage()));
      await tester.pumpAndSettle();

      // Tap on 'Receita' tab
      await tester.tap(find.text('Receita'));
      await tester.pumpAndSettle();

      // Tap on 'Crescimento' tab
      await tester.tap(find.text('Crescimento'));
      await tester.pumpAndSettle();

      // Tap on 'Saúde' tab
      await tester.tap(find.text('Saúde'));
      await tester.pumpAndSettle();

      expect(find.byType(TabBarView), findsOneWidget);
    });
  });
}
