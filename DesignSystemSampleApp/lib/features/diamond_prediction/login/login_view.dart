import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import 'login_view_model.dart';

/// LoginView - Tela de Login do Diamond Prediction App
/// 
/// Implementa a UI seguindo o Design System Shadcn/UI.
/// Usa os componentes ShadcnInput, ShadcnButton e ShadcnCard.
/// Todos os eventos são delegados ao ViewModel via Delegate Pattern.
class LoginView extends StatefulWidget {
  final LoginViewModel viewModel;
  
  const LoginView({
    super.key,
    required this.viewModel,
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
    // Registra callback para atualização da UI
    widget.viewModel.onStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo e título
                  _buildHeader(context),
                  
                  const SizedBox(height: 32),
                  
                  // Card de login
                  _buildLoginCard(context),
                  
                  const SizedBox(height: 16),
                  
                  // Texto informativo
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // Ícone de diamante
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.purple.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.diamond,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Diamond Price',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Prediction System',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoginCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = widget.viewModel;
    
    return ShadcnCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Entrar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Faça login para acessar as predições',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Campo de email
          ShadcnInput.email(
            label: 'Email',
            placeholder: 'seu@email.com',
            controller: _emailController,
            onChanged: (value) {
              viewModel.onEmailChanged(
                sender: viewModel,
                email: value,
              );
            },
            enabled: !viewModel.isLoading,
          ),
          
          const SizedBox(height: 16),
          
          // Campo de senha
          ShadcnInput.password(
            label: 'Senha',
            placeholder: '••••••••',
            controller: _passwordController,
            onChanged: (value) {
              viewModel.onPasswordChanged(
                sender: viewModel,
                password: value,
              );
            },
            enabled: !viewModel.isLoading,
            onSubmitted: (_) => viewModel.performLogin(),
          ),
          
          // Mensagem de erro
          if (viewModel.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 20,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Botão de login
          ShadcnButton(
            text: viewModel.isLoading ? 'Entrando...' : 'Entrar',
            onPressed: viewModel.canSubmit
                ? () => viewModel.onLoginRequested(
                    sender: viewModel,
                    email: viewModel.email,
                    password: viewModel.password,
                  )
                : null,
            loading: viewModel.isLoading,
            disabled: !viewModel.canSubmit,
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Text(
          'Powered by Machine Learning',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Design System Shadcn/UI',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
