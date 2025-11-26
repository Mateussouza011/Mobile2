import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/repositories/auth_repository.dart';
import 'login_view_model.dart';
import 'login_delegate.dart';

/// Service que implementa a lógica de negócio do Login
class LoginService implements LoginDelegate {
  final AuthRepository _authRepository;
  final BuildContext _context;

  LoginService({
    required BuildContext context,
    AuthRepository? authRepository,
  })  : _context = context,
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
    // Valida o formulário
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
        // Navega para a home do Diamond App
        if (_context.mounted) {
          _context.go('/diamond-home');
        }
      } else {
        viewModel.setError(result.message ?? 'Erro ao fazer login');
      }
    } catch (e) {
      viewModel.setError('Erro inesperado. Tente novamente.');
    } finally {
      viewModel.setLoading(false);
    }
  }

  @override
  void onRegisterPressed({
    required LoginViewModel viewModel,
  }) {
    _context.go('/auth/register');
  }

  @override
  void onForgotPasswordPressed({
    required LoginViewModel viewModel,
  }) {
    _context.go('/auth/forgot-password');
  }
}
