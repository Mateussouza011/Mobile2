import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Componentes Shadcn/UI',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tema alterado para ${themeProvider.isDarkMode ? 'escuro' : 'claro'}',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                tooltip: themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Escuro',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cabeçalho centralizado
              Text(
                'Biblioteca de Componentes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Lista de botões centralizados
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    _buildListButton(
                      context,
                      'Botão',
                      Icons.smart_button,
                      () => context.go('/buttons'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Campo de Texto',
                      Icons.text_fields,
                      () => context.go('/inputs'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Cartão',
                      Icons.view_agenda,
                      () => context.go('/cards'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Cards e Listas',
                      Icons.list_alt,
                      () => context.go('/cards-and-lists'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Tabela',
                      Icons.table_chart,
                      () => context.go('/tables'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Controle Deslizante',
                      Icons.tune,
                      () => context.go('/sliders'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Diálogo',
                      Icons.web_asset,
                      () => context.go('/modals'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Badges',
                      Icons.label,
                      () => context.go('/badges'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Progress',
                      Icons.linear_scale,
                      () => context.go('/progress'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Avatars',
                      Icons.account_circle,
                      () => context.go('/avatars'),
                    ),
                    const SizedBox(height: 32),
                    
                    // Seção especial para MVVM
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      '🏗️ Arquitetura MVVM',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildListButton(
                      context,
                      '💎 Predição de Diamantes (MVVM)',
                      Icons.diamond,
                      () => context.go('/prediction-mvvm'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Formulários',
                      Icons.check_box,
                      () => context.go('/forms'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Navigation Bars',
                      Icons.navigation,
                      () => context.go('/navigation-bars'),
                    ),
                    const SizedBox(height: 12),
                    _buildListButton(
                      context,
                      'Alerts',
                      Icons.notification_important,
                      () => context.go('/alerts'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
