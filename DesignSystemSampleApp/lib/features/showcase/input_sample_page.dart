import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// Página de exemplo para demonstrar o uso do componente Input
class InputSamplePage extends StatefulWidget {
  const InputSamplePage({super.key});

  @override
  State<InputSamplePage> createState() => _InputSamplePageState();
}

class _InputSamplePageState extends State<InputSamplePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Component Samples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Inputs Básicos'),
            const SizedBox(height: 16),
            
            // Email Input
            DSInput(
              viewModel: InputViewModel(
                controller: _emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Password Input
            DSInput(
              viewModel: InputViewModel(
                controller: _passwordController,
                placeholder: 'Senha',
                isPassword: true,
                validator: _validatePassword,
                prefixIcon: const Icon(Icons.lock_outlined),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle('Com Prefixos e Sufixos'),
            const SizedBox(height: 16),
            
            // Name Input with prefix
            DSInput(
              viewModel: InputViewModel(
                controller: _nameController,
                placeholder: 'Nome completo',
                prefixIcon: const Icon(Icons.person_outlined),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Phone Input
            DSInput(
              viewModel: InputViewModel(
                controller: _phoneController,
                placeholder: 'Telefone',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Search Input
            DSInput(
              viewModel: InputViewModel(
                controller: _searchController,
                placeholder: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle('Multilinha'),
            const SizedBox(height: 16),
            
            // Multiline Input
            DSInput(
              viewModel: InputViewModel(
                controller: _bioController,
                placeholder: 'Bio',
                maxLines: 4,
                minLines: 4,
                helperText: 'Conte um pouco sobre você',
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle('Estados Especiais'),
            const SizedBox(height: 16),
            
            // Disabled Input
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(text: 'Input desabilitado'),
                placeholder: 'Desabilitado',
                isEnabled: false,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Input with error
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(),
                placeholder: 'Input com erro',
                errorText: 'Este campo tem um erro',
                prefixIcon: const Icon(Icons.error_outline),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Input with helper text
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(),
                placeholder: 'Input com ajuda',
                helperText: 'Este é um texto de ajuda',
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSectionTitle('Tipos de Teclado'),
            const SizedBox(height: 16),
            
            // Number Input
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(),
                placeholder: 'Número',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // URL Input
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(),
                placeholder: 'Website',
                keyboardType: TextInputType.url,
                prefixIcon: const Icon(Icons.link),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Email Input
            DSInput(
              viewModel: InputViewModel(
                controller: TextEditingController(),
                placeholder: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.alternate_email),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Submeter Formulário',
                variant: ButtonVariant.primary,
                fullWidth: true,
                icon: Icons.check,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulário submetido!'),
                    ),
                  );
                },
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
