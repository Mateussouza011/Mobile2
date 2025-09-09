import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra diferentes tipos de inputs Shadcn/UI
class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Campo de Texto',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Descrição
            Text(
              'Exibe um campo de entrada de formulário ou um componente que parece um campo de entrada.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            
            // Input simples
            ShadcnInput(
              controller: _emailController,
              placeholder: 'Email',
              onChanged: (value) {
                if (value.length > 5 && value.contains('@')) {
                  _showMessage(context, 'Formato de email válido!');
                }
              },
            ),
            
            const SizedBox(height: 32),
            
            // Diferentes tipos de input
            _buildSection(
              context,
              'Exemplos',
              [
                const SizedBox(height: 16),
                ShadcnInput(
                  controller: _nameController,
                  label: 'Nome',
                  placeholder: 'Digite seu nome',
                  helperText: 'Este é seu nome de exibição público.',
                  onChanged: (value) {
                    if (value.length >= 3) {
                      _showMessage(context, 'Olá, $value! 👋');
                    }
                  },
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  controller: _emailController,
                  label: 'Email',
                  placeholder: 'Email',
                  inputType: ShadcnInputType.email,
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  controller: _passwordController,
                  label: 'Senha',
                  placeholder: 'Senha',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Input com validação
            _buildSection(
              context,
              'Com Validação',
              [
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'Nome de Usuário',
                  placeholder: 'Nome de usuário',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome de usuário é obrigatório';
                    }
                    if (value.length < 3) {
                      return 'Nome de usuário deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'Email',
                  placeholder: 'Digite seu email',
                  inputType: ShadcnInputType.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor digite um email válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Input desabilitado
            _buildSection(
              context,
              'Desabilitado',
              [
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Campo Desabilitado',
                  placeholder: 'Este campo está desabilitado',
                  enabled: false,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Input com ícones
            _buildSection(
              context,
              'Com Ícones',
              [
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Pesquisar',
                  placeholder: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search, size: 16),
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'Email',
                  placeholder: 'Email',
                  prefixIcon: const Icon(Icons.mail, size: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 16),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Textarea
            _buildSection(
              context,
              'Área de Texto',
              [
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Mensagem',
                  placeholder: 'Digite sua mensagem aqui.',
                  maxLines: 4,
                  helperText: 'Sua mensagem será copiada para a equipe de suporte.',
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Input com label e helper
            _buildSection(
              context,
              'Com Rótulo e Ajuda',
              [
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Primeiro Nome',
                  placeholder: 'Digite seu primeiro nome',
                  helperText: 'Este é o nome que será exibido no seu perfil.',
                ),
                const SizedBox(height: 16),
                const ShadcnInput(
                  label: 'Biografia',
                  placeholder: 'Conte-nos um pouco sobre você',
                  maxLines: 3,
                  helperText: 'Você pode @mencionar outros usuários e organizações.',
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Form example
            _buildSection(
              context,
              'Exemplo de Formulário',
              [
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'Nome do Projeto',
                  placeholder: 'Digite o nome do projeto',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome do projeto é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ShadcnInput(
                  label: 'Descrição',
                  placeholder: 'Descrição do projeto',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descrição é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ShadcnButton(
                        text: 'Cancelar',
                        variant: ShadcnButtonVariant.outline,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShadcnButton(
                        text: 'Criar Projeto',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Projeto criado com sucesso!',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...children,
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
