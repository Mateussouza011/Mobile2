import '../../../core/data/repositories/auth_repository.dart';
import '../navigation/auth_coordinator.dart';
import 'login_view_model.dart';
import 'login_delegate.dart';

/// Service that handles login business logic.
/// Implements LoginDelegate to respond to view events.
class LoginService implements LoginDelegate {
  final AuthRepository _authRepository;
  final AuthCoordinator _coordinator;

  LoginService({
    required AuthCoordinator coordinator,
    AuthRepository? authRepository,
  })  : _coordinator = coordinator,
        _authRepository = authRepository ?? AuthRepository();

  @override
  void onEmailChanged({
    required LoginViewModel viewModel,
    required String email,
  }) {
    viewModel.setEmail(email);
  }

  @override
  void onPasswordChanged({
    required LoginViewModel viewModel,
    required String password,
  }) {
    viewModel.setPassword(password);
  }

  @override
  void onTogglePasswordVisibility({
    required LoginViewModel viewModel,
  }) {
    viewModel.togglePasswordVisibility();
  }

  @override
  void onToggleRememberMe({
    required LoginViewModel viewModel,
  }) {
    viewModel.toggleRememberMe();
  }

  @override
  Future<void> onLoginPressed({
    required LoginViewModel viewModel,
  }) async {
    if (!viewModel.validateForm()) {
      return;
    }

    viewModel.setLoading(true);
    viewModel.setError(null);

    try {
      final result = await _authRepository.login(
        email: viewModel.email,
        password: viewModel.password,
      );

      if (result.isSuccess && result.user != null) {
        _coordinator.goToHome();
      } else {
        viewModel.setError(result.message ?? 'Login failed');
      }
    } catch (e) {
      viewModel.setError('Unexpected error. Please try again.');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void onRegisterPressed({
    required LoginViewModel viewModel,
  }) {
    _coordinator.goToRegister();
  }

  @override
  void onForgotPasswordPressed({
    required LoginViewModel viewModel,
  }) {
    _coordinator.goToForgotPassword();
  }
}

