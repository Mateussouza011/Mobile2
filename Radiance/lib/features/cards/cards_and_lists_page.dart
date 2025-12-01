import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class CardsAndListsPage extends StatelessWidget {
  const CardsAndListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cards e Listas',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: const [ThemeToggleButton(size: 36), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Cards e listas estilizados com tema adaptativo.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Lista de Itens'),
          const SizedBox(height: 16),
          _buildItemsList(context),
          
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Cards com Ação'),
          const SizedBox(height: 16),
          _buildCardsGrid(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final items = [
      {
        'title': 'Configurações do Sistema',
        'subtitle': 'Gerencie as configurações gerais do aplicativo',
        'icon': Icons.settings,
      },
      {
        'title': 'Perfil do Usuário',
        'subtitle': 'Atualize suas informações pessoais',
        'icon': Icons.person,
      },
      {
        'title': 'Notificações',
        'subtitle': 'Configure suas preferências de notificação',
        'icon': Icons.notifications,
      },
      {
        'title': 'Segurança',
        'subtitle': 'Altere senha e configurações de segurança',
        'icon': Icons.security,
      },
      {
        'title': 'Suporte',
        'subtitle': 'Entre em contato com nossa equipe de suporte',
        'icon': Icons.help,
      },
    ];

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () => _showMessage(context, 'Navegando para ${item['title']}'),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  indent: 72,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardsGrid(BuildContext context) {
    final cards = [
      {
        'title': 'Análise de Dados',
        'description': 'Visualize métricas e relatórios detalhados do seu negócio.',
        'image': Icons.analytics,
        'action': 'Visualizar',
      },
      {
        'title': 'Gestão de Equipe',
        'description': 'Gerencie membros da equipe e suas permissões.',
        'image': Icons.group,
        'action': 'Gerenciar',
      },
      {
        'title': 'Backup e Segurança',
        'description': 'Configure backups automáticos e políticas de segurança.',
        'image': Icons.backup,
        'action': 'Configurar',
      },
    ];

    return Column(
      children: cards.map((card) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ShadcnCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      card['image'] as IconData,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card['title'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card['description'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ShadcnButton(
                  text: card['action'] as String,
                  onPressed: () => _showMessage(
                    context,
                    '${card['action']} ${card['title']}',
                  ),
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}