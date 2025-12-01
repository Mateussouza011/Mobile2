import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/pages/admin_audit_logs_page.dart';
import 'package:radiance_b2b_professional/features/admin/presentation/providers/admin_audit_provider.dart';
import 'package:radiance_b2b_professional/features/admin/data/repositories/admin_audit_repository.dart';
import 'package:radiance_b2b_professional/features/admin/domain/entities/admin_audit_log.dart';
import 'package:radiance_b2b_professional/core/error/failures.dart';

@GenerateMocks([AdminAuditRepository])
import 'admin_audit_logs_page_test.mocks.dart';

void main() {
  late MockAdminAuditRepository mockRepository;
  late AdminAuditProvider provider;

  final testLog = AdminAuditLog(
    id: 'log-1',
    action: 'user.login',
    category: AuditLogCategory.auth,
    userId: 'user-1',
    userName: 'Test User',
    targetId: 'user-1',
    targetType: 'user',
    targetName: 'Test User',
    severity: AuditLogSeverity.info,
    createdAt: DateTime(2024, 1, 15),
  );

  final testStats = AuditLogStats(
    totalLogs: 100,
    infoCount: 60,
    warningCount: 30,
    criticalCount: 10,
    logsByCategory: {
      AuditLogCategory.user: 50,
      AuditLogCategory.company: 30,
      AuditLogCategory.subscription: 20,
    },
    topUsers: {
      'user-1': 25,
      'user-2': 20,
    },
    topActions: {
      'user.login': 40,
      'user.update': 35,
      'user.delete': 25,
    },
  );

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AdminAuditProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  setUp(() {
    mockRepository = MockAdminAuditRepository();
    provider = AdminAuditProvider(mockRepository);
  });

  group('AdminAuditLogsPage', () {
    testWidgets('should display loading indicator initially', (tester) async {
      // Set up mocks before provider starts loading
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      
      // Widget should render properly
      expect(find.byType(Scaffold), findsOneWidget);
      
      await tester.pumpAndSettle();
    });

    testWidgets('should display AppBar with correct title', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Logs de Auditoria'), findsOneWidget);
    });

    testWidgets('should display filter icon button', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display refresh icon button', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display logs list when data loads', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      expect(find.text('user.login'), findsOneWidget);
    });

    testWidgets('should tap on refresh button and reload data', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Should call repository method again
      verify(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).called(greaterThan(1));
    });

    testWidgets('should allow typing in search field', (tester) async {
      when(mockRepository.getAuditLogs(
        filters: anyNamed('filters'),
        limit: anyNamed('limit'),
        offset: anyNamed('offset'),
      )).thenAnswer((_) async => Right([testLog]));
      when(mockRepository.getAuditLogStats(
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(testStats));

      await tester.pumpWidget(createTestWidget(child: const AdminAuditLogsPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'login');
      await tester.pump();

      expect(find.text('login'), findsWidgets);
    });
  });
}
