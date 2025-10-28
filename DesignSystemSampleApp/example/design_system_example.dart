import 'package:flutter/material.dart';
import 'package:design_system_sample_app/design_system/design_system.dart';

/// Exemplo mínimo de uso do Design System refatorado
void main() {
  runApp(const DesignSystemExample());
}

class DesignSystemExample extends StatelessWidget {
  const DesignSystemExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design System Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login: $email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System - Exemplo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                const Text(
                  'Login com Design System',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Input de Email usando DSInput
                DSInput(
                  viewModel: InputViewModel(
                    controller: _emailController,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email é obrigatório';
                      }
                      if (!value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Input de Senha usando DSInput
                DSInput(
                  viewModel: InputViewModel(
                    controller: _passwordController,
                    placeholder: 'Senha',
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha é obrigatória';
                      }
                      if (value.length < 6) {
                        return 'Senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Botão de Login usando DSButton
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Entrar',
                    variant: ButtonVariant.primary,
                    size: ButtonSize.large,
                    fullWidth: true,
                    icon: Icons.login,
                    onPressed: _handleLogin,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Botão secundário usando DSButton
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Entrar com Google',
                    variant: ButtonVariant.outline,
                    size: ButtonSize.large,
                    fullWidth: true,
                    icon: Icons.g_mobiledata,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login com Google'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // LinkedLabel para recuperação de senha
                Center(
                  child: DSLinkedLabel(
                    viewModel: LinkedLabelViewModel(
                      text: 'Esqueceu sua senha? Clique aqui',
                      linkedText: 'Clique aqui',
                      onLinkTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recuperar senha'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // LinkedLabel para cadastro
                Center(
                  child: DSLinkedLabel(
                    viewModel: LinkedLabelViewModel(
                      text: 'Não tem uma conta? Cadastre-se',
                      linkedText: 'Cadastre-se',
                      onLinkTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ir para cadastro'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Seção de demonstração de variantes de botões
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Variantes de Botões',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Primary',
                        variant: ButtonVariant.primary,
                        onPressed: () {},
                      ),
                    ),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Secondary',
                        variant: ButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Tertiary',
                        variant: ButtonVariant.tertiary,
                        onPressed: () {},
                      ),
                    ),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Outline',
                        variant: ButtonVariant.outline,
                        onPressed: () {},
                      ),
                    ),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Ghost',
                        variant: ButtonVariant.ghost,
                        onPressed: () {},
                      ),
                    ),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Destructive',
                        variant: ButtonVariant.destructive,
                        icon: Icons.delete,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
