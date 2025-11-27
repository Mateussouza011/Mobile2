import 'forgot_password_view_model.dart';

abstract class ForgotPasswordDelegate {
  void onRecoverPressed({required ForgotPasswordViewModel viewModel});
  void onGoToLoginPressed({required ForgotPasswordViewModel viewModel});
  void onEmailChanged({required ForgotPasswordViewModel viewModel, required String email});
}
