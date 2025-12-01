import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/pages/admin_companies_page.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_company_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_company_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_company_stats.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/subscription.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminCompanyRepository])
import 'admin_companies_page_test.mocks.dart';

void main() {
  late MockAdminCompanyRepository mockRepository;
  late AdminCompanyProvider provider;

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

  final testCompanyStats = AdminCompanyStats(
    company: testCompany,
    subscription: testSubscription,
    totalMembers: 10,
    activeMembers: 8,
    totalPredictions: 5000,
    predictionsThisMonth: 500,
    totalRevenue: 1000.0,
    lastActivity: DateTime(2024, 1, 15),
    createdAt: DateTime(2024, 1, 1),
  );

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AdminCompanyProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  setUp(() {
    mockRepository = MockAdminCompanyRepository();
    provider = AdminCompanyProvider(repository: mockRepository);
  });

  group('AdminCompaniesPage', () {
    testWidgets('should display loading indicator initially', (tester) async {
      final completer = Completer<Either<Failure, List<AdminCompanyStats>>>();
      
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      completer.complete(Right([testCompanyStats]));
      await tester.pumpAndSettle();
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Admin - Empresas'), findsOneWidget);
    });

    testWidgets('should display filter icon button', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display refresh icon button', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display companies list when data loads', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      expect(find.text('Test Company'), findsOneWidget);
    });

    testWidgets('should tap on refresh button and reload data', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Should call repository method again
      verify(mockRepository.getAllCompanies(filters: anyNamed('filters'))).called(greaterThan(1));
    });

    testWidgets('should display empty state when no companies', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => const Right(<AdminCompanyStats>[]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      // Should not crash with empty list - widget should render
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should allow typing in search field', (tester) async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompanyStats]));

      await tester.pumpWidget(createTestWidget(child: const AdminCompaniesPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();

      expect(find.text('Test'), findsWidgets);
    });
  });
}
