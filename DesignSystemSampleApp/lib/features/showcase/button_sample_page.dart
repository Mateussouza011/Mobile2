import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';

/// Página de exemplo para demonstrar o uso do componente Button
class ButtonSamplePage extends StatefulWidget {
  const ButtonSamplePage({super.key});

  @override
  State<ButtonSamplePage> createState() => _ButtonSamplePageState();
}

class _ButtonSamplePageState extends State<ButtonSamplePage> {
  bool _isLoading = false;

  void _handlePress(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleLoadingButton() {
    setState(() {
      _isLoading = true;
    });

    // Simula uma operação assíncrona
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _handlePress('Operação concluída!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Component Samples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Variantes de Botões'),
            const SizedBox(height: 16),
            
            // Primary Buttons
            _buildSubsectionTitle('Primary'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Primary Large',
                    size: ButtonSize.large,
                    variant: ButtonVariant.primary,
                    onPressed: () => _handlePress('Primary Large'),
                  ),
                ),
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Primary Medium',
                    size: ButtonSize.medium,
                    variant: ButtonVariant.primary,
                    onPressed: () => _handlePress('Primary Medium'),
                  ),
                ),
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Primary Small',
                    size: ButtonSize.small,
                    variant: ButtonVariant.primary,
                    onPressed: () => _handlePress('Primary Small'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Secondary Buttons
            _buildSubsectionTitle('Secondary'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Secondary',
                    variant: ButtonVariant.secondary,
                    icon: Icons.arrow_forward,
                    onPressed: () => _handlePress('Secondary'),
                  ),
                ),
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'With Icon',
                    variant: ButtonVariant.secondary,
                    icon: Icons.send,
                    iconPosition: IconPosition.trailing,
                    onPressed: () => _handlePress('Secondary with Icon'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Tertiary Buttons
            _buildSubsectionTitle('Tertiary'),
            const SizedBox(height: 8),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Tertiary Button',
                variant: ButtonVariant.tertiary,
                onPressed: () => _handlePress('Tertiary'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Outline Buttons
            _buildSubsectionTitle('Outline'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Outline',
                    variant: ButtonVariant.outline,
                    onPressed: () => _handlePress('Outline'),
                  ),
                ),
                DSButton(
                  viewModel: ButtonViewModel(
                    text: 'Outline with Icon',
                    variant: ButtonVariant.outline,
                    icon: Icons.edit,
                    onPressed: () => _handlePress('Outline with Icon'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Ghost Buttons
            _buildSubsectionTitle('Ghost'),
            const SizedBox(height: 8),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Ghost Button',
                variant: ButtonVariant.ghost,
                icon: Icons.star,
                onPressed: () => _handlePress('Ghost'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Destructive Buttons
            _buildSubsectionTitle('Destructive'),
            const SizedBox(height: 8),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Delete',
                variant: ButtonVariant.destructive,
                icon: Icons.delete,
                onPressed: () => _handlePress('Delete'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Estados especiais
            _buildSectionTitle('Estados Especiais'),
            const SizedBox(height: 16),
            
            _buildSubsectionTitle('Loading'),
            const SizedBox(height: 8),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Loading Button',
                variant: ButtonVariant.primary,
                isLoading: _isLoading,
                onPressed: _handleLoadingButton,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildSubsectionTitle('Disabled'),
            const SizedBox(height: 8),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Disabled Button',
                variant: ButtonVariant.primary,
                isEnabled: false,
                onPressed: () {},
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Full Width
            _buildSectionTitle('Full Width'),
            const SizedBox(height: 16),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Full Width Button',
                variant: ButtonVariant.primary,
                fullWidth: true,
                onPressed: () => _handlePress('Full Width'),
              ),
            ),
            
            const SizedBox(height: 16),
            DSButton(
              viewModel: ButtonViewModel(
                text: 'Full Width with Icon',
                variant: ButtonVariant.secondary,
                icon: Icons.cloud_upload,
                fullWidth: true,
                onPressed: () => _handlePress('Full Width with Icon'),
              ),
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

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }
}
