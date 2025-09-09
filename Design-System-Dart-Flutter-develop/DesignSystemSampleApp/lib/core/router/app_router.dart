import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/pages/main_layout.dart';
import '../../features/buttons/buttons_page.dart';
import '../../features/inputs/inputs_page.dart';
import '../../features/cards/cards_page.dart';
import '../../features/tables/tables_page.dart';
import '../../features/sliders/sliders_page.dart';
import '../../features/modals/modals_page.dart';
import '../../features/showcase/showcase_page.dart';

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
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ComponentShowcasePage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/buttons',
            name: 'buttons',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ButtonsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/inputs',
            name: 'inputs',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const InputsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/cards',
            name: 'cards',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CardsPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/tables',
            name: 'tables',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const TablesPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/sliders',
            name: 'sliders',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const SlidersPage(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          
          GoRoute(
            path: '/modals',
            name: 'modals',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const ModalsPage(),
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
