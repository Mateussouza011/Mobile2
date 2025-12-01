import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_form.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
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
        actions: const [ThemeToggleButton(size: 36), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
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
          _buildSection(
            context,
            'Estados dos Inputs',
            'Diferentes estados visuais e de interação',
            [
              const SizedBox(height: 20),
              const ShadcnInput(
                label: 'Estado Normal',
                placeholder: 'Campo normal',
                helperText: 'Este campo está em estado normal',
              ),
              const SizedBox(height: 16),
              ShadcnInput(
                label: 'Estado Desabilitado',
                controller: _disabledController,
                enabled: false,
                helperText: 'Este campo está desabilitado',
              ),
              const SizedBox(height: 16),
              const ShadcnInput(
                label: 'Estado de Erro',
                placeholder: 'Campo com erro',
                errorText: 'Este campo contém um erro',
              ),
              const SizedBox(height: 16),
              const ShadcnInput(
                label: 'Comentários',
                placeholder: 'Digite seus comentários...',
                maxLines: 4,
                helperText: 'Máximo de 500 caracteres',
              ),
            ],
          ),
        ],
      ),
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