import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_form.dart';
import '../../ui/widgets/shadcn/shadcn_select.dart';
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

import '../../design_system/components/component_showcase_scaffold.dart';
import '../../design_system/components/input/input_view_model.dart';

class InputsPage extends StatelessWidget {
  const InputsPage({super.key});

  @override
<<<<<<< Updated upstream
  Widget build(BuildContext context) {
    return ComponentShowcaseScaffold(
      category: InputComponentLibrary.category,
=======
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _disabledController = TextEditingController(text: 'Campo desabilitado');
  bool _obscurePassword = true;
  String? _selectedCountry;
  String? _selectedCity;

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
          'Inputs',
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
              
              const ShadcnCepInput(
                placeholder: '00000-000',
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Dropdowns
          _buildSection(
            context,
            'Dropdowns',
            'Selects e menus suspensos com busca',
            [
              const SizedBox(height: 20),
              ShadcnSelect<String>(
                label: 'Selecione um País',
                placeholder: 'Escolha um país',
                value: _selectedCountry,
                prefixIcon: const Icon(Icons.public),
                options: const [
                  ShadcnSelectOption(
                    value: 'br',
                    label: 'Brasil',
                    icon: Text('🇧🇷'),
                  ),
                  ShadcnSelectOption(
                    value: 'us',
                    label: 'Estados Unidos',
                    icon: Text('🇺🇸'),
                  ),
                  ShadcnSelectOption(
                    value: 'uk',
                    label: 'Reino Unido',
                    icon: Text('🇬🇧'),
                  ),
                  ShadcnSelectOption(
                    value: 'fr',
                    label: 'França',
                    icon: Text('🇫🇷'),
                  ),
                  ShadcnSelectOption(
                    value: 'de',
                    label: 'Alemanha',
                    icon: Text('🇩🇪'),
                  ),
                  ShadcnSelectOption(
                    value: 'jp',
                    label: 'Japão',
                    icon: Text('🇯🇵'),
                  ),
                  ShadcnSelectOption(
                    value: 'ca',
                    label: 'Canadá',
                    icon: Text('🇨🇦'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              ShadcnSelect<String>(
                label: 'Cidade com Busca',
                placeholder: 'Selecione uma cidade',
                value: _selectedCity,
                searchable: true,
                searchHint: 'Digite para buscar...',
                prefixIcon: const Icon(Icons.location_city),
                helperText: 'Use a busca para encontrar rapidamente',
                options: const [
                  ShadcnSelectOption(value: 'sp', label: 'São Paulo'),
                  ShadcnSelectOption(value: 'rj', label: 'Rio de Janeiro'),
                  ShadcnSelectOption(value: 'bh', label: 'Belo Horizonte'),
                  ShadcnSelectOption(value: 'bsb', label: 'Brasília'),
                  ShadcnSelectOption(value: 'salvador', label: 'Salvador'),
                  ShadcnSelectOption(value: 'fortaleza', label: 'Fortaleza'),
                  ShadcnSelectOption(value: 'curitiba', label: 'Curitiba'),
                  ShadcnSelectOption(value: 'recife', label: 'Recife'),
                  ShadcnSelectOption(value: 'porto_alegre', label: 'Porto Alegre'),
                  ShadcnSelectOption(value: 'manaus', label: 'Manaus'),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              const ShadcnSelect<String>(
                label: 'Dropdown Desabilitado',
                placeholder: 'Campo não editável',
                enabled: false,
                prefixIcon: Icon(Icons.lock_outline),
                options: [
                  ShadcnSelectOption(value: '1', label: 'Opção 1'),
                  ShadcnSelectOption(value: '2', label: 'Opção 2'),
                ],
                helperText: 'Este campo está desabilitado',
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
          
          // Validações Customizadas
          _buildAdvancedInputs(context),
        ],
      ),
    );
  }

  Widget _buildAdvancedInputs(BuildContext context) {
    return _buildSection(
      context,
      'Validações Customizadas',
      'Inputs com validações personalizadas em tempo real',
      [
        const SizedBox(height: 20),
        
        // Input com validação customizada de CEP
        ShadcnInput(
          label: 'CEP',
          placeholder: '00000-000',
          inputType: ShadcnInputType.text,
          prefixIcon: const Icon(Icons.location_on),
          helperText: 'Validação automática de formato',
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
>>>>>>> Stashed changes
    );
  }
}