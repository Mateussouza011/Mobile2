import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/pages/admin_subscriptions_page.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_subscription_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_subscription_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_subscription_stats.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/subscription.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminSubscriptionRepository])
import 'admin_subscriptions_page_test.mocks.dart';

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

  final systemStats = {
    'totalSubscriptions': 100,
    'activeSubscriptions': 80,
    'totalMRR': 10000.0,
  };

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AdminSubscriptionProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  setUp(() {
    mockRepository = MockAdminSubscriptionRepository();
    provider = AdminSubscriptionProvider(mockRepository);
  });

  group('AdminSubscriptionsPage', () {
    testWidgets('should display loading indicator initially', (tester) async {
      final completer = Completer<Either<Failure, List<AdminSubscriptionStats>>>();
      
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) => completer.future);
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      completer.complete(Right([testSubscriptionStats]));
      await tester.pumpAndSettle();
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Gerenciar Assinaturas'), findsOneWidget);
    });

    testWidgets('should display filter icon button', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display refresh icon button', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display subscriptions list when data loads', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Test Company'), findsOneWidget);
    });

    testWidgets('should tap on refresh button and reload data', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Should call repository method again
      verify(mockRepository.getAllSubscriptions(any)).called(greaterThan(1));
    });

    testWidgets('should allow typing in search field', (tester) async {
      when(mockRepository.getAllSubscriptions(any))
          .thenAnswer((_) async => Right([testSubscriptionStats]));
      when(mockRepository.getSystemSubscriptionStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminSubscriptionsPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();

      expect(find.text('Test'), findsWidgets);
    });
  });
}
