import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../DesignSystem/Samples/actionButtonSampleScreen/action_button_sample_screen.dart';
import '../../DesignSystem/Samples/bottomTabBarSampleScreen/bottom_tab_bar_sample_screen.dart';
import '../../DesignSystem/Samples/inputFieldSampleScreen/input_field_sample_screen.dart';
import '../../DesignSystem/Samples/linkedLabelSampleScreen/linked_label_sample_screen.dart';
import '../../DesignSystem/Samples/tabComponentSampleScreen/tab_sample_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Sample App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Simula logout
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação principal
            Text(
              'Olá, bem-vindo!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              'Explore os componentes do Design System',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            const SizedBox(height: 24),
            
            // Seção de componentes do Design System
            Text(
              'Componentes do Design System',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid de componentes
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildComponentCard(
                    context,
                    'Action Button',
                    Icons.touch_app,
                    () => _navigateToComponent(context, ActionButtonPage()),
                  ),
                  _buildComponentCard(
                    context,
                    'Bottom Tab Bar',
                    Icons.tab,
                    () => _navigateToComponent(context, BottomTabBarPage()),
                  ),
                  _buildComponentCard(
                    context,
                    'Input Field',
                    Icons.text_fields,
                    () => _navigateToComponent(context, InputFieldPage()),
                  ),
                  _buildComponentCard(
                    context,
                    'Linked Label',
                    Icons.link,
                    () => _navigateToComponent(context, LinkedLabelPage()),
                  ),
                  _buildComponentCard(
                    context,
                    'Tab Component',
                    Icons.tab_unselected,
                    () => _navigateToComponent(context, TabPage()),
                  ),
                  _buildComponentCard(
                    context,
                    'Custom Button',
                    Icons.smart_button,
                    () => _showCustomButtonDemo(context),
                  ),
                ],
              ),
            ),
            
            // Informações do usuário
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário Logado',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'usuario@exemplo.com',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToComponent(BuildContext context, Widget component) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => component),
    );
  }

  void _showCustomButtonDemo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Button Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Demonstração dos CustomButtons:'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Primary',
              onPressed: () {},
              variant: CustomButtonVariant.primary,
              size: CustomButtonSize.small,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Secondary',
              onPressed: () {},
              variant: CustomButtonVariant.secondary,
              size: CustomButtonSize.small,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Outline',
              onPressed: () {},
              variant: CustomButtonVariant.outline,
              size: CustomButtonSize.small,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Destructive',
              onPressed: () {},
              variant: CustomButtonVariant.destructive,
              size: CustomButtonSize.small,
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
            variant: CustomButtonVariant.outline,
            size: CustomButtonSize.small,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Deseja realmente sair da aplicação?'),
        actions: [
          CustomButton(
            text: 'Cancelar',
            onPressed: () => Navigator.of(context).pop(),
            variant: CustomButtonVariant.outline,
            size: CustomButtonSize.small,
          ),
          CustomButton(
            text: 'Sair',
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            variant: CustomButtonVariant.destructive,
            size: CustomButtonSize.small,
          ),
        ],
      ),
    );
  }
}
