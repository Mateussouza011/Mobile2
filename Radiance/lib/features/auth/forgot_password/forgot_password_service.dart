import '../../../core/data/repositories/auth_repository.dart';
import '../navigation/auth_coordinator.dart';
import 'forgot_password_view_model.dart';
import 'forgot_password_delegate.dart';

class ForgotPasswordService implements ForgotPasswordDelegate {
  final AuthRepository _authRepository;
  final AuthCoordinator _coordinator;

  ForgotPasswordService({
    required AuthCoordinator coordinator,
    AuthRepository? authRepository,
  })  : _coordinator = coordinator,
        _authRepository = authRepository ?? AuthRepository();

  @override
  void onEmailChanged({required ForgotPasswordViewModel viewModel, required String email}) {
    viewModel.setEmail(email);
  }

  @override
  Future<void> onRecoverPressed({required ForgotPasswordViewModel viewModel}) async {
    if (!viewModel.validateForm()) return;

    viewModel.setLoading(true);
    viewModel.setError(null);

    try {
      final user = await _authRepository.findUserByEmail(viewModel.email);
      
      if (user != null) {
        viewModel.setSuccess('Recovery email sent! Check your inbox.');
        await Future.delayed(const Duration(seconds: 2));
        _coordinator.goToLogin();
      } else {
        viewModel.setError('Email not found in our database.');
      }
    } catch (e) {
      viewModel.setError('Unexpected error. Please try again.');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void onGoToLoginPressed({required ForgotPasswordViewModel viewModel}) {
    _coordinator.goToLogin();
  }
}
