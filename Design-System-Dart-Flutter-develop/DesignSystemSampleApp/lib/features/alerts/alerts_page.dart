import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_alert.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alerts',
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
            'Tipos de Alert',
            'Diferentes tipos para diferentes situações',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Informação',
                description: 'Este é um alert informativo com informações úteis.',
                type: ShadcnAlertType.info,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Sucesso',
                description: 'Operação realizada com sucesso!',
                type: ShadcnAlertType.success,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Atenção',
                description: 'Você deve prestar atenção nesta mensagem.',
                type: ShadcnAlertType.warning,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Erro',
                description: 'Algo deu errado. Por favor, tente novamente.',
                type: ShadcnAlertType.error,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Variantes',
            'Diferentes estilos visuais',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Alert Padrão',
                description: 'Alert com estilo padrão.',
                type: ShadcnAlertType.info,
                variant: ShadcnAlertVariant.default_,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Alert Preenchido',
                description: 'Alert com fundo colorido.',
                type: ShadcnAlertType.success,
                variant: ShadcnAlertVariant.filled,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Alert Contornado',
                description: 'Alert apenas com borda.',
                type: ShadcnAlertType.warning,
                variant: ShadcnAlertVariant.outlined,
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Alert Minimal',
                description: 'Alert com estilo minimalista.',
                type: ShadcnAlertType.error,
                variant: ShadcnAlertVariant.minimal,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Com Ações',
            'Alerts com botões de ação',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Nova Atualização Disponível',
                description: 'Uma nova versão do aplicativo está disponível.',
                type: ShadcnAlertType.info,
                action: Row(
                  children: [
                    ShadcnButton(
                      text: 'Atualizar',
                      size: ShadcnButtonSize.sm,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Atualizando...')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ShadcnButton(
                      text: 'Mais tarde',
                      variant: ShadcnButtonVariant.ghost,
                      size: ShadcnButtonSize.sm,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lembrete definido')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Dismissible',
            'Alerts que podem ser fechados',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Alert Dismissible',
                description: 'Clique no X para fechar este alert.',
                type: ShadcnAlertType.success,
                dismissible: true,
                onDismiss: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alert fechado')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Alerts Globais',
            'Alerts que aparecem no topo da tela',
            [
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShadcnButton(
                    text: 'Info',
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () {
                      ShadcnAlertManager.showInfo(
                        context: context,
                        title: 'Informação',
                        description: 'Este é um alert global de informação.',
                      );
                    },
                  ),
                  ShadcnButton(
                    text: 'Sucesso',
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () {
                      ShadcnAlertManager.showSuccess(
                        context: context,
                        title: 'Sucesso!',
                        description: 'Operação realizada com sucesso.',
                      );
                    },
                  ),
                  ShadcnButton(
                    text: 'Aviso',
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () {
                      ShadcnAlertManager.showWarning(
                        context: context,
                        title: 'Atenção',
                        description: 'Você deve prestar atenção nesta mensagem.',
                      );
                    },
                  ),
                  ShadcnButton(
                    text: 'Erro',
                    variant: ShadcnButtonVariant.outline,
                    onPressed: () {
                      ShadcnAlertManager.showError(
                        context: context,
                        title: 'Erro',
                        description: 'Algo deu errado.',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Legacy - Variante Destructive',
            'Compatibilidade com versão anterior',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Erro',
                description: 'Ocorreu um erro durante a operação.',
                icon: Icon(Icons.error_outline),
                variant: ShadcnAlertVariant.destructive,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Sem Ícones',
            'Alerts sem ícones',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Alert sem ícone',
                description: 'Este alert não tem ícone.',
                type: ShadcnAlertType.info,
                showIcon: false,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Ícones Personalizados',
            'Alerts com ícones customizados',
            [
              const SizedBox(height: 20),
              ShadcnAlert(
                title: 'Upload Completo',
                description: 'Seu arquivo foi enviado com sucesso.',
                type: ShadcnAlertType.success,
                icon: const Icon(Icons.cloud_upload),
              ),
              const SizedBox(height: 16),
              ShadcnAlert(
                title: 'Bateria Baixa',
                description: 'Conecte o dispositivo ao carregador.',
                type: ShadcnAlertType.warning,
                icon: const Icon(Icons.battery_alert),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
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
        if (description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        ...children,
      ],
    );
  }
}