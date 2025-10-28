import 'package:flutter/material.dart';
import 'button_sample_page.dart';
import 'input_sample_page.dart';
import 'linked_label_sample_page.dart';

/// Página principal de showcase dos componentes do Design System
class ComponentShowcasePage extends StatelessWidget {
  const ComponentShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Components'),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSectionTitle('Componentes Disponíveis'),
          const SizedBox(height: 16),
          _buildComponentCard(
            context: context,
            title: 'Buttons',
            description: 'Botões com múltiplas variantes, tamanhos e estados',
            icon: Icons.smart_button,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ButtonSamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildComponentCard(
            context: context,
            title: 'Inputs',
            description: 'Campos de entrada de texto com validação e customização',
            icon: Icons.input,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputSamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildComponentCard(
            context: context,
            title: 'Linked Labels',
            description: 'Labels com texto clicável para links e navegação',
            icon: Icons.link,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LinkedLabelSamplePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildComponentCard(
            context: context,
            title: 'Tabs',
            description: 'Componente de abas para navegação entre conteúdos',
            icon: Icons.tab,
            color: Colors.orange,
            onTap: () {
              // TODO: Implementar página de exemplo de Tabs
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tabs example - Em desenvolvimento'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildComponentCard(
            context: context,
            title: 'Bottom Navigation',
            description: 'Barra de navegação inferior para apps mobile',
            icon: Icons.navigation,
            color: Colors.teal,
            onTap: () {
              // TODO: Implementar página de exemplo de Bottom Navigation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bottom Navigation example - Em desenvolvimento'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildInfoSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.palette,
              size: 48,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 16),
            const Text(
              'Design System',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Componentes reutilizáveis baseados em ViewModels',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildComponentCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Arquitetura',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Todos os componentes seguem o padrão:\n\n'
              '• BaseComponentViewModel: Classe base com propriedades comuns\n'
              '• Herança: Componentes específicos herdam do base\n'
              '• Composição: ViewModels configuráveis e reutilizáveis\n'
              '• Separação: Lógica (ViewModel) separada da UI (Widget)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
