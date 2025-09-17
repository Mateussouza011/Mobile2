import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';

/// Página de configurações do aplicativo
/// Permite alternar tema e selecionar idioma
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: textTheme.titleLarge?.copyWith(
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
          // Introdução
          Text(
            'Personalize sua experiência',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure o tema e idioma de acordo com suas preferências.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Seção Aparência
          _buildSettingsSection(
            context,
            'Aparência',
            'Controle a aparência visual do aplicativo',
            [
              _buildThemeCard(context),
              const SizedBox(height: 16),
              _buildThemeToggle(context),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Seção Idioma
          _buildSettingsSection(
            context,
            'Idioma e Região',
            'Selecione seu idioma preferido',
            [
              _buildLanguageCard(context),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Seção Preview
          _buildSettingsSection(
            context,
            'Preview do Tema',
            'Visualize como o tema atual aparece',
            [
              _buildThemePreview(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, 
    String title, 
    String description, 
    List<Widget> children
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ShadcnCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Modo ${themeProvider.isDarkMode ? 'Escuro' : 'Claro'}',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                themeProvider.isDarkMode 
                  ? 'Interface escura para ambientes com pouca luz'
                  : 'Interface clara para máxima legibilidade',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              
              // Indicadores visuais do tema
              Row(
                children: [
                  // Amostra de cor primária
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Primária',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Amostra de cor secundária
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Secundária',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ShadcnCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alternar Tema',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Trocar entre modo claro e escuro',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Switch personalizado com cores Shadcn
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                  _showThemeChangeMessage(context, themeProvider.isDarkMode);
                },
                activeColor: colorScheme.primary,
                activeTrackColor: colorScheme.primary.withOpacity(0.3),
                inactiveThumbColor: colorScheme.onSurfaceVariant,
                inactiveTrackColor: colorScheme.surfaceVariant,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ShadcnCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Idioma do Aplicativo',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Dropdown de idiomas
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: themeProvider.selectedLanguage,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        themeProvider.setLanguage(newValue);
                        _showLanguageChangeMessage(context, newValue);
                      }
                    },
                    items: themeProvider.availableLanguages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor: colorScheme.surface,
                    iconEnabledColor: colorScheme.onSurfaceVariant,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Reinicie o aplicativo para aplicar o novo idioma',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview do Design System',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Exemplo de título
          Text(
            'Título Principal',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Exemplo de subtítulo
          Text(
            'Este é um subtítulo que demonstra a tipografia secundária do aplicativo.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          // Exemplo de texto corpo
          Text(
            'Texto do corpo principal com boa legibilidade e contraste adequado para leitura confortável em qualquer tema.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          
          // Indicadores de contraste
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✅ Contraste Verificado',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Todos os textos atendem aos padrões de acessibilidade WCAG.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeChangeMessage(BuildContext context, bool isDarkMode) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tema alterado para ${isDarkMode ? 'escuro' : 'claro'}',
          style: TextStyle(
            color: colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageChangeMessage(BuildContext context, String language) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Idioma alterado para $language',
          style: TextStyle(
            color: colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
