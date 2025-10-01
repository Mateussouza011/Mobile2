import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_tabs.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabs',
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
            'Line Tabs',
            '',
            [
              const SizedBox(height: 20),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: ShadcnTabs(
                  variant: ShadcnTabsVariant.line,
                  tabs: [
                    ShadcnTab(
                      label: 'Geral',
                      icon: Icon(Icons.dashboard, size: 16),
                      content: _buildTabContent('Conteúdo da aba Geral', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Usuários',
                      icon: Icon(Icons.people, size: 16),
                      content: _buildTabContent('Conteúdo da aba Usuários', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Configurações',
                      icon: Icon(Icons.settings, size: 16),
                      content: _buildTabContent('Conteúdo da aba Configurações', colorScheme),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Pills Tabs',
            '',
            [
              const SizedBox(height: 20),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: ShadcnTabs(
                  variant: ShadcnTabsVariant.pills,
                  tabs: [
                    ShadcnTab(
                      label: 'Início',
                      icon: Icon(Icons.home, size: 16),
                      content: _buildTabContent('Bem-vindo à página inicial', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Sobre',
                      icon: Icon(Icons.info, size: 16),
                      content: _buildTabContent('Informações sobre o aplicativo', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Contato',
                      icon: Icon(Icons.contact_mail, size: 16),
                      content: _buildTabContent('Entre em contato conosco', colorScheme),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Card Tabs',
            '',
            [
              const SizedBox(height: 20),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: ShadcnTabs(
                  variant: ShadcnTabsVariant.card,
                  tabs: [
                    ShadcnTab(
                      label: 'Projetos',
                      icon: Icon(Icons.folder, size: 16),
                      content: _buildProjectsContent(colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Tarefas',
                      icon: Icon(Icons.task, size: 16),
                      content: _buildTasksContent(colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Relatórios',
                      icon: Icon(Icons.bar_chart, size: 16),
                      content: _buildReportsContent(colorScheme),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Sem Ícones',
            '',
            [
              const SizedBox(height: 20),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: ShadcnTabs(
                  variant: ShadcnTabsVariant.line,
                  tabs: [
                    ShadcnTab(
                      label: 'Primeira',
                      content: _buildTabContent('Conteúdo da primeira aba', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Segunda',
                      content: _buildTabContent('Conteúdo da segunda aba', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Terceira',
                      content: _buildTabContent('Conteúdo da terceira aba', colorScheme),
                    ),
                    ShadcnTab(
                      label: 'Quarta',
                      content: _buildTabContent('Conteúdo da quarta aba', colorScheme),
                    ),
                  ],
                ),
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

  Widget _buildTabContent(String text, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsContent(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projetos Ativos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.folder, color: colorScheme.primary),
                    title: Text('Projeto ${index + 1}'),
                    subtitle: Text('Descrição do projeto ${index + 1}'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksContent(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarefas Pendentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.task_alt, color: colorScheme.secondary),
                    title: Text('Tarefa ${index + 1}'),
                    subtitle: Text('Prazo: ${DateTime.now().add(Duration(days: index + 1)).day}/${DateTime.now().month}'),
                    trailing: Checkbox(value: index == 0, onChanged: (value) {}),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsContent(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relatórios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: colorScheme.primary, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vendas', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('↑ 15% este mês'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.people, color: colorScheme.secondary, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Usuários', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('1,234 usuários ativos'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}