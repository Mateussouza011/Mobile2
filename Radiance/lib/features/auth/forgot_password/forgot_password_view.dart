import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';
import 'forgot_password_view_model.dart';
import 'forgot_password_delegate.dart';

class ForgotPasswordView extends StatefulWidget {
  final ForgotPasswordViewModel viewModel;
  final ForgotPasswordDelegate delegate;

  const ForgotPasswordView({
    super.key,
    required this.viewModel,
    required this.delegate,
  });

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _emailController.dispose();
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
          onPressed: () => widget.delegate.onGoToLoginPressed(viewModel: widget.viewModel),
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
                  _buildCard(colorScheme, textTheme),
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
          child: const Icon(Icons.lock_reset_outlined, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          'Reset Password',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email to receive instructions',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCard(ColorScheme colorScheme, TextTheme textTheme) {
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
          if (widget.viewModel.successMessage != null) ...[
            ShadcnAlert(
              title: 'Success',
              description: widget.viewModel.successMessage,
              type: ShadcnAlertType.success,
              variant: ShadcnAlertVariant.filled,
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
          const SizedBox(height: 24),
          ShadcnButton(
            text: widget.viewModel.isLoading ? 'Sending...' : 'Send instructions',
            loading: widget.viewModel.isLoading,
            disabled: widget.viewModel.isLoading,
            onPressed: () => widget.delegate.onRecoverPressed(viewModel: widget.viewModel),
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
          'Remember your password? ',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        ShadcnButton(
          text: 'Back to login',
          variant: ShadcnButtonVariant.link,
          disabled: widget.viewModel.isLoading,
          onPressed: () => widget.delegate.onGoToLoginPressed(viewModel: widget.viewModel),
        ),
      ],
    );
  }
}
