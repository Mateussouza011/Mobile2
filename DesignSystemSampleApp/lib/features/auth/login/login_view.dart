import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';
import '../../../ui/widgets/shadcn/shadcn_checkbox.dart';
import 'login_view_model.dart';
import 'login_delegate.dart';

/// View da tela de Login
/// Apenas UI, toda lógica delegada ao LoginDelegate
class LoginView extends StatefulWidget {
  final LoginViewModel viewModel;
  final LoginDelegate delegate;

  const LoginView({
    super.key,
    required this.viewModel,
    required this.delegate,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 440 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header com logo
                  _buildHeader(context, textTheme, colorScheme),
                  
                  const SizedBox(height: 32),
                  
                  // Card de Login
                  _buildLoginCard(context, colorScheme, textTheme),
                  
                  const SizedBox(height: 24),
                  
                  // Link para registro
                  _buildRegisterLink(context, colorScheme, textTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Ícone de diamante
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/images/diamond.svg',
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Diamond Price',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Faça login para continuar',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return ShadcnCard(
      variant: ShadcnCardVariant.outlined,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensagem de erro
          if (widget.viewModel.errorMessage != null) ...[
            ShadcnAlert(
              title: 'Erro',
              description: widget.viewModel.errorMessage,
              type: ShadcnAlertType.error,
              variant: ShadcnAlertVariant.filled,
              dismissible: true,
              onDismiss: () => widget.viewModel.setError(null),
            ),
            const SizedBox(height: 16),
          ],
          
          // Campo de Email
          ShadcnInput.email(
            label: 'Email',
            placeholder: 'seu@email.com',
            controller: _emailController,
            errorText: widget.viewModel.emailError,
            enabled: !widget.viewModel.isLoading,
            onChanged: (value) => widget.delegate.onEmailChanged(
              viewModel: widget.viewModel,
              email: value,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Campo de Senha
          ShadcnInput.password(
            label: 'Senha',
            placeholder: 'Digite sua senha',
            controller: _passwordController,
            errorText: widget.viewModel.passwordError,
            enabled: !widget.viewModel.isLoading,
            onChanged: (value) => widget.delegate.onPasswordChanged(
              viewModel: widget.viewModel,
              password: value,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lembrar-me e Esqueci a senha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ShadcnCheckbox(
                    value: widget.viewModel.rememberMe,
                    onChanged: (_) => widget.delegate.onToggleRememberMe(
                      viewModel: widget.viewModel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lembrar-me',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ShadcnButton(
                text: 'Esqueci a senha',
                variant: ShadcnButtonVariant.link,
                size: ShadcnButtonSize.sm,
                disabled: widget.viewModel.isLoading,
                onPressed: () => widget.delegate.onForgotPasswordPressed(
                  viewModel: widget.viewModel,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Botão de Login
          ShadcnButton(
            text: widget.viewModel.isLoading ? 'Entrando...' : 'Entrar',
            loading: widget.viewModel.isLoading,
            disabled: widget.viewModel.isLoading,
            onPressed: () => widget.delegate.onLoginPressed(
              viewModel: widget.viewModel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        ShadcnButton(
          text: 'Cadastre-se',
          variant: ShadcnButtonVariant.link,
          disabled: widget.viewModel.isLoading,
          onPressed: () => widget.delegate.onRegisterPressed(
            viewModel: widget.viewModel,
          ),
        ),
      ],
    );
  }
}
