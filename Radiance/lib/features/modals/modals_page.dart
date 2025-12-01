import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';
import '../../ui/widgets/shadcn/shadcn_dialog.dart';
import '../../ui/widgets/theme_toggle_button.dart';

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
        actions: const [ThemeToggleButton(size: 36), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
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
          _buildModalsSection(context),
          
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              _showSnackBarMessage(context, 'Ação cancelada');
            },
          ),
          const SizedBox(width: 8),
          ShadcnButton(
            text: 'Confirmar',
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
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
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          ShadcnButton(
            text: 'Confirmar',
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
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
    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              _showSnackBarMessage(context, 'Editar selecionado');
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).colorScheme.secondary),
            title: const Text('Compartilhar'),
            subtitle: const Text('Enviar para outros'),
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              _showSnackBarMessage(context, 'Compartilhar selecionado');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir'),
            subtitle: const Text('Remover permanentemente'),
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              _showSnackBarMessage(context, 'Excluir selecionado');
            },
          ),
        ],
      ),
      actions: [
        ShadcnButton(
          text: 'Fechar',
          variant: ShadcnButtonVariant.outline,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
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
