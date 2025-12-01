import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/pages/admin_users_page.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_user_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_user_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_user_stats.dart';
import 'package:radiance_b2b_professional/features/auth/domain/entities/user.dart';
import 'package:radiance_b2b_professional/features/multi_tenant/domain/entities/company_user.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminUserRepository])
import 'admin_users_page_test.mocks.dart';

void main() {
  late MockAdminUserRepository mockRepository;
  late AdminUserProvider provider;

  final testUser = User(
    id: 'user-1',
    email: 'test@example.com',
    name: 'Test User',
    isAdmin: false,
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testCompanyUser = CompanyUser(
    id: 'cu-1',
    userId: 'user-1',
    companyId: 'company-1',
    roleId: 'role-admin',
    status: CompanyUserStatus.active,
    joinedAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final testUserStats = AdminUserStats(
    user: testUser,
    companies: [testCompanyUser],
    totalPredictions: 1000,
    predictionsThisMonth: 100,
    lastActivity: DateTime(2024, 1, 15),
    lastLogin: DateTime(2024, 1, 14),
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
  );

  final systemStats = {
    'totalUsers': 100,
    'activeUsers': 80,
    'newUsersThisMonth': 10,
    'avgSessionDuration': 30.5,
  };

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AdminUserProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  setUp(() {
    mockRepository = MockAdminUserRepository();
    provider = AdminUserProvider(mockRepository);
  });

  group('AdminUsersPage', () {
    testWidgets('should display loading indicator initially', (tester) async {
      final completer = Completer<Either<Failure, List<AdminUserStats>>>();
      
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) => completer.future);
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      completer.complete(Right([testUserStats]));
      await tester.pumpAndSettle();
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      expect(find.text('Gerenciar Usuários'), findsOneWidget);
    });

    testWidgets('should display filter icon button', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display refresh icon button', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display users list when data loads', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should tap on refresh button and reload data', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Should call repository method again
      verify(mockRepository.getAllUsers(any)).called(greaterThan(1));
    });

    testWidgets('should allow typing in search field', (tester) async {
      when(mockRepository.getAllUsers(any))
          .thenAnswer((_) async => Right([testUserStats]));
      when(mockRepository.getSystemUserStats())
          .thenAnswer((_) async => Right(systemStats));

      await tester.pumpWidget(createTestWidget(child: const AdminUsersPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();

      expect(find.text('Test'), findsWidgets);
    });
  });
}
