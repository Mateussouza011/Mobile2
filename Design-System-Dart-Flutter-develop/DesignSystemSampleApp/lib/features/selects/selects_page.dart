import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_select.dart';

class SelectsPage extends StatefulWidget {
  const SelectsPage({super.key});

  @override
  State<SelectsPage> createState() => _SelectsPageState();
}

class _SelectsPageState extends State<SelectsPage> {
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedLanguage;
  String? _selectedFramework;

  final List<ShadcnSelectOption<String>> _countries = [
    ShadcnSelectOption(
      value: 'br', 
      label: 'Brasil',
      icon: Icon(Icons.flag, size: 16),
    ),
    ShadcnSelectOption(
      value: 'us', 
      label: 'Estados Unidos',
      icon: Icon(Icons.flag, size: 16),
    ),
    ShadcnSelectOption(
      value: 'ca', 
      label: 'Canadá',
      icon: Icon(Icons.flag, size: 16),
    ),
    ShadcnSelectOption(
      value: 'mx', 
      label: 'México',
      icon: Icon(Icons.flag, size: 16),
    ),
  ];

  final List<ShadcnSelectOption<String>> _cities = [
    ShadcnSelectOption(value: 'sp', label: 'São Paulo'),
    ShadcnSelectOption(value: 'rj', label: 'Rio de Janeiro'),
    ShadcnSelectOption(value: 'mg', label: 'Belo Horizonte'),
    ShadcnSelectOption(value: 'rs', label: 'Porto Alegre'),
    ShadcnSelectOption(value: 'pr', label: 'Curitiba'),
  ];

  final List<ShadcnSelectOption<String>> _languages = [
    ShadcnSelectOption(
      value: 'pt', 
      label: 'Português',
      icon: Icon(Icons.language, size: 16),
    ),
    ShadcnSelectOption(
      value: 'en', 
      label: 'English',
      icon: Icon(Icons.language, size: 16),
    ),
    ShadcnSelectOption(
      value: 'es', 
      label: 'Español',
      icon: Icon(Icons.language, size: 16),
    ),
    ShadcnSelectOption(
      value: 'fr', 
      label: 'Français',
      icon: Icon(Icons.language, size: 16),
    ),
    ShadcnSelectOption(
      value: 'de', 
      label: 'Deutsch',
      icon: Icon(Icons.language, size: 16),
    ),
  ];

  final List<ShadcnSelectOption<String>> _frameworks = [
    ShadcnSelectOption(value: 'flutter', label: 'Flutter'),
    ShadcnSelectOption(value: 'react', label: 'React'),
    ShadcnSelectOption(value: 'vue', label: 'Vue.js'),
    ShadcnSelectOption(value: 'angular', label: 'Angular'),
    ShadcnSelectOption(value: 'svelte', label: 'Svelte'),
    ShadcnSelectOption(value: 'next', label: 'Next.js'),
    ShadcnSelectOption(value: 'nuxt', label: 'Nuxt.js'),
    ShadcnSelectOption(value: 'gatsby', label: 'Gatsby'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selects',
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
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Básico',
            '',
            [
              const SizedBox(height: 20),
              ShadcnSelect<String>(
                label: 'País',
                placeholder: 'Selecione um país',
                options: _countries,
                value: _selectedCountry,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                prefixIcon: Icon(Icons.public, size: 20),
              ),
              
              const SizedBox(height: 16),
              
              ShadcnSelect<String>(
                label: 'Cidade',
                placeholder: 'Selecione uma cidade',
                options: _cities,
                value: _selectedCity,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                helperText: 'Escolha sua cidade atual',
                prefixIcon: Icon(Icons.location_city, size: 20),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Com Busca',
            '',
            [
              const SizedBox(height: 20),
              ShadcnSelect<String>(
                label: 'Idioma',
                placeholder: 'Selecione um idioma',
                options: _languages,
                value: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                searchable: true,
                searchHint: 'Buscar idioma...',
                helperText: 'Use a busca para encontrar rapidamente',
              ),
              
              const SizedBox(height: 16),
              
              ShadcnSelect<String>(
                label: 'Framework',
                placeholder: 'Selecione um framework',
                options: _frameworks,
                value: _selectedFramework,
                onChanged: (value) {
                  setState(() {
                    _selectedFramework = value;
                  });
                },
                searchable: true,
                searchHint: 'Buscar framework...',
                prefixIcon: Icon(Icons.code, size: 20),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Estados',
            '',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Normal',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShadcnSelect<String>(
                          placeholder: 'Selecione uma opção',
                          options: _countries.take(3).toList(),
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Com Erro',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShadcnSelect<String>(
                          placeholder: 'Selecione uma opção',
                          options: _countries.take(3).toList(),
                          errorText: 'Este campo é obrigatório',
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desabilitado',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShadcnSelect<String>(
                          placeholder: 'Opção desabilitada',
                          options: _countries.take(3).toList(),
                          enabled: false,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Tamanhos',
            '',
            [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Largura Personalizada', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  ShadcnSelect<String>(
                    placeholder: 'Select pequeno',
                    options: _countries.take(3).toList(),
                    width: 200,
                    onChanged: (value) {},
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text('Largura Total', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  ShadcnSelect<String>(
                    placeholder: 'Select em largura total',
                    options: _frameworks.take(4).toList(),
                    onChanged: (value) {},
                  ),
                ],
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
        ...children,
      ],
    );
  }
}