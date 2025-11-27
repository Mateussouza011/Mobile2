import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_navigation_bar.dart';

class NavigationBarsPage extends StatefulWidget {
  const NavigationBarsPage({super.key});

  @override
  State<NavigationBarsPage> createState() => _NavigationBarsPageState();
}

class _NavigationBarsPageState extends State<NavigationBarsPage> {
  int _primarySelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Navigation Bars',
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
          // Descrição
          Text(
            'Navigation Bars',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Componente de navegação primário com indicador destacado.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Navigation Bar Primário
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSelectedIcon(_primarySelectedIndex),
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getSelectedTitle(_primarySelectedIndex),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Página ${_primarySelectedIndex + 1} selecionada',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ShadcnNavigationBar(
                  selectedIndex: _primarySelectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _primarySelectedIndex = index);
                  },
                  variant: ShadcnNavigationBarVariant.primary,
                  items: const [
                    ShadcnNavigationBarItem(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'Início',
                    ),
                    ShadcnNavigationBarItem(
                      icon: Icons.search_outlined,
                      selectedIcon: Icons.search,
                      label: 'Buscar',
                    ),
                    ShadcnNavigationBarItem(
                      icon: Icons.favorite_border,
                      selectedIcon: Icons.favorite,
                      label: 'Favoritos',
                      badge: Text('2'),
                    ),
                    ShadcnNavigationBarItem(
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      label: 'Perfil',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSelectedIcon(int index) {
    switch (index) {
      case 0: return Icons.home;
      case 1: return Icons.search;
      case 2: return Icons.favorite;
      case 3: return Icons.person;
      default: return Icons.help;
    }
  }

  String _getSelectedTitle(int index) {
    switch (index) {
      case 0: return 'Início';
      case 1: return 'Buscar';
      case 2: return 'Favoritos';
      case 3: return 'Perfil';
      default: return 'Página ${index + 1}';
    }
  }
}