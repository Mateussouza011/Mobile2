import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';
import '../../../ui/widgets/shadcn/shadcn_checkbox.dart';
import 'register_view_model.dart';
import 'register_delegate.dart';

class RegisterView extends StatefulWidget {
  final RegisterViewModel viewModel;
  final RegisterDelegate delegate;

  const RegisterView({
    super.key,
    required this.viewModel,
    required this.delegate,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    final horizontalPadding = isDesktop ? 48.0 : 24.0;
    final maxWidth = isDesktop ? 440.0 : double.infinity;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => widget.delegate.onGoToLoginPressed(
            viewModel: widget.viewModel,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(textTheme, colorScheme),
                  const SizedBox(height: 24),
                  _buildRegisterCard(colorScheme, textTheme),
                  const SizedBox(height: 24),
                  _buildLoginLink(colorScheme, textTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person_add_outlined, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Account',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in your details to get started',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildRegisterCard(ColorScheme colorScheme, TextTheme textTheme) {
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
          ShadcnInput(
            label: 'Full name',
            placeholder: 'Your name',
            controller: _nameController,
            errorText: widget.viewModel.nameError,
            enabled: !widget.viewModel.isLoading,
            prefixIcon: const Icon(Icons.person_outline),
            onChanged: (value) => widget.delegate.onNameChanged(
              viewModel: widget.viewModel,
              name: value,
            ),
          ),
          const SizedBox(height: 16),
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
            placeholder: 'Minimum 6 characters',
            controller: _passwordController,
            errorText: widget.viewModel.passwordError,
            enabled: !widget.viewModel.isLoading,
            onChanged: (value) => widget.delegate.onPasswordChanged(
              viewModel: widget.viewModel,
              password: value,
            ),
          ),
          const SizedBox(height: 16),
          ShadcnInput.password(
            label: 'Confirm password',
            placeholder: 'Enter password again',
            controller: _confirmPasswordController,
            errorText: widget.viewModel.confirmPasswordError,
            enabled: !widget.viewModel.isLoading,
            onChanged: (value) => widget.delegate.onConfirmPasswordChanged(
              viewModel: widget.viewModel,
              confirmPassword: value,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ShadcnCheckbox(
                value: widget.viewModel.acceptTerms,
                onChanged: (_) => widget.delegate.onToggleAcceptTerms(
                  viewModel: widget.viewModel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I accept the terms of use and privacy policy',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ShadcnButton(
            text: widget.viewModel.isLoading ? 'Creating account...' : 'Create account',
            loading: widget.viewModel.isLoading,
            disabled: widget.viewModel.isLoading,
            onPressed: () => widget.delegate.onRegisterPressed(viewModel: widget.viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        ShadcnButton(
          text: 'Log in',
          variant: ShadcnButtonVariant.link,
          disabled: widget.viewModel.isLoading,
          onPressed: () => widget.delegate.onGoToLoginPressed(viewModel: widget.viewModel),
        ),
      ],
    );
  }
}
