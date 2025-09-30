import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_input.dart';
import '../../ui/widgets/shadcn/shadcn_form.dart';
import '../../ui/widgets/shadcn/shadcn_file_upload.dart';
import '../../ui/widgets/shadcn/shadcn_slider.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _formKey = GlobalKey<FormState>();
  final _disabledController = TextEditingController(text: 'Campo desabilitado');
  bool _obscurePassword = true;
  double _volumeValue = 50.0;
  double _temperatureValue = 22.0;
  RangeValues _priceRange = const RangeValues(100, 500);

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
              
              ShadcnInput.email(
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
              
              ShadcnInput.search(
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
              ShadcnCpfInput(
                placeholder: '000.000.000-00',
              ),
              const SizedBox(height: 16),
              
              ShadcnCnpjInput(
                placeholder: '00.000.000/0000-00',
              ),
              const SizedBox(height: 16),
              
              ShadcnPhoneInput(
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
              ShadcnInput(
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
              ShadcnInput(
                label: 'Estado de Erro',
                placeholder: 'Campo com erro',
                errorText: 'Este campo contém um erro',
              ),
              const SizedBox(height: 16),
              
              // Área de texto
              ShadcnInput(
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
                    ShadcnFormField(
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
                      prefixIcon: Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value != null && !value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ShadcnFormField(
                      name: 'telefone',
                      label: 'Telefone',
                      placeholder: '(00) 00000-0000',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ShadcnButton(
                            text: 'Limpar',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {
                              _formKey.currentState?.reset();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ShadcnButton(
                            text: 'Validar',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Formulário válido!')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Upload de Arquivos
          _buildSection(
            context,
            'Upload de Arquivos',
            'Componentes para seleção e upload de arquivos',
            [
              const SizedBox(height: 20),
              ShadcnFileUpload(
                label: 'Upload Simples',
                description: 'Selecione um arquivo para upload',
                type: ShadcnFileUploadType.single,
                acceptedFileTypes: ['pdf', 'jpg', 'png', 'docx'],
                maxFileSize: 5,
                onFileSelected: (file) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Arquivo selecionado: ${file.path}')),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              ShadcnFileUpload(
                label: 'Upload Múltiplo',
                description: 'Arraste e solte ou clique para selecionar múltiplos arquivos',
                type: ShadcnFileUploadType.dragDrop,
                maxFiles: 5,
                maxFileSize: 10,
                onFilesSelected: (files) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${files.length} arquivo(s) selecionado(s)')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Sliders e Controles
          _buildSection(
            context,
            'Sliders e Controles',
            'Controles deslizantes para valores numéricos',
            [
              const SizedBox(height: 20),
              ShadcnVolumeSlider(
                value: _volumeValue,
                onChanged: (value) {
                  setState(() {
                    _volumeValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ShadcnTemperatureSlider(
                value: _temperatureValue,
                onChanged: (value) {
                  setState(() {
                    _temperatureValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              ShadcnPriceRangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000,
                onChanged: (values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Slider customizado
              ShadcnSlider.single(
                value: 75,
                onChanged: (value) {},
                min: 0,
                max: 100,
                divisions: 10,
                label: 'Progresso',
                labelFormatter: (value) => '${value.toInt()}%',
                showTicks: true,
                leadingWidget: Icon(Icons.speed, color: colorScheme.primary),
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          // Variantes Visuais
          _buildSection(
            context,
            'Variantes Visuais',
            'Diferentes estilos e tamanhos de inputs',
            [
              const SizedBox(height: 20),
              
              // Tamanhos
              Text(
                'Tamanhos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              ShadcnInput(
                label: 'Pequeno',
                placeholder: 'Input pequeno',
                size: ShadcnInputSize.sm,
              ),
              const SizedBox(height: 16),
              
              ShadcnInput(
                label: 'Padrão',
                placeholder: 'Input padrão',
                size: ShadcnInputSize.default_,
              ),
              const SizedBox(height: 16),
              
              ShadcnInput(
                label: 'Grande',
                placeholder: 'Input grande',
                size: ShadcnInputSize.lg,
              ),
              const SizedBox(height: 24),
              
              // Variantes
              Text(
                'Estilos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              ShadcnInput(
                label: 'Outlined (Padrão)',
                placeholder: 'Input com borda',
                variant: ShadcnInputVariant.outlined,
              ),
              const SizedBox(height: 16),
              
              ShadcnInput(
                label: 'Filled',
                placeholder: 'Input preenchido',
                variant: ShadcnInputVariant.filled,
              ),
              const SizedBox(height: 16),
              
              ShadcnInput(
                label: 'Underlined',
                placeholder: 'Input com linha',
                variant: ShadcnInputVariant.underlined,
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