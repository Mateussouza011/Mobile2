import 'register_view_model.dart';

/// Delegate para eventos da tela de Registro
abstract class RegisterDelegate {
  void onRegisterPressed({required RegisterViewModel viewModel});
  void onGoToLoginPressed({required RegisterViewModel viewModel});
  void onNameChanged({required RegisterViewModel viewModel, required String name});
  void onEmailChanged({required RegisterViewModel viewModel, required String email});
  void onPasswordChanged({required RegisterViewModel viewModel, required String password});
  void onConfirmPasswordChanged({required RegisterViewModel viewModel, required String confirmPassword});
  void onTogglePasswordVisibility({required RegisterViewModel viewModel});
  void onToggleConfirmPasswordVisibility({required RegisterViewModel viewModel});
  void onToggleAcceptTerms({required RegisterViewModel viewModel});
}
