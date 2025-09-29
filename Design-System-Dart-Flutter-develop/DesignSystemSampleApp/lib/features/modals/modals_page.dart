import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra modais com design Shadcn/UI
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
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
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
          side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
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
          side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
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
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
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
