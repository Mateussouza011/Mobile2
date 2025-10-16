import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_form.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _formKey = GlobalKey<FormState>();
  final _disabledController = TextEditingController(text: 'Campo desabilitado');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _disabledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inputs & Forms',
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
          // Inputs Básicos
          _buildSection(
            context,
            'Inputs Básicos',
            'Diferentes tipos e variações de campos de entrada',
            [
              const SizedBox(height: 20),
              ShadcnInput(
                label: 'Nome Completo',
                placeholder: 'Digite seu nome...',
                prefixIcon: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              
              const ShadcnInput.email(
                label: 'Email',
                placeholder: 'exemplo@email.com',
              ),
              const SizedBox(height: 16),
              
              ShadcnInput(
                label: 'Senha',
                placeholder: 'Digite sua senha',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              const ShadcnInput.search(
                placeholder: 'Buscar produtos...',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Campos com Máscara
          _buildSection(
            context,
            'Campos com Máscara',
            'Inputs especializados com formatação automática',
            [
              const SizedBox(height: 20),
              const ShadcnCpfInput(
                placeholder: '000.000.000-00',
              ),
              const SizedBox(height: 16),
              
              const ShadcnCnpjInput(
                placeholder: '00.000.000/0000-00',
              ),
              const SizedBox(height: 16),
              
              const ShadcnPhoneInput(
                placeholder: '(00) 00000-0000',
              ),
              const SizedBox(height: 16),
              
              ShadcnCepInput(
                placeholder: '00000-000',
                onAddressFound: (address) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Endereço encontrado: ${address['street']}'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Estados dos Inputs
          _buildSection(
            context,
            'Estados dos Inputs',
            'Diferentes estados visuais e de interação',
            [
              const SizedBox(height: 20),
              
              // Normal
              const ShadcnInput(
                label: 'Estado Normal',
                placeholder: 'Campo normal',
                helperText: 'Este campo está em estado normal',
              ),
              const SizedBox(height: 16),
              
              // Desabilitado
              ShadcnInput(
                label: 'Estado Desabilitado',
                controller: _disabledController,
                enabled: false,
                helperText: 'Este campo está desabilitado',
              ),
              const SizedBox(height: 16),
              
              // Com erro
              const ShadcnInput(
                label: 'Estado de Erro',
                placeholder: 'Campo com erro',
                errorText: 'Este campo contém um erro',
              ),
              const SizedBox(height: 16),
              
              // Área de texto
              const ShadcnInput(
                label: 'Comentários',
                placeholder: 'Digite seus comentários...',
                maxLines: 4,
                helperText: 'Máximo de 500 caracteres',
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Formulário Completo
          _buildSection(
            context,
            'Formulário Completo',
            'Exemplo de formulário com validação',
            [
              const SizedBox(height: 20),
              ShadcnForm(
                formKey: _formKey,
                child: Column(
                  children: [
                    const ShadcnFormField(
                      name: 'nome',
                      label: 'Nome',
                      placeholder: 'Digite seu nome',
                      required: true,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
                    
                    ShadcnFormField(
                      name: 'email',
                      label: 'Email',
                      placeholder: 'Digite seu email',
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value != null && !value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    const ShadcnFormField(
                      name: 'telefone',
                      label: 'Telefone',
                      placeholder: '(00) 00000-0000',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Inputs Avançados
          _buildAdvancedInputs(context),
        ],
      ),
    );
  }

  Widget _buildAdvancedInputs(BuildContext context) {
    return _buildSection(
      context,
      'Inputs Avançados',
      'Inputs especializados com validações customizadas',
      [
        const SizedBox(height: 20),
        
        // Input padrão simples
        const ShadcnInput(
          label: 'Nome',
          placeholder: 'Digite seu nome',
        ),
        const SizedBox(height: 16),
        
        // Input para email com validação automática
        const ShadcnInput.email(
          label: 'Email',
        ),
        const SizedBox(height: 16),
        
        // Input para senha com toggle automático
        const ShadcnInput.password(
          label: 'Senha',
          helperText: 'Mínimo 8 caracteres',
        ),
        const SizedBox(height: 16),
        
        // Input de busca
        const ShadcnInput.search(
          placeholder: 'Buscar...',
        ),
        const SizedBox(height: 16),
        
        // Input com ícones
        const ShadcnInput(
          label: 'Localização',
          placeholder: 'Digite seu endereço',
          prefixIcon: Icon(Icons.location_on),
        ),
        const SizedBox(height: 16),
        
        // Input com validação customizada
        ShadcnInput(
          label: 'CEP',
          placeholder: '00000-000',
          inputType: ShadcnInputType.text,
          prefixIcon: const Icon(Icons.location_on),
          customValidator: (value) {
            if (value == null || value.isEmpty) return null;
            final cepRegex = RegExp(r'^\d{5}-?\d{3}$');
            if (!cepRegex.hasMatch(value)) {
              return 'CEP inválido. Use o formato 00000-000';
            }
            return null;
          },
          validateOnChange: true,
        ),
      ],
    );
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
        if (description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        ...children,
      ],
    );
  }
}