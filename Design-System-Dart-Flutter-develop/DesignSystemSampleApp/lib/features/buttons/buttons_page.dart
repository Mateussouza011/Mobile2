import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Botões',
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
          // Variantes
          _buildSection(
            context,
            'Variantes',
            '',
            [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ShadcnButton(
                      text: 'Primário',
                      variant: ShadcnButtonVariant.default_,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadcnButton(
                      text: 'Secundário',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ShadcnButton(
                      text: 'Destrutivo',
                      variant: ShadcnButtonVariant.destructive,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadcnButton(
                      text: 'Outline',
                      variant: ShadcnButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Com Ícones
          _buildSection(
            context,
            'Com Ícones',
            '',
            [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ShadcnButton.withLeadingIcon(
                      text: 'Download',
                      leadingIcon: Icon(
                        Icons.download,
                        color: colorScheme.onPrimary,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadcnButton.withLeadingIcon(
                      text: 'Enviar',
                      leadingIcon: Icon(
                        Icons.send,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      variant: ShadcnButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ShadcnButton.icon(
                icon: Icon(
                  Icons.favorite,
                  color: colorScheme.onPrimary,
                ),
                onPressed: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Estados
          _buildSection(
            context,
            'Estados',
            '',
            [
              const SizedBox(height: 20),
              
              // Estado normal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Normal',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShadcnButton(
                      text: 'Ativo',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Estado loading
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loading',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ShadcnButton(
                      text: 'Carregando...',
                      loading: true,
                      onPressed: null,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Estado desabilitado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desabilitado',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ShadcnButton(
                      text: 'Desabilitado',
                      disabled: true,
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Tamanhos
          _buildSection(
            context,
            'Tamanhos',
            '',
            [
              const SizedBox(height: 20),
              Row(
                children: [
                  ShadcnButton(
                    text: 'Pequeno',
                    size: ShadcnButtonSize.sm,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  ShadcnButton(
                    text: 'Padrão',
                    size: ShadcnButtonSize.default_,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  ShadcnButton(
                    text: 'Grande',
                    size: ShadcnButtonSize.lg,
                    onPressed: () {},
                  ),
                ],
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
}