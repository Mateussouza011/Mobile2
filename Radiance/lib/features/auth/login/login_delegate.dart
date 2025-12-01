import 'login_view_model.dart';
abstract class LoginDelegate {
  void onLoginPressed({
    required LoginViewModel viewModel,
  });
  void onRegisterPressed({
    required LoginViewModel viewModel,
  });
  void onForgotPasswordPressed({
    required LoginViewModel viewModel,
  });
  void onEmailChanged({
    required LoginViewModel viewModel,
    required String email,
  });
  void onPasswordChanged({
    required LoginViewModel viewModel,
    required String password,
  });
  void onTogglePasswordVisibility({
    required LoginViewModel viewModel,
  });
  void onToggleRememberMe({
    required LoginViewModel viewModel,
  });
}
