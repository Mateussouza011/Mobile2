import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/pages/main_layout.dart';
import '../../features/buttons/buttons_page.dart';
import '../../features/inputs/inputs_page.dart';
import '../../features/cards/cards_page.dart';
import '../../features/cards/cards_and_lists_page.dart';
import '../../features/tables/tables_page.dart';
import '../../features/sliders/sliders_page.dart';
import '../../features/modals/modals_page.dart';
import '../../features/showcase/showcase_page.dart';
import '../../features/badges/badges_page.dart';
import '../../features/progress/progress_page.dart';
import '../../features/avatars/avatars_page.dart';
import '../../features/forms/forms_page.dart';
import '../../features/navigation/navigation_bars_page.dart';
import '../../features/alerts/alerts_page.dart';

/// Configuração de rotas usando GoRouter
class AppRouter {
  static final _routerKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          // Página inicial
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          
          // Seções de componentes
          GoRoute(
            path: '/showcase',
            name: 'showcase',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ComponentShowcasePage(),
              transitionsBuilder: _slideTransition,
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
}
