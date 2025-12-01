import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_user_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_user_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_user_stats.dart';
import 'package:radiance_b2b_professional/features/auth/domain/entities/user.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company_user.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminUserRepository])
import 'admin_user_provider_test.mocks.dart';

void main() {
  late AdminUserProvider provider;
  late MockAdminUserRepository mockRepository;

  setUp(() {
    mockRepository = MockAdminUserRepository();
    provider = AdminUserProvider(mockRepository);
  });

  // Helper to create test user stats
  AdminUserStats createTestUserStats({
    String id = 'user-1',
    String name = 'Test User',
    String email = 'test@example.com',
    bool isActive = true,
  }) {
    return AdminUserStats(
      user: User(
        id: id,
        name: name,
        email: email,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        isActive: isActive,
      ),
      companies: [
        CompanyUser(
          id: 'cu-1',
          companyId: 'company-1',
          userId: id,
          roleId: 'role-1',
          status: CompanyUserStatus.active,
          joinedAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
      ],
      totalPredictions: 50,
      predictionsThisMonth: 10,
      lastActivity: DateTime.now(),
      lastLogin: DateTime.now(),
      isActive: isActive,
      createdAt: DateTime(2024, 1, 1),
    );
  }

  group('AdminUserProvider - Initial State', () {
    test('should have empty users list initially', () {
      expect(provider.users, isEmpty);
    });

    test('should not be loading initially', () {
      expect(provider.isLoading, false);
    });

    test('should have no error initially', () {
      expect(provider.error, isNull);
    });

    test('should have no selected user initially', () {
      expect(provider.selectedUser, isNull);
    });

    test('should have default filters initially', () {
      expect(provider.filters, equals(const UserFilters()));
    });

    test('should have empty activity logs initially', () {
      expect(provider.activityLogs, isEmpty);
    });
  });

  group('AdminUserProvider - loadUsers', () {
    test('should load users successfully', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1', name: 'User 1'),
        createTestUserStats(id: 'user-2', name: 'User 2'),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));

      await provider.loadUsers();

      expect(provider.users.length, 2);
      expect(provider.error, isNull);
      expect(provider.isLoading, false);
    });

    test('should set loading state during load', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right([createTestUserStats()]);
      });

      final future = provider.loadUsers();
      expect(provider.isLoading, true);

      await future;
      expect(provider.isLoading, false);
    });

    test('should handle error when loading users', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Database error')));

      await provider.loadUsers();

      expect(provider.users, isEmpty);
      expect(provider.error, isNotNull);
    });

    test('should notify listeners when users are loaded', () async {
      final testUsers = [createTestUserStats()];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      await provider.loadUsers();

      expect(notificationCount, greaterThanOrEqualTo(2));
    });
  });

  group('AdminUserProvider - searchUsers', () {
    test('should update search query and reload', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([]));

      await provider.searchUsers('test query');

      expect(provider.filters.searchQuery, equals('test query'));
      verify(mockRepository.getAllUsers(any)).called(1);
    });

    test('should clear search query when empty string', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([]));

      await provider.searchUsers('');

      expect(provider.filters.searchQuery, isNull);
    });
  });

  group('AdminUserProvider - applyFilters', () {
    test('should apply filters and reload users', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([]));

      const filters = UserFilters(
        isActive: true,
      );

      await provider.applyFilters(filters);

      expect(provider.filters, equals(filters));
      verify(mockRepository.getAllUsers(filters)).called(1);
    });
  });

  group('AdminUserProvider - clearFilters', () {
    test('should clear filters and reload users', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([]));

      await provider.applyFilters(const UserFilters(isActive: true));
      await provider.clearFilters();

      expect(provider.filters, equals(const UserFilters()));
    });
  });

  group('AdminUserProvider - loadUserDetails', () {
    test('should load user details successfully', () async {
      final testUser = createTestUserStats();

      when(mockRepository.getUserDetails(any))
          .thenAnswer((_) async => Right(testUser));

      await provider.loadUserDetails('user-1');

      expect(provider.selectedUser, isNotNull);
      expect(provider.selectedUser!.user.id, equals('user-1'));
      expect(provider.error, isNull);
    });

    test('should handle error when loading user details', () async {
      when(mockRepository.getUserDetails(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Not found')));

      await provider.loadUserDetails('invalid-id');

      expect(provider.selectedUser, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - disableUser', () {
    test('should disable user successfully', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1', isActive: true),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));
      when(mockRepository.disableUser(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadUsers();
      final result = await provider.disableUser('user-1');

      expect(result, true);
      expect(provider.users.first.isActive, false);
    });

    test('should handle error when disabling user', () async {
      when(mockRepository.disableUser(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Error disabling')));

      final result = await provider.disableUser('user-1');

      expect(result, false);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - enableUser', () {
    test('should enable user successfully', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1', isActive: false),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));
      when(mockRepository.enableUser(any))
          .thenAnswer((_) async => const Right(null));

      await provider.loadUsers();
      final result = await provider.enableUser('user-1');

      expect(result, true);
      expect(provider.users.first.isActive, true);
    });

    test('should handle error when enabling user', () async {
      when(mockRepository.enableUser(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Error enabling')));

      final result = await provider.enableUser('user-1');

      expect(result, false);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - resetPassword', () {
    test('should reset password and return temp password', () async {
      when(mockRepository.resetPassword(any))
          .thenAnswer((_) async => const Right('TempPass123'));

      final result = await provider.resetPassword('user-1');

      expect(result, equals('TempPass123'));
      expect(provider.error, isNull);
    });

    test('should handle error when resetting password', () async {
      when(mockRepository.resetPassword(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Error resetting')));

      final result = await provider.resetPassword('user-1');

      expect(result, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - loadActivityLogs', () {
    test('should load activity logs successfully', () async {
      final testLogs = [
        UserActivityLog(
          id: 'log-1',
          userId: 'user-1',
          action: 'login',
          timestamp: DateTime.now(),
          details: 'ip: 192.168.1.1',
        ),
        UserActivityLog(
          id: 'log-2',
          userId: 'user-1',
          action: 'prediction',
          timestamp: DateTime.now(),
          details: 'success',
        ),
      ];

      when(mockRepository.getUserActivityLogs(any, days: anyNamed('days')))
          .thenAnswer((_) async => Right(testLogs));

      await provider.loadActivityLogs('user-1');

      expect(provider.activityLogs.length, 2);
      expect(provider.error, isNull);
    });

    test('should handle error when loading activity logs', () async {
      when(mockRepository.getUserActivityLogs(any, days: anyNamed('days')))
          .thenAnswer((_) async => Left(DatabaseFailure('Error loading logs')));

      await provider.loadActivityLogs('user-1');

      expect(provider.activityLogs, isEmpty);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - loadSystemStats', () {
    test('should load system stats successfully', () async {
      final testStats = {
        'total_users': 100,
        'active_users': 80,
        'new_users_this_month': 10,
      };

      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(testStats));

      await provider.loadSystemStats();

      expect(provider.systemStats, isNotNull);
      expect(provider.systemStats!['total_users'], 100);
      expect(provider.error, isNull);
    });

    test('should handle error when loading system stats', () async {
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Left(DatabaseFailure('Stats error')));

      await provider.loadSystemStats();

      expect(provider.systemStats, isNull);
      expect(provider.error, isNotNull);
    });
  });

  group('AdminUserProvider - Computed Properties', () {
    test('should calculate totalUsers correctly', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1'),
        createTestUserStats(id: 'user-2'),
        createTestUserStats(id: 'user-3'),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));

      await provider.loadUsers();

      expect(provider.totalUsers, 3);
    });

    test('should calculate activeUsers correctly', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1', isActive: true),
        createTestUserStats(id: 'user-2', isActive: true),
        createTestUserStats(id: 'user-3', isActive: false),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));

      await provider.loadUsers();

      expect(provider.activeUsers, 2);
    });

    test('should calculate disabledUsers correctly', () async {
      final testUsers = [
        createTestUserStats(id: 'user-1', isActive: true),
        createTestUserStats(id: 'user-2', isActive: false),
        createTestUserStats(id: 'user-3', isActive: false),
      ];

      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right(testUsers));

      await provider.loadUsers();

      expect(provider.disabledUsers, 2);
    });
  });

  group('AdminUserProvider - clearError', () {
    test('should clear error and notify listeners', () async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Left(DatabaseFailure('Test error')));

      await provider.loadUsers();
      expect(provider.error, isNotNull);

      int notificationCount = 0;
      provider.addListener(() => notificationCount++);

      provider.clearError();

      expect(provider.error, isNull);
      expect(notificationCount, 1);
    });
  });

  group('AdminUserProvider - clearSelectedUser', () {
    test('should clear selected user and activity logs', () async {
      final testUser = createTestUserStats();
      final testLogs = [
        UserActivityLog(
          id: 'log-1',
          userId: 'user-1',
          action: 'login',
          timestamp: DateTime.now(),
        ),
      ];

      when(mockRepository.getUserDetails(any))
          .thenAnswer((_) async => Right(testUser));
      when(mockRepository.getUserActivityLogs(any, days: anyNamed('days')))
          .thenAnswer((_) async => Right(testLogs));

      await provider.loadUserDetails('user-1');
      await provider.loadActivityLogs('user-1');

      expect(provider.selectedUser, isNotNull);
      expect(provider.activityLogs, isNotEmpty);

      provider.clearSelectedUser();

      expect(provider.selectedUser, isNull);
      expect(provider.activityLogs, isEmpty);
    });
  });
}
