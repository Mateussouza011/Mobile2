import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../../ui/widgets/shadcn/shadcn_separator.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/theme_toggle_button.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  bool _isExpanded = false;
  bool _isCardSelected = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cards',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: const [ThemeToggleButton(size: 36), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 32),
          _buildBasicCards(context),
          
          const SizedBox(height: 32),
          _buildVariations(context),
          
          const SizedBox(height: 32),
          _buildAdvancedCards(context),
          
          const SizedBox(height: 32),
          _buildSeparatorSection(context),
        ],
      ),
    );
  }

  Widget _buildBasicCards(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Básicos',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        ShadcnCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Simples',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Conteúdo do card demonstrativo.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariations(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variações',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        ShadcnCard(
          variant: ShadcnCardVariant.elevated,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Card Elevado',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        ShadcnCard(
          variant: ShadcnCardVariant.filled,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Card Preenchido',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedCards(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cards Avançados',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ShadcnCard.simple(
          child: const Text('Este é um card simples com conteúdo básico.'),
          onTap: () => _showMessage('Card simples tocado!'),
        ),
        const SizedBox(height: 16),
        ShadcnCard(
          title: 'Notificações',
          description: 'Você tem 3 mensagens não lidas.',
          header: const Row(
            children: [
              Icon(Icons.notifications_outlined),
              SizedBox(width: 8),
              Text('Sistema'),
            ],
          ),
          footer: Row(
            children: [
              ShadcnButton(
                text: 'Marcar como lidas',
                variant: ShadcnButtonVariant.ghost,
                size: ShadcnButtonSize.sm,
                onPressed: () => _showMessage('Notificações marcadas!'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadcnCard.expandable(
          title: 'Card Expansível',
          subtitle: 'Toque para expandir/recolher',
          leading: const Icon(Icons.info_outline),
          expanded: _isExpanded,
          onExpandChanged: (expanded) => setState(() => _isExpanded = expanded),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Conteúdo expandido aqui!'),
              const SizedBox(height: 8),
              Text(
                'Este conteúdo só aparece quando o card está expandido.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ShadcnButton(
                text: 'Ação',
                size: ShadcnButtonSize.sm,
                variant: ShadcnButtonVariant.outline,
                onPressed: () => _showMessage('Ação executada!'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadcnCard(
          title: 'Card Selecionável',
          description: 'Toque para selecionar/deselecionar',
          selectable: true,
          selected: _isCardSelected,
          onSelectionChanged: (selected) => setState(() => _isCardSelected = selected),
          variant: _isCardSelected ? ShadcnCardVariant.filled : ShadcnCardVariant.outlined,
          leading: Icon(
            _isCardSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: _isCardSelected ? colorScheme.primary : null,
          ),
        ),
        const SizedBox(height: 16),
        ShadcnCard(
          layout: ShadcnCardLayout.horizontal,
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person,
              color: colorScheme.onPrimary,
              size: 30,
            ),
          ),
          title: 'João Silva',
          subtitle: 'Desenvolvedor Flutter',
          description: 'Especialista em desenvolvimento mobile',
          trailing: Column(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              Text(
                '4.9',
                style: textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            ShadcnButton.icon(
              icon: const Icon(Icons.message),
              size: ShadcnButtonSize.sm,
              variant: ShadcnButtonVariant.ghost,
              onPressed: () => _showMessage('Enviando mensagem...'),
            ),
            const SizedBox(width: 8),
            ShadcnButton.icon(
              icon: const Icon(Icons.phone),
              size: ShadcnButtonSize.sm,
              variant: ShadcnButtonVariant.ghost,
              onPressed: () => _showMessage('Fazendo ligação...'),
            ),
          ],
          onTap: () => _showMessage('Perfil de João Silva'),
        ),
      ],
    );
  }

  Widget _buildSeparatorSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout & Separadores',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ShadcnCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Separadores Básicos',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              const Text('Separador sólido:'),
              const SizedBox(height: 8),
              const ShadcnSeparator.horizontal(),
              const SizedBox(height: 12),
              
              const Text('Separador tracejado:'),
              const SizedBox(height: 8),
              const ShadcnSeparator.dashed(),
              const SizedBox(height: 12),
              
              const Text('Separador pontilhado:'),
              const SizedBox(height: 8),
              const ShadcnSeparator.dotted(),
              const SizedBox(height: 12),
              
              const Text('Separador com gradiente:'),
              const SizedBox(height: 8),
              ShadcnSeparator.gradient(
                gradientColors: [
                  Colors.transparent,
                  colorScheme.primary,
                  Colors.transparent,
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        ShadcnCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Separadores com Labels',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              const ShadcnSeparator.horizontal(
                label: 'OU',
              ),
              const SizedBox(height: 12),
              
              const ShadcnSeparator.horizontal(
                label: 'CONTINUAR COM',
                variant: ShadcnSeparatorVariant.dashed,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        ShadcnCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gerencie suas preferências',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              
              const ShadcnSeparator.horizontal(),
              const SizedBox(height: 16),
              
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person),
                title: Text('Perfil'),
                subtitle: Text('Editar informações pessoais'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
              
              const ShadcnSeparator.horizontal(
                indent: 40,
              ),
              
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.notifications),
                title: Text('Notificações'),
                subtitle: Text('Configurar alertas'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
              
              const ShadcnSeparator.horizontal(
                indent: 40,
              ),
              
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.security),
                title: Text('Privacidade'),
                subtitle: Text('Configurações de segurança'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        const ShadcnSection(
          title: 'Configurações de Conta',
          subtitle: 'Gerencie suas preferências pessoais',
          showTopSeparator: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  subtitle: Text('Editar informações pessoais'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificações'),
                  subtitle: Text('Configurar alertas'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Segurança'),
                  subtitle: Text('Configurações de privacidade'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}