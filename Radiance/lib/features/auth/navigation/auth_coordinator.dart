import '../../../core/navigation/app_coordinator.dart';
import '../../../core/navigation/app_routes.dart';

abstract class AuthCoordinator {
  void goToLogin();
  void goToRegister();
  void goToForgotPassword();
  void goToHome();
  void goBack();
}

class AuthCoordinatorImpl implements AuthCoordinator {
  final AppCoordinator _appCoordinator;

  AuthCoordinatorImpl(this._appCoordinator);

  @override
  void goToLogin() {
    _appCoordinator.navigateTo(AppRoutes.login);
  }

  @override
  void goToRegister() {
    _appCoordinator.navigateTo(AppRoutes.register);
  }

  @override
  void goToForgotPassword() {
    _appCoordinator.navigateTo(AppRoutes.forgotPassword);
  }

  @override
  void goToHome() {
    _appCoordinator.navigateTo(AppRoutes.home);
  }

  @override
  void goBack() {
    _appCoordinator.pop();
  }
}
