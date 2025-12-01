import '../../../core/data/repositories/auth_repository.dart';
import 'register_view_model.dart';
import 'register_delegate.dart';
class RegisterService implements RegisterDelegate {
  final AuthRepository _authRepository;
  final VoidCallback _onRegisterSuccess;
  final VoidCallback _onGoToLogin;

  RegisterService({
    required VoidCallback onRegisterSuccess,
    required VoidCallback onGoToLogin,
    AuthRepository? authRepository,
  })  : _onRegisterSuccess = onRegisterSuccess,
        _onGoToLogin = onGoToLogin,
        _authRepository = authRepository ?? AuthRepository();

  @override
  void onNameChanged({required RegisterViewModel viewModel, required String name}) {
    viewModel.setName(name);
  }

  @override
  void onEmailChanged({required RegisterViewModel viewModel, required String email}) {
    viewModel.setEmail(email);
  }

  @override
  void onPasswordChanged({required RegisterViewModel viewModel, required String password}) {
    viewModel.setPassword(password);
  }

  @override
  void onConfirmPasswordChanged({required RegisterViewModel viewModel, required String confirmPassword}) {
    viewModel.setConfirmPassword(confirmPassword);
  }

  @override
  void onTogglePasswordVisibility({required RegisterViewModel viewModel}) {
    viewModel.togglePasswordVisibility();
  }

  @override
  void onToggleConfirmPasswordVisibility({required RegisterViewModel viewModel}) {
    viewModel.toggleConfirmPasswordVisibility();
  }

  @override
  void onToggleAcceptTerms({required RegisterViewModel viewModel}) {
    viewModel.toggleAcceptTerms();
  }

  @override
  Future<void> onRegisterPressed({required RegisterViewModel viewModel}) async {
    if (!viewModel.validateForm()) {
      return;
    }

    viewModel.setLoading(true);
    viewModel.setError(null);

    try {
      final result = await _authRepository.register(
        name: viewModel.name,
        email: viewModel.email,
        password: viewModel.password,
      );

      if (result.isSuccess) {
        _onRegisterSuccess();
      } else {
        viewModel.setError(result.message ?? 'Erro ao cadastrar');
      }
    } catch (e) {
      viewModel.setError('Erro inesperado. Tente novamente.');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void onGoToLoginPressed({required RegisterViewModel viewModel}) {
    _onGoToLogin();
  }
}

typedef VoidCallback = void Function();
