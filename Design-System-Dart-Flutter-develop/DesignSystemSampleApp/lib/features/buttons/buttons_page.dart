import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra diferentes tipos de botões Shadcn/UI
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
          'Showcase de Botões',
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
            'Demonstração completa dos botões Shadcn/UI com todos os estados visuais.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Botões Principais
          _buildSection(
            context,
            'Variantes Principais',
            'Botões primário, secundário e destrutivo com contraste adequado',
            [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ShadcnButton(
                      text: 'Primário',
                      variant: ShadcnButtonVariant.default_,
                      onPressed: () => _showMessage(context, 'Botão primário ativo!'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadcnButton(
                      text: 'Secundário',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () => _showMessage(context, 'Botão secundário ativo!'),
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
                      onPressed: () => _showMessage(context, 'Ação destrutiva confirmada!'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ShadcnButton(
                      text: 'Outline',
                      variant: ShadcnButtonVariant.outline,
                      onPressed: () => _showMessage(context, 'Botão outline ativo!'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botões com Ícones
          _buildSection(
            context,
            'Botões com Ícones',
            'Botões com ícones mantendo contraste e legibilidade',
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
                      onPressed: () => _showMessage(context, 'Download iniciado!'),
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
                      onPressed: () => _showMessage(context, 'Mensagem enviada!'),
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
                onPressed: () => _showMessage(context, 'Favoritado!'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Estados de Botões
          _buildSection(
            context,
            'Estados dos Botões',
            'Demonstração de estados: ativo, hover, loading e desabilitado',
            [
              const SizedBox(height: 20),
              // Estado normal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Normal',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ShadcnButton(
                            text: 'Ativo',
                            onPressed: () => _showMessage(context, 'Botão ativo!'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShadcnButton(
                            text: 'Ghost',
                            variant: ShadcnButtonVariant.ghost,
                            onPressed: () => _showMessage(context, 'Ghost ativo!'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Estado loading
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Loading',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ShadcnButton(
                            text: 'Carregando...',
                            loading: true,
                            onPressed: null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShadcnButton(
                            text: 'Processando...',
                            loading: true,
                            variant: ShadcnButtonVariant.secondary,
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Estado desabilitado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Desabilitado',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ShadcnButton(
                            text: 'Desabilitado',
                            disabled: true,
                            onPressed: null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShadcnButton(
                            text: 'Indisponível',
                            disabled: true,
                            variant: ShadcnButtonVariant.outline,
                            onPressed: null,
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
          
          // Teste de Contraste
          _buildSection(
            context,
            'Teste de Contraste',
            'Verificação da legibilidade em temas claro e escuro',
            [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Todos os botões abaixo devem ter texto legível:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ShadcnButton(
                          text: 'Primário',
                          size: ShadcnButtonSize.sm,
                          onPressed: () => _showMessage(context, 'Contraste OK - Primário'),
                        ),
                        ShadcnButton(
                          text: 'Secundário',
                          variant: ShadcnButtonVariant.secondary,
                          size: ShadcnButtonSize.sm,
                          onPressed: () => _showMessage(context, 'Contraste OK - Secundário'),
                        ),
                        ShadcnButton(
                          text: 'Outline',
                          variant: ShadcnButtonVariant.outline,
                          size: ShadcnButtonSize.sm,
                          onPressed: () => _showMessage(context, 'Contraste OK - Outline'),
                        ),
                        ShadcnButton(
                          text: 'Ghost',
                          variant: ShadcnButtonVariant.ghost,
                          size: ShadcnButtonSize.sm,
                          onPressed: () => _showMessage(context, 'Contraste OK - Ghost'),
                        ),
                        ShadcnButton(
                          text: 'Destrutivo',
                          variant: ShadcnButtonVariant.destructive,
                          size: ShadcnButtonSize.sm,
                          onPressed: () => _showMessage(context, 'Contraste OK - Destrutivo'),
                        ),
                      ],
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
            'Diferentes Tamanhos',
            'Botões em tamanhos pequeno, padrão e grande',
            [
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      ShadcnButton(
                        text: 'Pequeno',
                        size: ShadcnButtonSize.sm,
                        onPressed: () => _showMessage(context, 'Botão pequeno!'),
                      ),
                      const SizedBox(width: 12),
                      ShadcnButton(
                        text: 'Padrão',
                        size: ShadcnButtonSize.default_,
                        onPressed: () => _showMessage(context, 'Botão padrão!'),
                      ),
                      const SizedBox(width: 12),
                      ShadcnButton(
                        text: 'Grande',
                        size: ShadcnButtonSize.lg,
                        onPressed: () => _showMessage(context, 'Botão grande!'),
                      ),
                    ],
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
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        ...children,
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: colorScheme.inverseSurface,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}