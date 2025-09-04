import 'package:flutter/material.dart';
import '../../widgets/buttons/shadcn_button.dart';

/// Página inicial da aplicação
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Shadcn App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Text(
              'Bem-vindo ao Sample Shadcn App',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              'Uma aplicação Flutter inspirada no design system shadcn/ui',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            const SizedBox(height: 32),
            
            // Seção de botões
            Text(
              'Componentes do Design System',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Grid de botões demonstrando as variantes
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ShadcnButton(
                  text: 'Primary Button',
                  variant: ButtonVariant.primary,
                  onPressed: () => _showSnackBar(context, 'Primary button pressed'),
                ),
                ShadcnButton(
                  text: 'Secondary Button',
                  variant: ButtonVariant.secondary,
                  onPressed: () => _showSnackBar(context, 'Secondary button pressed'),
                ),
                ShadcnButton(
                  text: 'Outline Button',
                  variant: ButtonVariant.outline,
                  onPressed: () => _showSnackBar(context, 'Outline button pressed'),
                ),
                ShadcnButton(
                  text: 'Ghost Button',
                  variant: ButtonVariant.ghost,
                  onPressed: () => _showSnackBar(context, 'Ghost button pressed'),
                ),
                ShadcnButton(
                  text: 'Destructive Button',
                  variant: ButtonVariant.destructive,
                  onPressed: () => _showSnackBar(context, 'Destructive button pressed'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Seção de botões com ícones
            Text(
              'Botões com Ícones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ShadcnButton(
                  text: 'Com Ícone à Esquerda',
                  leadingIcon: Icons.star,
                  onPressed: () => _showSnackBar(context, 'Button with leading icon pressed'),
                ),
                ShadcnButton(
                  text: 'Com Ícone à Direita',
                  trailingIcon: Icons.arrow_forward,
                  variant: ButtonVariant.outline,
                  onPressed: () => _showSnackBar(context, 'Button with trailing icon pressed'),
                ),
                ShadcnButton(
                  icon: Icons.favorite,
                  size: ButtonSize.icon,
                  variant: ButtonVariant.ghost,
                  onPressed: () => _showSnackBar(context, 'Icon button pressed'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Seção de tamanhos
            Text(
              'Diferentes Tamanhos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ShadcnButton(
                  text: 'Small',
                  size: ButtonSize.small,
                  onPressed: () => _showSnackBar(context, 'Small button pressed'),
                ),
                ShadcnButton(
                  text: 'Medium',
                  size: ButtonSize.medium,
                  onPressed: () => _showSnackBar(context, 'Medium button pressed'),
                ),
                ShadcnButton(
                  text: 'Large',
                  size: ButtonSize.large,
                  onPressed: () => _showSnackBar(context, 'Large button pressed'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Botão de loading
            Text(
              'Estado de Loading',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            const ShadcnButton(
              text: 'Loading Button',
              isLoading: true,
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
