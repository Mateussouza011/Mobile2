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
import '../../presentation/views/diamond_prediction_view.dart';
import '../../presentation/viewmodels/diamond_prediction_viewmodel.dart';
import '../di/dependency_injection.dart';
import '../../features/diamond_prediction/landing/landing_factory.dart';
import '../../features/diamond_prediction/home/home_factory.dart';
import '../../features/diamond_prediction/prediction/prediction_factory.dart';
import '../../features/diamond_prediction/history/history_factory.dart';
import '../../features/auth/login/login_factory.dart';
import '../../features/auth/register/register_factory.dart';
import '../../features/auth/forgot_password/forgot_password_factory.dart';
class AppRouter {
  static final _routerKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: LandingFactory.create(context),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/design-system',
            name: 'design-system',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
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
      GoRoute(
        path: '/auth/register',
        name: 'auth-register',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: Builder(
            builder: (context) {
              return RegisterFactory.create(
                context: context,
                onRegisterSuccess: () => context.go('/diamond-login'),
                onGoToLogin: () => context.go('/diamond-login'),
              );
            },
          ),
          transitionsBuilder: _slideTransition,
        ),
      ),
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
      GoRoute(
        path: '/diamond-home',
        name: 'diamond-home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HomeFactory.create(context),
          transitionsBuilder: _fadeTransition,
        ),
      ),
      GoRoute(
        path: '/diamond-prediction',
        name: 'diamond-prediction',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: PredictionFactory.create(context),
          transitionsBuilder: _slideTransition,
        ),
      ),
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
      GoRoute(
        path: '/diamond-history',
        name: 'diamond-history',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: HistoryFactory.create(context),
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
