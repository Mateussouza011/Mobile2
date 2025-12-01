import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/radiance_colors.dart';
import '../providers/admin_subscription_provider.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../domain/entities/admin_subscription_stats.dart';

class AdminSubscriptionsPage extends StatefulWidget {
  const AdminSubscriptionsPage({super.key});

  @override
  State<AdminSubscriptionsPage> createState() => _AdminSubscriptionsPageState();
}

class _AdminSubscriptionsPageState extends State<AdminSubscriptionsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminSubscriptionProvider>().loadSubscriptions();
      context.read<AdminSubscriptionProvider>().loadSystemStats();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Assinaturas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AdminSubscriptionProvider>().loadSubscriptions();
              context.read<AdminSubscriptionProvider>().loadSystemStats();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatsRow(),
          Expanded(child: _buildSubscriptionsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por empresa...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<AdminSubscriptionProvider>().searchSubscriptions('');
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          if (value.length >= 3 || value.isEmpty) {
            context.read<AdminSubscriptionProvider>().searchSubscriptions(value);
          }
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer<AdminSubscriptionProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatCard(
                  'Total',
                  provider.totalSubscriptions.toString(),
                  Icons.subscriptions,
                  RadianceColors.primary,
                ),
                const SizedBox(width: 8),
                _buildStatCard(
                  'Ativas',
                  provider.activeSubscriptions.toString(),
                  Icons.check_circle,
                  RadianceColors.success,
                ),
                const SizedBox(width: 8),
                _buildStatCard(
                  'Vencidas',
                  provider.overdueSubscriptions.toString(),
                  Icons.warning,
                  RadianceColors.warning,
                ),
                const SizedBox(width: 8),
                _buildStatCard(
                  'MRR',
                  'R\$ ${provider.totalMRR.toStringAsFixed(2)}',
                  Icons.attach_money,
                  RadianceColors.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: RadianceColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsList() {
    return Consumer<AdminSubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: RadianceColors.error),
                const SizedBox(height: 16),
                Text(provider.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadSubscriptions(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (provider.subscriptions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.subscriptions_outlined, size: 64, color: RadianceColors.iconMuted),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma assinatura encontrada',
                  style: TextStyle(color: RadianceColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadSubscriptions(),
          child: ListView.builder(
            itemCount: provider.subscriptions.length,
            itemBuilder: (context, index) {
              final stats = provider.subscriptions[index];
              return _buildSubscriptionCard(stats);
            },
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionCard(AdminSubscriptionStats stats) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showSubscriptionDetails(stats),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: stats.statusColor,
                    child: Icon(
                      stats.subscription.status == SubscriptionStatus.active
                          ? Icons.check
                          : Icons.warning,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.company.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          stats.tierDisplay,
                          style: TextStyle(
                            fontSize: 14,
                            color: stats.tierColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAction(value, stats),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline),
                            SizedBox(width: 8),
                            Text('Ver detalhes'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'upgrade',
                        child: Row(
                          children: [
                            Icon(Icons.upgrade),
                            SizedBox(width: 8),
                            Text('Alterar plano'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: stats.subscription.status == SubscriptionStatus.cancelled
                            ? 'reactivate'
                            : 'cancel',
                        child: Row(
                          children: [
                            Icon(stats.subscription.status == SubscriptionStatus.cancelled
                                ? Icons.play_arrow
                                : Icons.cancel),
                            const SizedBox(width: 8),
                            Text(stats.subscription.status == SubscriptionStatus.cancelled
                                ? 'Reativar'
                                : 'Cancelar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'suspend',
                        child: Row(
                          children: [
                            Icon(Icons.block),
                            SizedBox(width: 8),
                            Text('Suspender'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.attach_money,
                    'MRR: R\$ ${stats.monthlyRecurringRevenue.toStringAsFixed(2)}',
                    RadianceColors.success,
                  ),
                  _buildInfoChip(
                    Icons.monetization_on,
                    'Total: R\$ ${stats.totalRevenue.toStringAsFixed(2)}',
                    RadianceColors.primary,
                  ),
                  _buildInfoChip(
                    Icons.payment,
                    '${stats.successfulPayments} pagamentos',
                    RadianceColors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: stats.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stats.statusDisplay,
                      style: TextStyle(
                        color: stats.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    stats.renewalStatus,
                    style: TextStyle(
                      fontSize: 12,
                      color: stats.needsAttention ? RadianceColors.warning : RadianceColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  void _handleAction(String action, AdminSubscriptionStats stats) {
    switch (action) {
      case 'details':
        _showSubscriptionDetails(stats);
        break;
      case 'upgrade':
        _showTierDialog(stats);
        break;
      case 'cancel':
        _confirmCancel(stats);
        break;
      case 'reactivate':
        _confirmReactivate(stats);
        break;
      case 'suspend':
        _confirmSuspend(stats);
        break;
    }
  }

  void _showSubscriptionDetails(AdminSubscriptionStats stats) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detalhes da Assinatura',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailRow('Empresa', stats.company.name),
                _buildDetailRow('Plano', stats.tierDisplay),
                _buildDetailRow('Status', stats.statusDisplay),
                _buildDetailRow('MRR', 'R\$ ${stats.monthlyRecurringRevenue.toStringAsFixed(2)}'),
                _buildDetailRow('Receita Total', 'R\$ ${stats.totalRevenue.toStringAsFixed(2)}'),
                _buildDetailRow('Pagamentos Bem-sucedidos', stats.successfulPayments.toString()),
                _buildDetailRow('Pagamentos Falhos', stats.failedPayments.toString()),
                if (stats.lastPaymentDate != null)
                  _buildDetailRow('Último Pagamento', _formatDate(stats.lastPaymentDate!)),
                if (stats.nextBillingDate != null)
                  _buildDetailRow('Próxima Cobrança', _formatDate(stats.nextBillingDate!)),
                _buildDetailRow('Dias até Renovação', stats.daysUntilRenewal.toString()),
                _buildDetailRow('Criada em', _formatDate(stats.subscription.createdAt)),
                const SizedBox(height: 16),
                const Text(
                  'Histórico de Pagamentos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                if (stats.paymentHistory.isEmpty)
                  const Center(child: Text('Nenhum pagamento registrado'))
                else
                  ...stats.paymentHistory.map((payment) => ListTile(
                    leading: Icon(
                      payment.status == PaymentStatus.success
                          ? Icons.check_circle
                          : Icons.error,
                      color: payment.statusColor,
                    ),
                    title: Text('R\$ ${payment.amount.toStringAsFixed(2)}'),
                    subtitle: Text(
                      '${payment.statusDisplay} • ${payment.paymentMethodDisplay}\n${_formatDate(payment.createdAt)}',
                    ),
                    trailing: payment.status == PaymentStatus.success
                        ? IconButton(
                            icon: const Icon(Icons.restore),
                            onPressed: () => _confirmRefund(payment.id),
                          )
                        : null,
                  )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showTierDialog(AdminSubscriptionStats stats) {
    showDialog(
      context: context,
      builder: (context) {
        SubscriptionTier? selectedTier = stats.subscription.tier;
        return AlertDialog(
          title: const Text('Alterar Plano'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: SubscriptionTier.values.map((tier) {
                  return RadioListTile<SubscriptionTier>(
                    title: Text(_getTierName(tier)),
                    value: tier,
                    groupValue: selectedTier,
                    onChanged: (value) {
                      setState(() => selectedTier = value);
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedTier != null && selectedTier != stats.subscription.tier) {
                  Navigator.pop(context);
                  final success = await context
                      .read<AdminSubscriptionProvider>()
                      .updateSubscriptionTier(
                        stats.subscription.id,
                        selectedTier!,
                        'admin', // TODO: Get actual admin user ID
                        'Alteração manual via painel admin',
                      );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Plano atualizado com sucesso'
                              : 'Erro ao atualizar plano',
                        ),
                        backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancel(AdminSubscriptionStats stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Assinatura'),
        content: Text(
          'Tem certeza que deseja cancelar a assinatura da empresa ${stats.company.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminSubscriptionProvider>()
                  .cancelSubscription(
                    stats.subscription.id,
                    'admin',
                    'Cancelamento manual via painel admin',
                  );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Assinatura cancelada'
                          : 'Erro ao cancelar',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.error),
            child: const Text('Cancelar Assinatura'),
          ),
        ],
      ),
    );
  }

  void _confirmReactivate(AdminSubscriptionStats stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reativar Assinatura'),
        content: Text(
          'Deseja reativar a assinatura da empresa ${stats.company.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminSubscriptionProvider>()
                  .reactivateSubscription(
                    stats.subscription.id,
                    'admin',
                    'Reativação manual via painel admin',
                  );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Assinatura reativada' : 'Erro ao reativar',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.success),
            child: const Text('Reativar'),
          ),
        ],
      ),
    );
  }

  void _confirmSuspend(AdminSubscriptionStats stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspender Assinatura'),
        content: Text(
          'Tem certeza que deseja suspender a assinatura da empresa ${stats.company.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminSubscriptionProvider>()
                  .suspendSubscription(
                    stats.subscription.id,
                    'admin',
                    'Suspensão manual via painel admin',
                  );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Assinatura suspensa' : 'Erro ao suspender',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.warning),
            child: const Text('Suspender'),
          ),
        ],
      ),
    );
  }

  void _confirmRefund(String paymentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Processar Reembolso'),
        content: const Text(
          'Tem certeza que deseja processar este reembolso? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AdminSubscriptionProvider>()
                  .processRefund(
                    paymentId,
                    'admin',
                    'Reembolso manual via painel admin',
                  );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Reembolso processado'
                          : 'Erro ao processar reembolso',
                    ),
                    backgroundColor: success ? RadianceColors.success : RadianceColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: RadianceColors.error),
            child: const Text('Processar Reembolso'),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: const Text('Filtros em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getTierName(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.pro:
        return 'Pro';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
    }
  }
}
