import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_card.dart';
import '../../ui/widgets/shadcn/shadcn_button.dart';

/// Página que demonstra diferentes tipos de cards Shadcn/UI
class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cartão',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Descrição
          Text(
            'Exibe um cartão com cabeçalho, conteúdo e rodapé.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Card simples
          ShadcnCard(
            title: 'Criar projeto',
            description: 'Implante seu novo projeto com um clique.',
            child: ShadcnButton(
              text: 'Implantar',
              onPressed: () => _showMessage(context, 'Projeto implantado com sucesso!'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card com header personalizado
          ShadcnCard(
            header: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notificações',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Você tem 3 mensagens não lidas.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.notifications),
              ],
            ),
            child: Column(
              children: [
                _buildNotificationItem(
                  context,
                  'A',
                  'Sua chamada foi confirmada.',
                  '1 hora atrás',
                ),
                const Divider(),
                _buildNotificationItem(
                  context,
                  'B',
                  'Você tem uma nova mensagem!',
                  '1 hora atrás',
                ),
                const Divider(),
                _buildNotificationItem(
                  context,
                  'C',
                  'Sua assinatura está expirando em breve!',
                  '2 horas atrás',
                ),
              ],
            ),
            footer: Row(
              children: [
                ShadcnButton(
                  text: 'Marcar todas como lidas',
                  variant: ShadcnButtonVariant.ghost,
                  onPressed: () => _showMessage(context, 'Todas as notificações marcadas como lidas!'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card com perfil
          ShadcnCard(
            title: 'Membros da Equipe',
            description: 'Convide os membros da sua equipe para colaborar.',
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: null,
                  child: Text('S'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@shadcn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Designer e Desenvolvedor',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ShadcnButton(
                  text: 'Seguir',
                  variant: ShadcnButtonVariant.outline,
                  size: ShadcnButtonSize.sm,
                  onPressed: () => _showMessage(context, 'Agora seguindo @shadcn!'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card com form
          ShadcnCard(
            title: 'Relatar um problema',
            description: 'Com qual área você está tendo problemas?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Área',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['Equipe', 'Cobrança', 'Conta', 'Implantações']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Nível de Segurança',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['Severidade 1', 'Severidade 2', 'Severidade 3', 'Severidade 4']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
              ],
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShadcnButton(
                  text: 'Cancelar',
                  variant: ShadcnButtonVariant.outline,
                  onPressed: () => _showMessage(context, 'Relatório cancelado'),
                ),
                ShadcnButton(
                  text: 'Enviar',
                  onPressed: () => _showMessage(context, 'Relatório de problema enviado com sucesso!'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Card com lista
          ShadcnCard(
            title: 'Vendas Recentes',
            description: 'Você fez 265 vendas este mês.',
            child: Column(
              children: [
                _buildSalesItem(context, 'Olivia Martin', 'olivia.martin@email.com', '+R\$1.999,00'),
                const Divider(),
                _buildSalesItem(context, 'Jackson Lee', 'jackson.lee@email.com', '+R\$39,00'),
                const Divider(),
                _buildSalesItem(context, 'Isabella Nguyen', 'isabella.nguyen@email.com', '+R\$299,00'),
                const Divider(),
                _buildSalesItem(context, 'William Kim', 'will@email.com', '+R\$99,00'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String avatar,
    String title,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              avatar,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesItem(
    BuildContext context,
    String name,
    String email,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            child: Text(
              name[0],
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
