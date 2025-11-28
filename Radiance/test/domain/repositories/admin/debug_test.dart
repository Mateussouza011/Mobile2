import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_company_repository.dart';
import 'package:radiance_b2b_professional/data/datasources/local/database_helper.dart';
import '../../../helpers/test_helpers.dart';

@GenerateMocks([DatabaseHelper])
import 'admin_company_repository_test.mocks.dart';

void main() {
  late Database testDatabase;
  late MockDatabaseHelper mockDatabaseHelper;
  late AdminCompanyRepository repository;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    testDatabase = await TestHelpers.createTestDatabase();
  });

  setUp(() async {
    await TestHelpers.seedTestDatabase(testDatabase);
    mockDatabaseHelper = MockDatabaseHelper();
    when(mockDatabaseHelper.database).thenAnswer((_) async => testDatabase);
    repository = AdminCompanyRepository(databaseHelper: mockDatabaseHelper);
  });

  tearDown(() async {
    await TestHelpers.cleanupTestDatabase(testDatabase);
  });

  tearDownAll(() async {
    await testDatabase.close();
  });

  test('DEBUG: Check if companies exist in database', () async {
    final companies = await testDatabase.query('companies');
    print('Companies in database: ${companies.length}');
    for (var company in companies) {
      print('Company: ${company['name']} (${company['id']})');
    }
    expect(companies.length, greaterThanOrEqualTo(1));
  });

  test('DEBUG: Check company_users relationship', () async {
    final companyUsers = await testDatabase.query('company_users');
    print('Company users count: ${companyUsers.length}');
    for (var cu in companyUsers) {
      print('CompanyUser: company=${cu['company_id']}, user=${cu['user_id']}');
    }
    expect(companyUsers.length, greaterThanOrEqualTo(1));
  });

  test('DEBUG: Check database schema', () async {
    // List all tables
    final tables = await testDatabase.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"
    );
    print('Tables in database:');
    for (var table in tables) {
      print('  - ${table['name']}');
    }
    
    // Check columns in companies table
    final companyColumns = await testDatabase.rawQuery(
      "PRAGMA table_info(companies);"
    );
    print('\nCompanies table columns:');
    for (var col in companyColumns) {
      print('  - ${col['name']} (${col['type']})');
    }
  });

  test('DEBUG: Call repository getAllCompanies and check actual error', () async {
    print('\n--- Attempting to call repository.getAllCompanies() ---');
    final result = await repository.getAllCompanies();
    
    result.fold(
      (failure) {
        print('FAILURE RETURNED:');
        print('  Type: ${failure.runtimeType}');
        print('  Message: ${failure.message}');
        print('  Stack trace (if available): ${failure.toString()}');
      },
      (companies) {
        print('SUCCESS: Got ${companies.length} companies');
        for (var company in companies) {
          print('  - ${company.company.name} (${company.company.id})');
        }
      },
    );
    
    // This will fail, but we'll see the actual error message
    expect(result.isRight(), true);
  });
}

