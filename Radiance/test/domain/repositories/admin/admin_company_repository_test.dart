import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_company_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_company_stats.dart';
import 'package:radiance_b2b_professional/data/datasources/local/database_helper.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';
import '../../../helpers/test_helpers.dart';

@GenerateMocks([DatabaseHelper])
import 'admin_company_repository_test.mocks.dart';

void main() {
  late AdminCompanyRepository repository;
  late MockDatabaseHelper mockDatabaseHelper;
  late Database testDatabase;

  setUpAll(() async {
    // Initialize FFI for sqflite testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    // Initialize test database once for all tests
    testDatabase = await TestHelpers.createTestDatabase();
  });

  setUp(() async {
    mockDatabaseHelper = MockDatabaseHelper();
    repository = AdminCompanyRepository(databaseHelper: mockDatabaseHelper);

    // Setup mock to return test database
    when(mockDatabaseHelper.database).thenAnswer((_) async => testDatabase);

    // Seed database with test data
    await TestHelpers.seedTestDatabase(testDatabase);
  });

  tearDown(() async {
    // Clean up test data after each test
    await TestHelpers.cleanupTestDatabase(testDatabase);
  });

  tearDownAll(() async {
    // Close test database
    await testDatabase.close();
  });

  group('AdminCompanyRepository', () {
    group('getAllCompanies', () {
      test('should return list of all companies with stats when successful',
          () async {
        // Act
        final result = await repository.getAllCompanies();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies, isA<List<AdminCompanyStats>>());
            expect(companies.length, greaterThanOrEqualTo(2));
            // Verify company properties
            final firstCompany = companies.first;
            expect(firstCompany.company.name, isNotEmpty);
            expect(firstCompany.totalMembers, greaterThanOrEqualTo(0));
          },
        );
      });

      test('should filter companies by search query', () async {
        // Arrange
        final filters = CompanyFilters(searchQuery: 'Diamond');

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.length, equals(1));
            expect(companies.first.company.name.contains('Diamond'), true);
          },
        );
      });

      test('should filter companies by active status', () async {
        // Arrange - filter for active companies
        final filters = CompanyFilters(isActive: true);

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.every((c) => c.company.isActive), true);
            expect(companies.length, equals(2)); // Diamond and Gem Trading
          },
        );
      });

      test('should filter companies by inactive status', () async {
        // Arrange - filter for inactive companies
        final filters = CompanyFilters(isActive: false);

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.every((c) => !c.company.isActive), true);
            expect(companies.length, equals(1)); // Inactive Company
          },
        );
      });

      test('should filter companies by creation date range', () async {
        // Arrange
        final filters = CompanyFilters(
          createdAfter: DateTime(2024, 1, 1),
          createdBefore: DateTime(2024, 12, 31),
        );

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.length, greaterThanOrEqualTo(2));
            for (var company in companies) {
              expect(company.createdAt.isAfter(DateTime(2023, 12, 31)), true);
              expect(company.createdAt.isBefore(DateTime(2025, 1, 1)), true);
            }
          },
        );
      });

      test('should sort companies by name ascending', () async {
        // Arrange
        final filters = CompanyFilters(
          sortBy: CompanySortBy.name,
          ascending: true,
        );

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.length, greaterThanOrEqualTo(2));
            // Check if sorted alphabetically
            for (int i = 0; i < companies.length - 1; i++) {
              expect(
                companies[i]
                    .company
                    .name
                    .toLowerCase()
                    .compareTo(companies[i + 1].company.name.toLowerCase()),
                lessThanOrEqualTo(0),
              );
            }
          },
        );
      });

      test('should sort companies by totalMembers descending', () async {
        // Arrange
        final filters = CompanyFilters(
          sortBy: CompanySortBy.totalMembers,
          ascending: false,
        );

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.length, greaterThanOrEqualTo(2));
            // Check if sorted by member count descending
            for (int i = 0; i < companies.length - 1; i++) {
              expect(
                companies[i].totalMembers,
                greaterThanOrEqualTo(companies[i + 1].totalMembers),
              );
            }
          },
        );
      });

      test('should combine multiple filters', () async {
        // Arrange
        final filters = CompanyFilters(
          searchQuery: 'Corp',
          isActive: true,
          sortBy: CompanySortBy.name,
        );

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.length, equals(1));
            expect(companies.first.company.name.contains('Corp'), true);
            expect(companies.first.company.isActive, true);
          },
        );
      });

      test('should return empty list when no companies match filters',
          () async {
        // Arrange
        final filters = CompanyFilters(searchQuery: 'NonExistentCompany');

        // Act
        final result = await repository.getAllCompanies(filters: filters);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (companies) {
            expect(companies.isEmpty, true);
          },
        );
      });

      test('should handle database errors gracefully', () async {
        // Arrange - simulate database error
        when(mockDatabaseHelper.database)
            .thenThrow(Exception('Database error'));
        final newRepository =
            AdminCompanyRepository(databaseHelper: mockDatabaseHelper);

        // Act
        final result = await newRepository.getAllCompanies();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<DatabaseFailure>());
          },
          (companies) => fail('Should return failure'),
        );
      });
    });

    group('getCompanyDetails', () {
      test('should return company stats for existing company', () async {
        // Act
        final result = await repository.getCompanyDetails('company-1');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company, isA<AdminCompanyStats>());
            expect(company.company.id, equals('company-1'));
            expect(company.totalMembers, greaterThanOrEqualTo(0));
          },
        );
      });

      test('should return failure for non-existent company', () async {
        // Act
        final result = await repository.getCompanyDetails('non-existent-id');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<DatabaseFailure>());
          },
          (company) => fail('Should return failure'),
        );
      });

      test('should include subscription data when available', () async {
        // Act
        final result = await repository.getCompanyDetails('company-1');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.subscription, isNotNull);
          },
        );
      });
    });

    group('suspendCompany', () {
      test('should suspend company successfully', () async {
        // Act
        final result = await repository.suspendCompany('company-1');

        // Assert
        expect(result.isRight(), true);

        // Verify the status was updated
        final verifyResult = await repository.getCompanyDetails('company-1');
        verifyResult.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.company.isActive, false);
          },
        );
      });
    });

    group('activateCompany', () {
      test('should activate company successfully', () async {
        // First suspend it
        await repository.suspendCompany('company-1');

        // Act
        final result = await repository.activateCompany('company-1');

        // Assert
        expect(result.isRight(), true);

        // Verify the status was updated
        final verifyResult = await repository.getCompanyDetails('company-1');
        verifyResult.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.company.isActive, true);
          },
        );
      });
    });



    group('deleteCompany', () {
      test('should soft delete company successfully', () async {
        // Act
        final result = await repository.deleteCompany('company-1');

        // Assert
        expect(result.isRight(), true);

        // Verify company is marked as inactive
        final verifyResult = await repository.getCompanyDetails('company-1');
        verifyResult.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.company.isActive, false);
          },
        );
      });
    });

    group('Edge Cases', () {
      test('should handle companies with zero members', () async {
        // The inactive company should have 0 members
        final result = await repository.getCompanyDetails('company-3');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.totalMembers, equals(0));
            expect(company.activeMembers, equals(0));
          },
        );
      });

      test('should calculate stats for companies with no predictions',
          () async {
        final result = await repository.getCompanyDetails('company-2');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            expect(company.totalPredictions, greaterThanOrEqualTo(0));
            expect(company.predictionsThisMonth, greaterThanOrEqualTo(0));
          },
        );
      });

      test('should handle companies without subscriptions', () async {
        final result = await repository.getCompanyDetails('company-3');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (company) {
            // Inactive company might not have subscription
            expect(company, isA<AdminCompanyStats>());
          },
        );
      });

      test('should get system-wide statistics', () async {
        final result = await repository.getSystemStats();

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (stats) {
            expect(stats, isA<Map<String, dynamic>>());
            expect(stats.containsKey('total_companies'), true);
            expect(stats.containsKey('active_companies'), true);
            expect(stats.containsKey('total_users'), true);
          },
        );
      });
    });
  });
}
