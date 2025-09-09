import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra diferentes tipos de botões Shadcn/UI
class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Botão',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Descrição
          Text(
            'Exibe um botão ou um componente que parece um botão.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Botão padrão
          ShadcnButton(
            text: 'Botão',
            onPressed: () => _showMessage(context, 'Botão padrão pressionado!'),
          ),
          
          const SizedBox(height: 32),
          
          // Variantes de botões
          _buildSection(
            context,
            'Variantes',
            [
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ShadcnButton(
                    text: 'Padrão',
                    variant: ShadcnButtonVariant.default_,
                    onPressed: () => _showMessage(context, 'Botão padrão pressionado!'),
                  ),
                  ShadcnButton(
                    text: 'Destrutivo',
                    variant: ShadcnButtonVariant.destructive,
                    onPressed: () => _showMessage(context, 'Ação destrutiva executada!'),
                  ),
                  ShadcnButton(
                    text: 'Contorno',
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () => _showMessage(context, 'Botão de contorno clicado!'),
                  ),
                  ShadcnButton(
                    text: 'Secundário',
                    variant: ShadcnButtonVariant.secondary,
                    onPressed: () => _showMessage(context, 'Ação secundária acionada!'),
                  ),
                  ShadcnButton(
                    text: 'Fantasma',
                    variant: ShadcnButtonVariant.ghost,
                    onPressed: () => _showMessage(context, 'Botão fantasma ativado!'),
                  ),
                  ShadcnButton(
                    text: 'Link',
                    variant: ShadcnButtonVariant.link,
                    onPressed: () => _showMessage(context, 'Botão link tocado!'),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Tamanhos
          _buildSection(
            context,
            'Tamanhos',
            [
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ShadcnButton(
                    text: 'Pequeno',
                    size: ShadcnButtonSize.sm,
                    onPressed: () => _showMessage(context, 'Botão pequeno pressionado!'),
                  ),
                  ShadcnButton(
                    text: 'Padrão',
                    size: ShadcnButtonSize.default_,
                    onPressed: () => _showMessage(context, 'Botão tamanho padrão!'),
                  ),
                  ShadcnButton(
                    text: 'Grande',
                    size: ShadcnButtonSize.lg,
                    onPressed: () => _showMessage(context, 'Botão grande clicado!'),
                  ),
                  ShadcnButton(
                    text: '',
                    size: ShadcnButtonSize.icon,
                    icon: const Icon(Icons.star),
                    onPressed: () => _showMessage(context, 'Botão de ícone tocado!'),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botões com ícones
          _buildSection(
            context,
            'Com Ícone',
            [
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ShadcnButton(
                    text: 'Enviar Mensagem',
                    icon: const Icon(Icons.mail),
                    onPressed: () => _showMessage(context, 'Mensagem enviada com sucesso!'),
                  ),
                  ShadcnButton(
                    text: 'Baixar',
                    icon: const Icon(Icons.download),
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () => _showMessage(context, 'Download iniciado!'),
                  ),
                  ShadcnButton(
                    text: 'Compartilhar',
                    icon: const Icon(Icons.share),
                    variant: ShadcnButtonVariant.secondary,
                    onPressed: () => _showMessage(context, 'Compartilhando conteúdo...'),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botões loading
          _buildSection(
            context,
            'Carregando',
            [
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ShadcnButton(
                    text: 'Aguarde',
                    loading: true,
                    onPressed: () => _showMessage(context, 'Botão de carregamento clicado!'),
                  ),
                  ShadcnButton(
                    text: 'Carregando',
                    loading: true,
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () => _showMessage(context, 'Contorno carregando clicado!'),
                  ),
                  ShadcnButton(
                    text: 'Enviando',
                    loading: true,
                    variant: ShadcnButtonVariant.secondary,
                    onPressed: () => _showMessage(context, 'Botão enviando clicado!'),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Botões desabilitados
          _buildSection(
            context,
            'Desabilitado',
            [
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  ShadcnButton(
                    text: 'Desabilitado',
                    disabled: true,
                  ),
                  ShadcnButton(
                    text: 'Desabilitado',
                    disabled: true,
                    variant: ShadcnButtonVariant.outline,
                  ),
                  ShadcnButton(
                    text: 'Desabilitado',
                    disabled: true,
                    variant: ShadcnButtonVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // As Button (como link)
          _buildSection(
            context,
            'Como Componente Filho',
            [
              const SizedBox(height: 16),
              const Text('Você pode usar o helper buttonVariant com:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  InkWell(
                    onTap: () => _showMessage(context, 'Widget personalizado tocado!'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Widget Personalizado',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showMessage(context, 'Botão link ativado!'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Como Link',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
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

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...children,
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
