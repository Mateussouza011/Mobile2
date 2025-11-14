/// Tela inicial do aplicativo de demonstração
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/app_coordinator.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/colors.dart' as colors;
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../button_showcase/button_showcase.dart';

/// Tela principal que exibe o menu de showcases disponíveis
class HomeScreen extends StatelessWidget {
  final AppCoordinator coordinator;

  const HomeScreen({
    Key? key,
    required this.coordinator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Demo'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeProvider.toggleTheme,
            tooltip: isDark ? 'Modo Claro' : 'Modo Escuro',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.all(spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: spacing8),
                Text(
                  'shadcn/ui Design System',
                  style: headingH1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing2),
                Text(
                  'Demonstração de componentes em Flutter',
                  style: bodyBase.copyWith(
                    color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing8),
                Expanded(
                  child: ListView(
                    children: [
                      _buildShowcaseCard(
                        context,
                        icon: Icons.smart_button_outlined,
                        title: 'Button Component',
                        description: 'Todas as variantes e estados do Button',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ButtonShowcase(coordinator: coordinator),
                            ),
                          );
                        },
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.edit_outlined,
                        title: 'Forms',
                        description: 'Button, Input, Checkbox, Radio, Select, Switch',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Forms showcase - Components: Input, Checkbox, Switch implemented!')),
                          );
                        },
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.view_module_outlined,
                        title: 'Data Display',
                        description: 'Card, Badge, Avatar, Table, Accordion',
                        onTap: () => coordinator.navigateToDataDisplayShowcase(),
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.navigation_outlined,
                        title: 'Navigation',
                        description: 'Tabs, Breadcrumb, Pagination, Menu',
                        onTap: () => coordinator.navigateToNavigationShowcase(),
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.layers_outlined,
                        title: 'Overlays',
                        description: 'Dialog, Sheet, Popover, Tooltip, Dropdown',
                        onTap: () => coordinator.navigateToOverlaysShowcase(),
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.feedback_outlined,
                        title: 'Feedback',
                        description: 'Toast, Spinner, Progress, Alert',
                        onTap: () => coordinator.navigateToFeedbackShowcase(),
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.dashboard_outlined,
                        title: 'Layout',
                        description: 'Separator, AspectRatio, ScrollArea',
                        onTap: () => coordinator.navigateToLayoutShowcase(),
                        isDark: isDark,
                      ),
                      SizedBox(height: spacing3),
                      _buildShowcaseCard(
                        context,
                        icon: Icons.text_fields_outlined,
                        title: 'Typography',
                        description: 'Heading, Text, Code, Blockquote',
                        onTap: () => coordinator.navigateToTypographyShowcase(),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowcaseCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing4),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? colors.primaryDark : colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDark ? colors.primaryForegroundDark : colors.primaryForeground,
                ),
              ),
              SizedBox(width: spacing4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: headingH4,
                    ),
                    SizedBox(height: spacing1),
                    Text(
                      description,
                      style: bodySmall.copyWith(
                        color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? colors.mutedForegroundDark : colors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
