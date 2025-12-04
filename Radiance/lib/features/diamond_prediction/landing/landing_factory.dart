import 'package:flutter/material.dart';
import 'landing_view.dart';
import '../navigation/diamond_coordinator.dart';
import '../../auth/navigation/auth_coordinator.dart';
import '../../../core/navigation/app_coordinator.dart';

class LandingFactory {
  static Widget create(BuildContext context) {
    final appCoordinator = AppCoordinatorImpl(context);
    final diamondCoordinator = DiamondCoordinatorImpl(appCoordinator);
    final authCoordinator = AuthCoordinatorImpl(appCoordinator);
    
    return LandingView(
      diamondCoordinator: diamondCoordinator,
      authCoordinator: authCoordinator,
    );
  }
}
