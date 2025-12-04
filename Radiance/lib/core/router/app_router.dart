import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
              return RegisterFactory.create(context: context);
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
              return ForgotPasswordFactory.create(context: context);
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
        title: const Text('Error'),
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
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri}" does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Home'),
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
