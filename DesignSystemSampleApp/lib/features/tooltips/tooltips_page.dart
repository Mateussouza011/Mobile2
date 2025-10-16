import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_tooltip.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

class TooltipsPage extends StatelessWidget {
  const TooltipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tooltips',
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
            'Posições',
            '',
            [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShadcnTooltip(
                          message: 'Tooltip no topo esquerdo',
                          position: ShadcnTooltipPosition.topLeft,
                          child: ShadcnButton(
                            text: 'Top Left',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                        ShadcnTooltip(
                          message: 'Tooltip no topo',
                          position: ShadcnTooltipPosition.top,
                          child: ShadcnButton(
                            text: 'Top',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                        ShadcnTooltip(
                          message: 'Tooltip no topo direito',
                          position: ShadcnTooltipPosition.topRight,
                          child: ShadcnButton(
                            text: 'Top Right',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Middle row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShadcnTooltip(
                          message: 'Tooltip à esquerda',
                          position: ShadcnTooltipPosition.left,
                          child: ShadcnButton(
                            text: 'Left',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.star),
                          ),
                        ),
                        ShadcnTooltip(
                          message: 'Tooltip à direita',
                          position: ShadcnTooltipPosition.right,
                          child: ShadcnButton(
                            text: 'Right',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ShadcnTooltip(
                          message: 'Tooltip na base esquerda',
                          position: ShadcnTooltipPosition.bottomLeft,
                          child: ShadcnButton(
                            text: 'Bottom Left',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                        ShadcnTooltip(
                          message: 'Tooltip na base',
                          position: ShadcnTooltipPosition.bottom,
                          child: ShadcnButton(
                            text: 'Bottom',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                        ShadcnTooltip(
                          message: 'Tooltip na base direita',
                          position: ShadcnTooltipPosition.bottomRight,
                          child: ShadcnButton(
                            text: 'Bottom Right',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Estilos',
            '',
            [
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ShadcnTooltip(
                    message: 'Tooltip padrão',
                    child: ShadcnButton(
                      text: 'Padrão',
                      onPressed: () {},
                    ),
                  ),
                  ShadcnTooltip(
                    message: 'Tooltip com cor personalizada',
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    child: ShadcnButton(
                      text: 'Colorido',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () {},
                    ),
                  ),
                  ShadcnTooltip(
                    message: 'Este é um tooltip com texto mais longo para demonstrar o comportamento do componente',
                    maxWidth: 200,
                    child: ShadcnButton(
                      text: 'Texto Longo',
                      variant: ShadcnButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ),
                  ShadcnTooltip(
                    message: 'Tooltip sem seta',
                    showArrow: false,
                    child: ShadcnButton(
                      text: 'Sem Seta',
                      variant: ShadcnButtonVariant.ghost,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Com Ícones',
            '',
            [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShadcnTooltip(
                    message: 'Adicionar item',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  ShadcnTooltip(
                    message: 'Editar',
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  ShadcnTooltip(
                    message: 'Excluir',
                    backgroundColor: colorScheme.error,
                    textColor: colorScheme.onError,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
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