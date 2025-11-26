import '../../../core/data/repositories/auth_repository.dart';
import 'forgot_password_view_model.dart';
import 'forgot_password_delegate.dart';

typedef VoidCallback = void Function();

class ForgotPasswordService implements ForgotPasswordDelegate {
  final AuthRepository _authRepository;
  final VoidCallback _onRecoverySuccess;
  final VoidCallback _onGoToLogin;

  ForgotPasswordService({
    required VoidCallback onRecoverySuccess,
    required VoidCallback onGoToLogin,
    AuthRepository? authRepository,
  })  : _onRecoverySuccess = onRecoverySuccess,
        _onGoToLogin = onGoToLogin,
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
        viewModel.setSuccess('Email de recuperacao enviado! Verifique sua caixa de entrada.');
        await Future.delayed(const Duration(seconds: 2));
        _onRecoverySuccess();
      } else {
        viewModel.setError('Email nao encontrado em nossa base de dados.');
      }
    } catch (e) {
      viewModel.setError('Erro inesperado. Tente novamente.');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void onGoToLoginPressed({required ForgotPasswordViewModel viewModel}) {
    _onGoToLogin();
  }
}
