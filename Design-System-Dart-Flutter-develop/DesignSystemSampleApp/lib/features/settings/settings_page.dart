import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';

/// Página de configurações do aplicativo
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Português';
  final List<String> _languages = ['Português', 'English', 'Español'];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
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
          // Descrição
          Text(
            'Personalize a aparência e comportamento do aplicativo.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Seção Aparência
          _buildSection(
            context,
            'Aparência',
            'Configure o tema visual do aplicativo',
            [
              const SizedBox(height: 16),
              
              // Switch do tema
              ShadcnCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        themeProvider.isDarkMode 
                            ? Icons.dark_mode 
                            : Icons.light_mode,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tema Escuro',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              themeProvider.isDarkMode 
                                  ? 'Modo escuro ativado'
                                  : 'Modo claro ativado',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                          _showMessage(
                            context,
                            value ? 'Tema escuro ativado!' : 'Tema claro ativado!',
                          );
                        },
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Preview do tema atual
              ShadcnCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.preview,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Preview do Tema',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Título Principal',
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Este é um exemplo de como o texto aparece no tema atual. '
                              'Observe o contraste e a legibilidade.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Botão de Exemplo',
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Seção Idioma
          _buildSection(
            context,
            'Idioma',
            'Selecione o idioma da interface',
            [
              const SizedBox(height: 16),
              
              ShadcnCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Idioma da Interface',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Idioma selecionado: $_selectedLanguage',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedLanguage = newValue;
                            });
                            _showMessage(
                              context,
                              'Idioma alterado para: $newValue',
                            );
                          }
                        },
                        underline: Container(),
                        dropdownColor: colorScheme.surface,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        items: _languages.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Seção Informações
          _buildSection(
            context,
            'Sobre',
            'Informações do aplicativo',
            [
              const SizedBox(height: 16),
              
              ShadcnCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        Icons.info_outline,
                        'Versão',
                        '1.0.0',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.palette_outlined,
                        'Design System',
                        'Shadcn/UI',
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.code,
                        'Framework',
                        'Flutter',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    themeProvider.setTheme(ThemeMode.system);
                    _showMessage(context, 'Configurações restauradas!');
                  },
                  icon: Icon(
                    Icons.restore,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  label: Text(
                    'Restaurar Padrão',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.outline),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showMessage(context, 'Configurações salvas com sucesso!');
                  },
                  icon: Icon(
                    Icons.save,
                    color: colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Salvar',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    List<Widget> children,
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
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
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