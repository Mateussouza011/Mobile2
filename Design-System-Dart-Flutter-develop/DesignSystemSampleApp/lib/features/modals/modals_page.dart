import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/shadcn/shadcn_dialog.dart';
import '../../ui/widgets/shadcn/shadcn_accordion.dart';

class ModalsPage extends StatelessWidget {
  const ModalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modais',
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
            'Demonstração de modais estilizados',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Modais com contraste adequado e design consistente em ambos os temas.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Seção de Modais
          _buildModalsSection(context),
          
          const SizedBox(height: 32),
          
          // Seção de Navigation & Accordion
          _buildAccordionSection(context),
        ],
      ),
    );
  }

  Widget _buildModalsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modais Interativos',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Diferentes tipos de modais com texto contrastante e botões estilizados.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            
            // Botões para abrir modais
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShadcnButton(
                  text: 'Abrir modal de confirmação',
                  onPressed: () => _showConfirmationModal(context),
                ),
                const SizedBox(height: 16),
                ShadcnButton(
                  text: 'Abrir modal de informação',
                  variant: ShadcnButtonVariant.outline,
                  onPressed: () => _showInformationModal(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'Novos Componentes Shadcn',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ShadcnButton(
                      text: 'Dialog Básico',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () => _showShadcnDialog(context),
                    ),
                    ShadcnButton(
                      text: 'Alert Dialog',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () => _showShadcnAlertDialog(context),
                    ),
                    ShadcnButton(
                      text: 'Loading',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () => _showShadcnLoadingDialog(context),
                    ),
                    ShadcnButton(
                      text: 'Bottom Sheet',
                      variant: ShadcnButtonVariant.secondary,
                      onPressed: () => _showShadcnBottomSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationModal(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        title: Text(
          'Confirmar Ação',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Tem certeza de que deseja executar esta ação? Esta operação não pode ser desfeita.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        actions: [
          ShadcnButton(
            text: 'Cancelar',
            variant: ShadcnButtonVariant.ghost,
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Ação cancelada');
            },
          ),
          const SizedBox(width: 8),
          ShadcnButton(
            text: 'Confirmar',
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Ação confirmada com sucesso!');
            },
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  void _showInformationModal(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Informação',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sistema de Design Shadcn/UI',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Este é um exemplo de modal informativo com design consistente. O texto mantém contraste adequado em ambos os temas (claro e escuro), garantindo legibilidade e acessibilidade.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dica: Este modal adapta-se automaticamente ao tema ativo.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ShadcnButton(
            text: 'Ok, entendi',
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Modal de informação fechado');
            },
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  void _showShadcnDialog(BuildContext context) {
    ShadcnDialog.show(
      context: context,
      dialog: ShadcnDialog(
        title: 'Dialog Shadcn',
        description: 'Este é um exemplo do novo componente ShadcnDialog com design moderno.',
        icon: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
        content: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Conteúdo personalizado do dialog'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Design System aprimorado!'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ShadcnButton(
            text: 'Cancelar',
            variant: ShadcnButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ShadcnButton(
            text: 'Confirmar',
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Dialog Shadcn confirmado!');
            },
          ),
        ],
      ),
    );
  }

  void _showShadcnAlertDialog(BuildContext context) {
    ShadcnAlertDialog.show(
      context: context,
      title: 'Alert Shadcn',
      description: 'Este é um exemplo do ShadcnAlertDialog com botões estilizados.',
      confirmText: 'Sim, continuar',
      cancelText: 'Cancelar',
    ).then((confirmed) {
      if (confirmed == true) {
        _showSnackBarMessage(context, 'Alert confirmado!');
      } else {
        _showSnackBarMessage(context, 'Alert cancelado');
      }
    });
  }

  void _showShadcnLoadingDialog(BuildContext context) {
    ShadcnLoadingDialog.show(
      context: context,
      title: 'Carregando dados...',
      description: 'Por favor, aguarde enquanto processamos sua solicitação.',
    );

    // Simular carregamento
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      _showSnackBarMessage(context, 'Carregamento concluído!');
    });
  }

  void _showShadcnBottomSheet(BuildContext context) {
    ShadcnBottomSheetDialog.show(
      context: context,
      title: 'Opções Avançadas',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
            title: const Text('Editar'),
            subtitle: const Text('Modificar este item'),
            onTap: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Editar selecionado');
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).colorScheme.secondary),
            title: const Text('Compartilhar'),
            subtitle: const Text('Enviar para outros'),
            onTap: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Compartilhar selecionado');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir'),
            subtitle: const Text('Remover permanentemente'),
            onTap: () {
              Navigator.of(context).pop();
              _showSnackBarMessage(context, 'Excluir selecionado');
            },
          ),
        ],
      ),
      actions: [
        ShadcnButton(
          text: 'Fechar',
          variant: ShadcnButtonVariant.outline,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildAccordionSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Card(
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Navigation & Accordion',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Componentes expansíveis para organizar conteúdo de forma hierárquica.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            
            // FAQ Accordion
            Text(
              'FAQ Accordion:',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const ShadcnFAQAccordion(
              faqs: [
                (question: 'Como usar o Design System?', answer: 'O Design System Flutter fornece componentes reutilizáveis que seguem as diretrizes do Shadcn/UI.'),
                (question: 'Os componentes são customizáveis?', answer: 'Sim! Todos os componentes oferecem várias propriedades para personalização de cores, tamanhos e comportamentos.'),
                (question: 'Como contribuir?', answer: 'Você pode contribuir criando issues, enviando pull requests ou sugerindo melhorias na documentação.'),
                (question: 'É possível usar em produção?', answer: 'O sistema está em desenvolvimento ativo. Recomenda-se testar adequadamente antes do uso em produção.'),
                (question: 'Suporte a temas?', answer: 'Sim! O sistema suporta temas claro e escuro, com cores que se adaptam automaticamente.'),
              ],
            ),
            const SizedBox(height: 24),
            
            // Settings Accordion
            Text(
              'Settings Accordion:',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ShadcnSettingsAccordion(
              sections: [
                (
                  title: 'Aparência',
                  description: 'Personalizar tema e layout',
                  settings: [
                    ListTile(
                      title: const Text('Tema Escuro'),
                      subtitle: const Text('Ativar modo escuro'),
                      trailing: Switch(value: false, onChanged: (_) {}),
                    ),
                    ListTile(
                      title: const Text('Tamanho da Fonte'),
                      subtitle: const Text('Ajustar legibilidade'),
                      trailing: DropdownButton<String>(
                        value: 'Médio',
                        items: ['Pequeno', 'Médio', 'Grande'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                    ListTile(
                      title: const Text('Animações'),
                      subtitle: const Text('Reduzir movimento'),
                      trailing: Switch(value: true, onChanged: (_) {}),
                    ),
                  ],
                ),
                (
                  title: 'Notificações',
                  description: 'Controlar alertas e lembretes',
                  settings: [
                    ListTile(
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receber notificações push'),
                      trailing: Switch(value: true, onChanged: (_) {}),
                    ),
                    ListTile(
                      title: const Text('Email Notifications'),
                      subtitle: const Text('Receber emails informativos'),
                      trailing: Switch(value: false, onChanged: (_) {}),
                    ),
                    ListTile(
                      title: const Text('SMS Alerts'),
                      subtitle: const Text('Alertas por mensagem'),
                      trailing: Switch(value: false, onChanged: (_) {}),
                    ),
                  ],
                ),
                (
                  title: 'Privacidade',
                  description: 'Configurações de segurança e dados',
                  settings: [
                    ListTile(
                      title: const Text('Coleta de Dados'),
                      subtitle: const Text('Permitir análise de uso'),
                      trailing: Switch(value: true, onChanged: (_) {}),
                    ),
                    ListTile(
                      title: const Text('Localização'),
                      subtitle: const Text('Usar localização do dispositivo'),
                      trailing: Switch(value: false, onChanged: (_) {}),
                    ),
                    const ListTile(
                      title: Text('Gerenciar Dados'),
                      subtitle: Text('Exportar ou excluir dados'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBarMessage(BuildContext context, String message) {
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
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
