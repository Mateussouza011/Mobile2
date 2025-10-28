import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// Página de exemplo para demonstrar o uso do componente LinkedLabel
class LinkedLabelSamplePage extends StatelessWidget {
  const LinkedLabelSamplePage({super.key});

  void _handleLinkTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link clicado: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkedLabel Component Samples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Exemplos de LinkedLabel'),
            const SizedBox(height: 16),
            
            // Exemplo 1: Termos de uso
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Termos de Uso',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Ao continuar, você aceita nossos Termos de Serviço',
                        linkedText: 'Termos de Serviço',
                        onLinkTap: () => _handleLinkTap(context, 'Termos de Serviço'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exemplo 2: Política de privacidade
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacidade',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Leia nossa Política de Privacidade para saber mais',
                        linkedText: 'Política de Privacidade',
                        onLinkTap: () => _handleLinkTap(context, 'Política de Privacidade'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exemplo 3: Criar conta
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Novo Usuário',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Não tem uma conta? Cadastre-se aqui',
                        linkedText: 'Cadastre-se aqui',
                        onLinkTap: () => _handleLinkTap(context, 'Cadastro'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exemplo 4: Recuperar senha
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Esqueceu a Senha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Esqueceu sua senha? Clique aqui para recuperar',
                        linkedText: 'Clique aqui',
                        onLinkTap: () => _handleLinkTap(context, 'Recuperar Senha'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exemplo 5: Suporte
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ajuda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Precisa de ajuda? Contate nosso suporte',
                        linkedText: 'suporte',
                        onLinkTap: () => _handleLinkTap(context, 'Suporte'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exemplo 6: Múltiplas palavras no link
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saiba Mais',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DSLinkedLabel(
                      viewModel: LinkedLabelViewModel(
                        text: 'Visite nossa Central de Ajuda para mais informações',
                        linkedText: 'Central de Ajuda',
                        onLinkTap: () => _handleLinkTap(context, 'Central de Ajuda'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle('Exemplo de Formulário de Login'),
            const SizedBox(height: 16),
            
            // Formulário de Login usando LinkedLabel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    DSInput(
                      viewModel: InputViewModel(
                        controller: TextEditingController(),
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DSInput(
                      viewModel: InputViewModel(
                        controller: TextEditingController(),
                        placeholder: 'Senha',
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: DSLinkedLabel(
                        viewModel: LinkedLabelViewModel(
                          text: 'Esqueceu a senha?',
                          linkedText: 'Esqueceu a senha?',
                          onLinkTap: () => _handleLinkTap(context, 'Recuperar Senha'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DSButton(
                      viewModel: ButtonViewModel(
                        text: 'Entrar',
                        variant: ButtonVariant.primary,
                        fullWidth: true,
                        onPressed: () => _handleLinkTap(context, 'Entrar'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: DSLinkedLabel(
                        viewModel: LinkedLabelViewModel(
                          text: 'Não tem uma conta? Cadastre-se',
                          linkedText: 'Cadastre-se',
                          onLinkTap: () => _handleLinkTap(context, 'Cadastro'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: DSLinkedLabel(
                        viewModel: LinkedLabelViewModel(
                          text: 'Ao entrar, você concorda com nossos Termos de Uso',
                          linkedText: 'Termos de Uso',
                          onLinkTap: () => _handleLinkTap(context, 'Termos'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
