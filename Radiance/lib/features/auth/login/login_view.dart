import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';
import '../../../ui/widgets/shadcn/shadcn_checkbox.dart';
import 'login_view_model.dart';
import 'login_delegate.dart';
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
                  _buildHeader(context, textTheme, colorScheme),
                  
                  const SizedBox(height: 32),
                  _buildLoginCard(context, colorScheme, textTheme),
                  
                  const SizedBox(height: 24),
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
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.diamond_outlined,
            size: 40,
            color: Colors.white,
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
          'Log in to continue',
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
          if (widget.viewModel.errorMessage != null) ...[
            ShadcnAlert(
              title: 'Error',
              description: widget.viewModel.errorMessage,
              type: ShadcnAlertType.error,
              variant: ShadcnAlertVariant.filled,
              dismissible: true,
              onDismiss: () => widget.viewModel.setError(null),
            ),
            const SizedBox(height: 16),
          ],
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
          ShadcnInput.password(
            label: 'Password',
            placeholder: 'Enter your password',
            controller: _passwordController,
            errorText: widget.viewModel.passwordError,
            enabled: !widget.viewModel.isLoading,
            onChanged: (value) => widget.delegate.onPasswordChanged(
              viewModel: widget.viewModel,
              password: value,
            ),
          ),
          
          const SizedBox(height: 16),
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
                    'Remember me',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ShadcnButton(
                text: 'Forgot password',
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
          ShadcnButton(
            text: widget.viewModel.isLoading ? 'Signing in...' : 'Sign In',
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
          "Don't have an account? ",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        ShadcnButton(
          text: 'Sign Up',
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
