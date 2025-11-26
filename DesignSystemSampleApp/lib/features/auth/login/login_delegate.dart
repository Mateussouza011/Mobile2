import 'login_view_model.dart';

/// Delegate para eventos da tela de Login
/// Define o contrato para ações do usuário
abstract class LoginDelegate {
  /// Chamado quando o usuário tenta fazer login
  void onLoginPressed({
    required LoginViewModel viewModel,
  });

  /// Chamado quando o usuário quer ir para o registro
  void onRegisterPressed({
    required LoginViewModel viewModel,
  });

  /// Chamado quando o usuário quer recuperar a senha
  void onForgotPasswordPressed({
    required LoginViewModel viewModel,
  });

  /// Chamado quando o email é alterado
  void onEmailChanged({
    required LoginViewModel viewModel,
    required String email,
  });

  /// Chamado quando a senha é alterada
  void onPasswordChanged({
    required LoginViewModel viewModel,
    required String password,
  });

  /// Chamado quando a visibilidade da senha é alterada
  void onTogglePasswordVisibility({
    required LoginViewModel viewModel,
  });

  /// Chamado quando "Lembrar-me" é alterado
  void onToggleRememberMe({
    required LoginViewModel viewModel,
  });
}
