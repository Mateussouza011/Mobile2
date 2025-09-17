import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/component_card.dart';

/// Página inicial da aplicação Shadcn/UI
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Text(
              'Biblioteca de Componentes',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Componentes lindamente projetados construídos com Radix UI e Tailwind CSS.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
            // Grid de componentes
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                ComponentCard(
                  title: 'Demonstração',
                  description: 'Exemplos avançados dos componentes genéricos.',
                  icon: Icons.auto_awesome,
                  onTap: () => context.go('/showcase'),
                ),
                ComponentCard(
                  title: 'Botão',
                  description: 'Exibe um botão ou um componente que parece um botão.',
                  icon: Icons.smart_button,
                  onTap: () => context.go('/buttons'),
                ),
                ComponentCard(
                  title: 'Campo de Texto',
                  description: 'Exibe um campo de entrada de formulário ou um componente que parece um campo de entrada.',
                  icon: Icons.text_fields,
                  onTap: () => context.go('/inputs'),
                ),
                ComponentCard(
                  title: 'Cartão',
                  description: 'Exibe um cartão com cabeçalho, conteúdo e rodapé.',
                  icon: Icons.view_agenda,
                  onTap: () => context.go('/cards'),
                ),
                ComponentCard(
                  title: 'Tabela',
                  description: 'Um componente de tabela responsiva.',
                  icon: Icons.table_chart,
                  onTap: () => context.go('/tables'),
                ),
                ComponentCard(
                  title: 'Controle Deslizante',
                  description: 'Uma entrada onde o usuário seleciona um valor dentro de um intervalo determinado.',
                  icon: Icons.tune,
                  onTap: () => context.go('/sliders'),
                ),
                ComponentCard(
                  title: 'Diálogo',
                  description: 'Uma janela sobreposta à janela principal ou a outra janela de diálogo.',
                  icon: Icons.web_asset,
                  onTap: () => context.go('/modals'),
                ),
                ComponentCard(
                  title: 'Configurações',
                  description: 'Personalize temas, idiomas e outras preferências do aplicativo.',
                  icon: Icons.settings,
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção de informações
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sobre este Sistema de Design',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Esta é uma implementação Flutter dos populares sistemas de design Shadcn/UI e Origin UI. '
                    'Copie e cole o código para construir sua própria biblioteca de componentes.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
