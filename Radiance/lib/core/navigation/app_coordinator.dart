import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Base navigation coordinator abstraction.
/// All feature-specific coordinators should use this for navigation.
abstract class AppCoordinator {
  void navigateTo(String route);
  void navigateToNamed(String name, {Object? extra});
  void pop();
  void popUntil(String route);
  BuildContext? get navigatorContext;
}

class AppCoordinatorImpl implements AppCoordinator {
  final BuildContext _context;

  AppCoordinatorImpl(this._context);

  @override
  BuildContext? get navigatorContext => _context.mounted ? _context : null;

  @override
  void navigateTo(String route) {
    if (_context.mounted) {
      GoRouter.of(_context).go(route);
    }
  }

  @override
  void navigateToNamed(String name, {Object? extra}) {
    if (_context.mounted) {
      GoRouter.of(_context).goNamed(name, extra: extra);
    }
  }

  @override
  void pop() {
    if (_context.mounted) {
      GoRouter.of(_context).pop();
    }
  }

  @override
  void popUntil(String route) {
    if (_context.mounted) {
      while (GoRouter.of(_context).canPop()) {
        GoRouter.of(_context).pop();
      }
      GoRouter.of(_context).go(route);
    }
  }
}
