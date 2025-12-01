import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_company_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_company_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_company_stats.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/subscription.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminCompanyRepository])
import 'admin_company_provider_test.mocks.dart';

void main() {
  late AdminCompanyProvider provider;
  late MockAdminCompanyRepository mockRepository;

  setUp(() {
    mockRepository = MockAdminCompanyRepository();
    provider = AdminCompanyProvider(repository: mockRepository);
  });

  // Helper to create test company stats
  AdminCompanyStats createTestCompanyStats({
    String id = 'company-1',
    String name = 'Test Company',
    bool isActive = true,
    SubscriptionTier tier = SubscriptionTier.pro,
  }) {
    return AdminCompanyStats(
      company: Company(
        id: id,
        name: name,
        slug: 'test-company',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        isActive: isActive,
      ),
      subscription: Subscription(
        id: 'sub-1',
        companyId: id,
        tier: tier,
        status: SubscriptionStatus.active,
        amount: 29999,
        billingInterval: BillingInterval.monthly,
        startDate: DateTime(2024, 1, 1),
        currentPeriodStart: DateTime(2024, 1, 1),
        currentPeriodEnd: DateTime(2024, 2, 1),
        limits: SubscriptionLimits.pro,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      totalMembers: 5,
      activeMembers: 4,
      totalPredictions: 100,
      predictionsThisMonth: 20,
      lastActivity: DateTime.now(),
      totalRevenue: 29999,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  group('AdminCompanyProvider - Initial State', () {
    test('should have empty companies list initially', () {
      expect(provider.companies, isEmpty);
    });

    test('should not be loading initially', () {
      expect(provider.isLoading, false);
    });

    test('should have no error initially', () {
      expect(provider.error, isNull);
    });

    test('should have no selected company initially', () {
      expect(provider.selectedCompany, isNull);
    });

    test('should have default filters initially', () {
      expect(provider.filters, equals(const CompanyFilters()));
    });
  });

  group('AdminCompanyProvider - loadCompanies', () {
    test('should load companies successfully', () async {
      final testCompanies = [
        createTestCompanyStats(id: 'company-1', name: 'Company 1'),
        createTestCompanyStats(id: 'company-2', name: 'Company 2'),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      await provider.loadCompanies();

      expect(provider.companies.length, 2);
      expect(provider.error, isNull);
      expect(provider.isLoading, false);
    });

    test('should set loading state during load', () async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right([createTestCompanyStats()]);
      });

      final future = provider.loadCompanies();
      expect(provider.isLoading, true);

      await future;
      expect(provider.isLoading, false);
    });

    test('should handle error when loading companies', () async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Left(DatabaseFailure('Database error')));

      await provider.loadCompanies();

      expect(provider.companies, isEmpty);
      expect(provider.error, isNotNull);
      expect(provider.error, contains('Database error'));
    });

    test('should notify listeners when companies are loaded', () async {
      final testCompanies = [createTestCompanyStats()];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.loadCompanies();

      // Should notify at least twice (loading start and end)
      expect(notificationCount, greaterThanOrEqualTo(2));
    });
  });

  group('AdminCompanyProvider - applyFilters', () {
    test('should apply filters and reload companies', () async {
      final testCompanies = [createTestCompanyStats()];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      const filters = CompanyFilters(
        isActive: true,
        tier: SubscriptionTier.pro,
      );

      await provider.applyFilters(filters);

      expect(provider.filters, equals(filters));
      verify(mockRepository.getAllCompanies(filters: filters)).called(1);
    });
  });

  group('AdminCompanyProvider - clearFilters', () {
    test('should clear filters and reload companies', () async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([]));

      // First apply some filters
      await provider.applyFilters(const CompanyFilters(isActive: true));

      // Then clear them
      await provider.clearFilters();

      expect(provider.filters, equals(const CompanyFilters()));
    });
  });

  group('AdminCompanyProvider - searchCompanies', () {
    test('should update search query and reload', () async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([]));

      await provider.searchCompanies('test query');

      expect(provider.filters.searchQuery, equals('test query'));
    });
  });

  group('AdminCompanyProvider - loadCompanyDetails', () {
    test('should load company details successfully', () async {
      final testCompany = createTestCompanyStats();

      when(mockRepository.getCompanyDetails(any))
          .thenAnswer((_) async => Right(testCompany));

      await provider.loadCompanyDetails('company-1');

      expect(provider.selectedCompany, isNotNull);
      expect(provider.selectedCompany!.company.id, equals('company-1'));
      expect(provider.error, isNull);
    });

    test('should handle error when loading company details', () async {
      when(mockRepository.getCompanyDetails(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Not found')));

      await provider.loadCompanyDetails('invalid-id');

      expect(provider.selectedCompany, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminCompanyProvider - suspendCompany', () {
    test('should suspend company successfully', () async {
      // Setup initial companies
      final testCompanies = [
        createTestCompanyStats(id: 'company-1', isActive: true),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));
      when(mockRepository.suspendCompany(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadCompanies();
      final result = await provider.suspendCompany('company-1');

      expect(result, true);
      expect(provider.companies.first.company.isActive, false);
      expect(provider.error, isNull);
    });

    test('should handle error when suspending company', () async {
      when(mockRepository.suspendCompany(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Error suspending')));

      final result = await provider.suspendCompany('company-1');

      expect(result, false);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminCompanyProvider - activateCompany', () {
    test('should activate company successfully', () async {
      // Setup initial companies
      final testCompanies = [
        createTestCompanyStats(id: 'company-1', isActive: false),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));
      when(mockRepository.activateCompany(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadCompanies();
      final result = await provider.activateCompany('company-1');

      expect(result, true);
      expect(provider.companies.first.company.isActive, true);
      expect(provider.error, isNull);
    });

    test('should handle error when activating company', () async {
      when(mockRepository.activateCompany(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Error activating')));

      final result = await provider.activateCompany('company-1');

      expect(result, false);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminCompanyProvider - deleteCompany', () {
    test('should delete company successfully', () async {
      // Setup initial companies
      final testCompanies = [
        createTestCompanyStats(id: 'company-1'),
        createTestCompanyStats(id: 'company-2'),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));
      when(mockRepository.deleteCompany(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadCompanies();
      expect(provider.companies.length, 2);

      final result = await provider.deleteCompany('company-1');

      expect(result, true);
      expect(provider.companies.length, 1);
      expect(provider.companies.first.company.id, 'company-2');
    });

    test('should clear selected company if deleted', () async {
      final testCompany = createTestCompanyStats(id: 'company-1');

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right([testCompany]));
      when(mockRepository.getCompanyDetails(any))
          .thenAnswer((_) async => Right(testCompany));
      when(mockRepository.deleteCompany(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadCompanies();
      await provider.loadCompanyDetails('company-1');
      expect(provider.selectedCompany, isNotNull);

      await provider.deleteCompany('company-1');

      expect(provider.selectedCompany, isNull);
    });
  });

  group('AdminCompanyProvider - loadSystemStats', () {
    test('should load system stats successfully', () async {
      final testStats = {
        'total_companies': 10,
        'active_companies': 8,
        'total_revenue': 299990.0,
      };

      when(mockRepository.getSystemStats())
          .thenAnswer((_) async => Right(testStats));

      await provider.loadSystemStats();

      expect(provider.systemStats, isNotNull);
      expect(provider.systemStats!['total_companies'], 10);
      expect(provider.error, isNull);
    });

    test('should handle error when loading system stats', () async {
      when(mockRepository.getSystemStats())
          .thenAnswer((_) async => Left(DatabaseFailure('Stats error')));

      await provider.loadSystemStats();

      expect(provider.error, isNotNull);
    });
  });

  group('AdminCompanyProvider - Computed Properties', () {
    test('should calculate totalCompanies correctly', () async {
      final testCompanies = [
        createTestCompanyStats(id: 'company-1'),
        createTestCompanyStats(id: 'company-2'),
        createTestCompanyStats(id: 'company-3'),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      await provider.loadCompanies();

      expect(provider.totalCompanies, 3);
    });

    test('should calculate activeCompanies correctly', () async {
      final testCompanies = [
        createTestCompanyStats(id: 'company-1', isActive: true),
        createTestCompanyStats(id: 'company-2', isActive: true),
        createTestCompanyStats(id: 'company-3', isActive: false),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      await provider.loadCompanies();

      expect(provider.activeCompanies, 2);
    });

    test('should calculate suspendedCompanies correctly', () async {
      final testCompanies = [
        createTestCompanyStats(id: 'company-1', isActive: true),
        createTestCompanyStats(id: 'company-2', isActive: false),
        createTestCompanyStats(id: 'company-3', isActive: false),
      ];

      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Right(testCompanies));

      await provider.loadCompanies();

      expect(provider.suspendedCompanies, 2);
    });
  });

  group('AdminCompanyProvider - clearError', () {
    test('should clear error and notify listeners', () async {
      when(mockRepository.getAllCompanies(filters: anyNamed('filters')))
          .thenAnswer((_) async => Left(DatabaseFailure('Test error')));

      await provider.loadCompanies();
      expect(provider.error, isNotNull);

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notificationCount, 1);
    });
  });

  group('AdminCompanyProvider - clearSelectedCompany', () {
    test('should clear selected company and notify listeners', () async {
      final testCompany = createTestCompanyStats();

      when(mockRepository.getCompanyDetails(any))
          .thenAnswer((_) async => Right(testCompany));

      await provider.loadCompanyDetails('company-1');
      expect(provider.selectedCompany, isNotNull);

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      provider.clearSelectedCompany();

      expect(provider.selectedCompany, isNull);
      expect(notificationCount, 1);
    });
  });
}
