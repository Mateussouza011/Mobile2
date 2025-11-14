/// Showcase de demonstração do Button Component
/// Exibe todas as variantes, tamanhos e estados do Button
library;

import 'package:flutter/material.dart';
import '../../application/app_coordinator.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/components/button/button.dart';
import '../../shared/components/button/button_view_model.dart';
import '../../shared/components/button/button_delegate.dart';
import '../../shared/components/button/button_factory.dart';

/// Tela de showcase do Button component
class ButtonShowcase extends StatelessWidget implements ButtonDelegate {
  final AppCoordinator coordinator;

  const ButtonShowcase({
    Key? key,
    required this.coordinator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Component'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Variantes',
              'Diferentes estilos de botão',
              [
                _buildRow([
                  ButtonFactory.primary(
                    text: 'Primary',
                    delegate: this,
                  ),
                  ButtonFactory.secondary(
                    text: 'Secondary',
                    delegate: this,
                  ),
                ]),
                SizedBox(height: spacing3),
                _buildRow([
                  ButtonFactory.destructive(
                    text: 'Destructive',
                    delegate: this,
                  ),
                  ButtonFactory.outline(
                    text: 'Outline',
                    delegate: this,
                  ),
                ]),
                SizedBox(height: spacing3),
                _buildRow([
                  ButtonFactory.ghost(
                    text: 'Ghost',
                    delegate: this,
                  ),
                  ButtonFactory.link(
                    text: 'Link',
                    delegate: this,
                  ),
                ]),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Tamanhos',
              'Small, Default e Large',
              [
                _buildRow([
                  ButtonFactory.primary(
                    text: 'Small',
                    delegate: this,
                    size: ButtonSize.sm,
                  ),
                  ButtonFactory.primary(
                    text: 'Default',
                    delegate: this,
                    size: ButtonSize.defaultSize,
                  ),
                  ButtonFactory.primary(
                    text: 'Large',
                    delegate: this,
                    size: ButtonSize.lg,
                  ),
                ]),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Com Ícones',
              'Botões com ícones leading/trailing',
              [
                _buildRow([
                  ButtonFactory.withIcon(
                    text: 'Email',
                    icon: Icons.mail_outline,
                    delegate: this,
                  ),
                  ButtonComponent(
                    viewModel: ButtonViewModel(
                      text: 'Login',
                      trailingIcon: Icons.arrow_forward,
                      variant: ButtonVariant.defaultVariant,
                    ),
                    delegate: this,
                  ),
                ]),
                SizedBox(height: spacing3),
                _buildRow([
                  ButtonFactory.icon(
                    icon: Icons.favorite,
                    delegate: this,
                  ),
                  ButtonFactory.icon(
                    icon: Icons.share,
                    delegate: this,
                    variant: ButtonVariant.outline,
                  ),
                  ButtonFactory.icon(
                    icon: Icons.settings,
                    delegate: this,
                    variant: ButtonVariant.ghost,
                  ),
                ]),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Estados',
              'Loading, Disabled e Normal',
              [
                _buildRow([
                  ButtonFactory.primary(
                    text: 'Normal',
                    delegate: this,
                  ),
                  ButtonFactory.loading(
                    text: 'Loading',
                  ),
                  ButtonFactory.primary(
                    text: 'Disabled',
                    delegate: this,
                    enabled: false,
                  ),
                ]),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Especializados',
              'Buttons pré-configurados',
              [
                _buildRow([
                  ButtonFactory.save(
                    delegate: this,
                  ),
                  ButtonFactory.delete(
                    delegate: this,
                  ),
                  ButtonFactory.cancel(
                    delegate: this,
                  ),
                ]),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Full Width',
              'Botões que ocupam toda a largura',
              [
                ButtonFactory.primary(
                  text: 'Full Width Button',
                  delegate: this,
                  fullWidth: true,
                ),
                SizedBox(height: spacing3),
                ButtonFactory.outline(
                  text: 'Full Width Outline',
                  delegate: this,
                  fullWidth: true,
                ),
              ],
            ),
            SizedBox(height: spacing8),
            _buildSection(
              'Combinações',
              'Diferentes variantes com ícones e tamanhos',
              [
                _buildRow([
                  ButtonFactory.destructive(
                    text: 'Delete',
                    leadingIcon: Icons.delete_outline,
                    delegate: this,
                    size: ButtonSize.sm,
                  ),
                  ButtonFactory.secondary(
                    text: 'Settings',
                    leadingIcon: Icons.settings,
                    delegate: this,
                  ),
                ]),
                SizedBox(height: spacing3),
                _buildRow([
                  ButtonFactory.outline(
                    text: 'Download',
                    leadingIcon: Icons.download,
                    delegate: this,
                    size: ButtonSize.lg,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headingH3),
        SizedBox(height: spacing1),
        Text(
          description,
          style: bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: spacing4),
        ...children,
      ],
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Wrap(
      spacing: spacing3,
      runSpacing: spacing3,
      children: buttons,
    );
  }

  @override
  void onPressed() {
    debugPrint('Button pressed!');
  }

  @override
  void onLongPress() {
    debugPrint('Button long pressed!');
  }
}
