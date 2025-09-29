import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra cards e listas com design Shadcn/UI
class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cards e Listas',
          style: textTheme.titleLarge?.copyWith(
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
            'Demonstração de cards e listas estilizados',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cards com imagens, títulos, descrições e listas interativas.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Seção Lista de Itens
          _buildListTilesSection(context),
          
          const SizedBox(height: 32),
          
          // Seção Cards com Conteúdo
          _buildCardsSection(context),
        ],
      ),
    );
  }

  Widget _buildListTilesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lista de Itens',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ListTiles estilizados com ícones e ações',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildListTile(context, Icons.person_outline, 'Perfil do Usuário', 'Gerencie suas informações pessoais', false),
              _buildListTile(context, Icons.notifications_outlined, 'Notificações', 'Configure alertas e lembretes', false),
              _buildListTile(context, Icons.security_outlined, 'Segurança', 'Configurações de privacidade', false),
              _buildListTile(context, Icons.help_outline, 'Central de Ajuda', 'Encontre respostas para dúvidas', false),
              _buildListTile(context, Icons.info_outline, 'Sobre o Aplicativo', 'Versão e política de privacidade', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String subtitle, bool isLast) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: colorScheme.onSurfaceVariant,
            size: 16,
          ),
          onTap: () => _showMessage(context, 'Acessando: $title'),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: colorScheme.outline.withOpacity(0.2),
            indent: 72,
          ),
      ],
    );
  }

  Widget _buildCardsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cards com Conteúdo',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Cards com imagens, títulos, descrições e botões de ação',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        
        // Card com imagem
        ShadcnCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.primary.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projeto Design System',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sistema de design baseado no Shadcn/UI com componentes reutilizáveis e consistentes para Flutter.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ShadcnButton(
                            text: 'Ver Detalhes',
                            variant: ShadcnButtonVariant.outline,
                            onPressed: () => _showMessage(context, 'Abrindo detalhes'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ShadcnButton(
                            text: 'Acessar',
                            onPressed: () => _showMessage(context, 'Acessando projeto'),
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
        
        const SizedBox(height: 20),
        
        // Card com ícone
        ShadcnCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.rocket_launch_outlined,
                      color: colorScheme.onSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lançamento Produto',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pronto para produção',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Produto pronto para ser lançado! Todos os testes foram concluídos.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ShadcnButton(
                text: 'Fazer Deploy',
                onPressed: () => _showMessage(context, 'Iniciando deploy'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}