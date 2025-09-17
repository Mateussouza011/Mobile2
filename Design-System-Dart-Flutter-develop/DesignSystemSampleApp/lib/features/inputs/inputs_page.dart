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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _disabledController = TextEditingController(text: 'Campo desabilitado');
  
  bool _obscurePassword = true;
  bool _isFormSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _disabledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Showcase de Inputs',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Descrição
          Text(
            'Demonstração completa dos inputs Shadcn/UI com validação e diferentes estados.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Inputs Básicos
          _buildSection(
            context,
            'Tipos de Input',
            'Inputs básicos: texto, email, senha com toggle de visibilidade',
            [
              const SizedBox(height: 20),
              ShadcnInput(
                label: 'Texto Simples',
                placeholder: 'Digite qualquer texto',
                helperText: 'Campo de texto livre sem validação',
                onChanged: (value) {
                  if (value.isNotEmpty && value.length == 1) {
                    _showMessage(context, 'Começou a digitar!');
                  }
                },
              ),
              const SizedBox(height: 20),
              
              ShadcnInput.email(
                label: 'Email',
                placeholder: 'exemplo@email.com',
                helperText: 'Validação automática de formato de email',
              ),
              const SizedBox(height: 20),
              
              ShadcnInput(
                label: 'Senha',
                placeholder: 'Digite sua senha',
                obscureText: _obscurePassword,
                helperText: 'Clique no ícone para mostrar/ocultar',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                    _showMessage(context, _obscurePassword ? 'Senha oculta' : 'Senha visível');
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Estados dos Inputs
          _buildSection(
            context,
            'Estados dos Inputs',
            'Demonstração de estados: normal, focus, error e disabled',
            [
              const SizedBox(height: 20),
              
              // Estado normal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Normal',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShadcnInput(
                      placeholder: 'Campo em estado normal',
                      helperText: 'Texto visível em ambos os temas',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Estado desabilitado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Desabilitado',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShadcnInput(
                      controller: _disabledController,
                      enabled: false,
                      helperText: 'Campo desabilitado com texto visível',
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Exemplo de Formulário
          _buildSection(
            context,
            'Formulário Completo',
            'Exemplo prático: Nome + Email + Botão "Enviar" com validação',
            [
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cadastro de Usuário',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Campo Nome
                      ShadcnInput(
                        controller: _nameController,
                        label: 'Nome Completo',
                        placeholder: 'Digite seu nome completo',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          if (value.length < 2) {
                            return 'Nome deve ter pelo menos 2 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Campo Email
                      ShadcnInput(
                        controller: _emailController,
                        label: 'Email',
                        placeholder: 'seuemail@exemplo.com',
                        inputType: ShadcnInputType.email,
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email é obrigatório';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Digite um email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Campo Senha do Formulário
                      ShadcnInput(
                        controller: _passwordController,
                        label: 'Senha',
                        placeholder: 'Crie uma senha segura',
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colorScheme.onSurfaceVariant,
                        ),
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
                      const SizedBox(height: 24),
                      
                      // Botões do formulário
                      Row(
                        children: [
                          Expanded(
                            child: ShadcnButton(
                              text: 'Limpar',
                              variant: ShadcnButtonVariant.outline,
                              onPressed: _isFormSubmitting ? null : () {
                                _nameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _showMessage(context, 'Formulário limpo!');
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ShadcnButton(
                              text: _isFormSubmitting ? 'Enviando...' : 'Enviar',
                              loading: _isFormSubmitting,
                              onPressed: _isFormSubmitting ? null : _submitForm,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Teste de Visibilidade
          _buildSection(
            context,
            'Teste de Visibilidade',
            'Verificação de legibilidade em temas claro e escuro',
            [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Todos os textos abaixo devem estar visíveis:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ShadcnInput(
                      placeholder: 'Placeholder visível no tema atual',
                      helperText: 'Texto de ajuda visível',
                    ),
                    const SizedBox(height: 16),
                    
                    ShadcnInput(
                      label: 'Label visível',
                      placeholder: 'Input com label',
                      prefixIcon: Icon(
                        Icons.visibility,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ShadcnInput(
                      enabled: false,
                      placeholder: 'Campo desabilitado visível',
                      helperText: 'Texto de ajuda para campo desabilitado',
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Inputs Avançados
          _buildSection(
            context,
            'Inputs Avançados',
            'Busca, área de texto e inputs com ícones',
            [
              const SizedBox(height: 20),
              
              // Input de busca
              ShadcnInput.search(
                placeholder: 'Buscar qualquer coisa...',
                onChanged: (value) {
                  if (value.length > 2) {
                    _showMessage(context, 'Buscando: $value');
                  }
                },
              ),
              const SizedBox(height: 20),
              
              // Área de texto
              ShadcnInput(
                label: 'Comentários',
                placeholder: 'Digite seus comentários aqui...',
                maxLines: 4,
                helperText: 'Área de texto expandida para comentários longos',
              ),
              const SizedBox(height: 20),
              
              // Input com ícones múltiplos
              ShadcnInput(
                label: 'Localização',
                placeholder: 'Digite sua cidade',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    _showMessage(context, 'Detectando localização...');
                  },
                ),
                helperText: 'Clique no ícone para detectar automaticamente',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isFormSubmitting = true;
      });
      
      // Simular envio
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isFormSubmitting = false;
      });
      
      _showMessage(context, 'Cadastro realizado com sucesso! ✅');
      
      // Limpar formulário após sucesso
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    } else {
      _showMessage(context, 'Por favor, corrija os erros no formulário');
    }
  }

  Widget _buildSection(BuildContext context, String title, String description, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        ...children,
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}