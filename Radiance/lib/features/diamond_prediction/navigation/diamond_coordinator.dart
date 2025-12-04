import 'package:flutter/material.dart';
import '../../../core/navigation/app_coordinator.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/colors.dart';

/// Coordinator for Diamond feature navigation.
/// Encapsulates all navigation logic for the diamond prediction module.
abstract class DiamondCoordinator {
  void goToLogin();
  void goToHome();
  void goToPrediction();
  void goToHistory();
  void goBack();
  void showSuccessMessage(String message);
  void showErrorMessage(String message);
}

class DiamondCoordinatorImpl implements DiamondCoordinator {
  final AppCoordinator _appCoordinator;

  DiamondCoordinatorImpl(this._appCoordinator);

  @override
  void goToLogin() {
    _appCoordinator.navigateTo(AppRoutes.login);
  }

  @override
  void goToHome() {
    _appCoordinator.navigateTo(AppRoutes.home);
  }

  @override
  void goToPrediction() {
    _appCoordinator.navigateTo(AppRoutes.prediction);
  }

  @override
  void goToHistory() {
    _appCoordinator.navigateTo(AppRoutes.history);
  }

  @override
  void goBack() {
    _appCoordinator.pop();
  }

  @override
  void showSuccessMessage(String message) {
    final context = _appCoordinator.navigatorContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: ShadcnColors.chart[2], // Green from Design System
        ),
      );
    }
  }

  @override
  void showErrorMessage(String message) {
    final context = _appCoordinator.navigatorContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: ShadcnColors.destructive,
        ),
      );
    }
  }
}
