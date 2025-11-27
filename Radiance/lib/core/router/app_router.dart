import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/pages/main_layout.dart';
import '../../features/buttons/buttons_page.dart';
import '../../features/inputs/inputs_page.dart';
import '../../features/cards/cards_page.dart';
import '../../features/cards/cards_and_lists_page.dart';
import '../../features/tables/tables_page.dart';
import '../../features/sliders/sliders_page.dart';
import '../../features/modals/modals_page.dart';
import '../../features/badges/badges_page.dart';
import '../../features/progress/progress_page.dart';
import '../../features/avatars/avatars_page.dart';
import '../../features/forms/forms_page.dart';
import '../../features/navigation/navigation_bars_page.dart';
import '../../features/alerts/alerts_page.dart';
// MVVM Architecture
import '../../presentation/views/diamond_prediction_view.dart';
import '../../presentation/viewmodels/diamond_prediction_viewmodel.dart';
import '../di/dependency_injection.dart';
// Diamond Prediction App - Imports
import '../../features/diamond_prediction/landing/landing_factory.dart';
import '../../features/diamond_prediction/home/home_factory.dart';
import '../../features/diamond_prediction/prediction/prediction_factory.dart';
import '../../features/diamond_prediction/history/history_factory.dart';
// Auth - Imports
import '../../features/auth/login/login_factory.dart';
import '../../features/auth/register/register_factory.dart';
import '../../features/auth/forgot_password/forgot_password_factory.dart';
// B2B Features - Radiance
import '../../features/api_keys/presentation/pages/api_keys_page.dart';
import '../../features/api_keys/presentation/providers/api_key_provider.dart';
import '../../features/api_keys/data/repositories/api_key_repository.dart';
import '../../features/export/presentation/pages/export_page.dart';
import '../../features/export/presentation/providers/export_provider.dart';
import '../../features/export/data/services/pdf_export_service.dart';
import '../../features/export/data/services/csv_export_service.dart';
import '../data/repositories/prediction_history_repository.dart';
import '../../features/multi_tenant/presentation/providers/tenant_provider.dart';
import '../../features/api/presentation/pages/api_documentation_page.dart';
import '../../features/team_dashboard/presentation/pages/team_dashboard_page.dart';
import '../../features/team_dashboard/presentation/providers/team_dashboard_provider.dart';
import '../../features/team_dashboard/data/repositories/team_stats_repository.dart';
import '../../features/team/presentation/pages/team_invitations_page.dart';
import '../../features/team/presentation/providers/invitation_provider.dart';
import '../../features/team/data/repositories/invitation_repository.dart';

/// Configuração de rotas usando GoRouter
class AppRouter {
  static final _routerKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      // ============================================
      // Diamond Prediction App - Landing Page (Inicial)
      // ============================================
      GoRoute(
        path: '/',
        name: 'landing',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: LandingFactory.create(context),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      
      // ============================================
      // Design System Sample - Rotas do showcase
      // ============================================
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // Página do Design System
          GoRoute(
            path: '/design-system',
            name: 'design-system',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          
          // Seções de componentes
          GoRoute(
            path: '/buttons',
            name: 'buttons',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ButtonsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/inputs',
            name: 'inputs',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: InputsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/cards',
            name: 'cards',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: CardsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/cards-and-lists',
            name: 'cards-and-lists',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: CardsAndListsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/tables',
            name: 'tables',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: TablesPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/sliders',
            name: 'sliders',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: SlidersPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/modals',
            name: 'modals',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ModalsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          // Novos componentes
          GoRoute(
            path: '/badges',
            name: 'badges',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: BadgesPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/progress',
            name: 'progress',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ProgressPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/avatars',
            name: 'avatars',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: AvatarsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/forms',
            name: 'forms',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: FormsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/navigation-bars',
            name: 'navigation-bars',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: NavigationBarsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/alerts',
            name: 'alerts',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: AlertsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
        ],
      ),
      
      // ============================================
      // Diamond Prediction App - Rotas independentes
      // ============================================
      
      // Login do Diamond App (com banco de dados local)
      GoRoute(
        path: '/diamond-login',
        name: 'diamond-login',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: Builder(
            builder: (context) {
              return LoginFactory.create(context);
            },
          ),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      
      // Cadastro de usuário
      GoRoute(
        path: '/auth/register',
        name: 'auth-register',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: Builder(
            builder: (context) {
              return RegisterFactory.create(
                context: context,
                // Após cadastro, redireciona para login (não loga automaticamente)
                onRegisterSuccess: () => context.go('/diamond-login'),
                onGoToLogin: () => context.go('/diamond-login'),
              );
            },
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),
      
      // Recuperação de senha
      GoRoute(
        path: '/auth/forgot-password',
        name: 'auth-forgot-password',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: Builder(
            builder: (context) {
              return ForgotPasswordFactory.create(
                context: context,
                onRecoverySuccess: () => context.go('/diamond-login'),
                onGoToLogin: () => context.go('/diamond-login'),
              );
            },
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),
      
      // Home/Dashboard do Diamond App
      GoRoute(
        path: '/diamond-home',
        name: 'diamond-home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HomeFactory.create(context),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      
      // Predição do Diamond App (Legado)
      GoRoute(
        path: '/diamond-prediction',
        name: 'diamond-prediction',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: PredictionFactory.create(context),
          transitionsBuilder: _slideTransition,
        ),
      ),
      
      // Predição MVVM (Nova Arquitetura)
      GoRoute(
        path: '/prediction-mvvm',
        name: 'prediction-mvvm',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ChangeNotifierProvider(
            create: (_) => getIt<DiamondPredictionViewModel>(),
            child: const DiamondPredictionView(),
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),
      
      // Histórico do Diamond App
      GoRoute(
        path: '/diamond-history',
        name: 'diamond-history',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HistoryFactory.create(context),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // ============================================
      // B2B Features - Radiance
      // ============================================
      
      // API Keys Management
      GoRoute(
        path: '/api-keys',
        name: 'api-keys',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ApiKeyProvider(
                  repository: getIt<ApiKeyRepository>(),
                  tenantProvider: context.read<TenantProvider>(),
                ),
              ),
            ],
            child: const ApiKeysPage(),
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Export / Reports
      GoRoute(
        path: '/export',
        name: 'export',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ExportProvider(
                  pdfService: getIt<PdfExportService>(),
                  csvService: getIt<CsvExportService>(),
                  predictionRepository: getIt<PredictionHistoryRepository>(),
                  tenantProvider: context.read<TenantProvider>(),
                ),
              ),
            ],
            child: const ExportPage(),
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // API Documentation
      GoRoute(
        path: '/api-docs',
        name: 'api-docs',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const ApiDocumentationPage(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Team Dashboard
      GoRoute(
        path: '/team-dashboard',
        name: 'team-dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ChangeNotifierProvider(
            create: (context) => TeamDashboardProvider(
              repository: getIt<TeamStatsRepository>(),
              tenantProvider: context.read<TenantProvider>(),
            ),
            child: const TeamDashboardPage(),
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Team Invitations
      GoRoute(
        path: '/team-invitations',
        name: 'team-invitations',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: ChangeNotifierProvider(
            create: (context) => InvitationProvider(
              repository: getIt<InvitationRepository>(),
              tenantProvider: context.read<TenantProvider>(),
            ),
            child: const TeamInvitationsPage(),
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Erro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'A página "${state.uri}" não existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Transição de slide personalizada
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
  
  /// Transição de fade personalizada
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
