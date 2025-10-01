import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/component_card.dart';

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
            const SizedBox(height: 32),
            
            // Grid de componentes
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                ComponentCard(
                  title: 'Demonstração',
                  icon: Icons.auto_awesome,
                  onTap: () => context.go('/showcase'),
                ),
                ComponentCard(
                  title: 'Botão',
                  icon: Icons.smart_button,
                  onTap: () => context.go('/buttons'),
                ),
                ComponentCard(
                  title: 'Campo de Texto',
                  icon: Icons.text_fields,
                  onTap: () => context.go('/inputs'),
                ),
                ComponentCard(
                  title: 'Cartão',
                  icon: Icons.view_agenda,
                  onTap: () => context.go('/cards'),
                ),
                ComponentCard(
                  title: 'Cards e Listas',
                  icon: Icons.list_alt,
                  onTap: () => context.go('/cards-and-lists'),
                ),
                ComponentCard(
                  title: 'Tabela',
                  icon: Icons.table_chart,
                  onTap: () => context.go('/tables'),
                ),
                ComponentCard(
                  title: 'Controle Deslizante',
                  icon: Icons.tune,
                  onTap: () => context.go('/sliders'),
                ),
                ComponentCard(
                  title: 'Diálogo',
                  icon: Icons.web_asset,
                  onTap: () => context.go('/modals'),
                ),
                ComponentCard(
                  title: 'Configurações',
                  icon: Icons.settings,
                  onTap: () => context.go('/settings'),
                ),
                ComponentCard(
                  title: 'Badges',
                  icon: Icons.label,
                  onTap: () => context.go('/badges'),
                ),
                ComponentCard(
                  title: 'Progress',
                  icon: Icons.linear_scale,
                  onTap: () => context.go('/progress'),
                ),
                ComponentCard(
                  title: 'Avatars',
                  icon: Icons.account_circle,
                  onTap: () => context.go('/avatars'),
                ),
                ComponentCard(
                  title: 'Formulários',
                  icon: Icons.check_box,
                  onTap: () => context.go('/forms'),
                ),
                ComponentCard(
                  title: 'Alerts',
                  icon: Icons.notification_important,
                  onTap: () => context.go('/alerts'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
