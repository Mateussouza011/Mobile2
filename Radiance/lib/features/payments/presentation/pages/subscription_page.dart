import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../multi_tenant/domain/entities/subscription.dart';
import '../../domain/entities/subscription_data.dart';
import '../providers/payment_provider.dart';
import '../../../../core/theme/radiance_colors.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  BillingInterval _selectedInterval = BillingInterval.monthly;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().loadCurrentSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos e Assinatura'),
        centerTitle: true,
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentPlanBanner(context, provider),
                const SizedBox(height: 32),
                _buildBillingToggle(),
                const SizedBox(height: 24),
                _buildPricingCards(context, provider),
                const SizedBox(height: 32),
                _buildFeatureComparison(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPlanBanner(BuildContext context, PaymentProvider provider) {
    final subscription = provider.currentSubscription;
    
    if (subscription == null) {
      return Card(
        color: RadianceColors.warning.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: RadianceColors.warning),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Você ainda não possui uma assinatura ativa.'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: RadianceColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: _getTierColor(subscription.tier),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plano ${_getTierName(subscription.tier)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Renovação: ${_formatDate(subscription.currentPeriodEnd)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(subscription.status),
              ],
            ),
            const SizedBox(height: 16),
            _buildUsageLimits(context, subscription),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(SubscriptionStatus status) {
    Color color;
    String label;

    switch (status) {
      case SubscriptionStatus.active:
        color = RadianceColors.success;
        label = 'Ativa';
        break;
      case SubscriptionStatus.trialing:
        color = RadianceColors.info;
        label = 'Trial';
        break;
      case SubscriptionStatus.pastDue:
        color = RadianceColors.warning;
        label = 'Pagamento Pendente';
        break;
      case SubscriptionStatus.cancelled:
        color = RadianceColors.error;
        label = 'Cancelada';
        break;
      case SubscriptionStatus.expired:
        color = Colors.grey;
        label = 'Expirada';
        break;
      case SubscriptionStatus.suspended:
        color = RadianceColors.warning;
        label = 'Suspensa';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildUsageLimits(BuildContext context, Subscription subscription) {
    final limits = subscription.limits;
    
    return Column(
      children: [
        _buildLimitRow(
          'Usuários',
          limits.hasUnlimitedUsers ? 'Ilimitados' : '${limits.maxUsers}',
          Icons.people,
        ),
        const SizedBox(height: 8),
        _buildLimitRow(
          'Previsões/mês',
          limits.hasUnlimitedPredictions 
              ? 'Ilimitadas' 
              : '${limits.maxPredictionsPerMonth}',
          Icons.analytics,
        ),
      ],
    );
  }

  Widget _buildLimitRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: RadianceColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: RadianceColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBillingToggle() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(
              'Mensal',
              _selectedInterval == BillingInterval.monthly,
              () => setState(() => _selectedInterval = BillingInterval.monthly),
            ),
            _buildToggleButton(
              'Anual (17% OFF)',
              _selectedInterval == BillingInterval.yearly,
              () => setState(() => _selectedInterval = BillingInterval.yearly),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? RadianceColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCards(BuildContext context, PaymentProvider provider) {
    final currentTier = provider.currentTier;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildPricingCard(
            context,
            tier: SubscriptionTier.free,
            name: 'Free',
            price: 'R\$ 0',
            period: '/mês',
            features: [
              '10 previsões/mês',
              '1 usuário',
              'Dashboard básico',
              'Suporte por email',
            ],
            isCurrentPlan: currentTier == SubscriptionTier.free,
            provider: provider,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPricingCard(
            context,
            tier: SubscriptionTier.pro,
            name: 'Pro',
            price: _selectedInterval == BillingInterval.yearly
                ? 'R\$ 499'
                : 'R\$ 49,90',
            period: _selectedInterval == BillingInterval.yearly ? '/ano' : '/mês',
            features: [
              '100 previsões/mês',
              'Até 5 usuários',
              'Export PDF/CSV',
              'Análises avançadas',
              'Suporte prioritário',
            ],
            isCurrentPlan: currentTier == SubscriptionTier.pro,
            isRecommended: true,
            provider: provider,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildPricingCard(
            context,
            tier: SubscriptionTier.enterprise,
            name: 'Enterprise',
            price: _selectedInterval == BillingInterval.yearly
                ? 'R\$ 2.999'
                : 'R\$ 299,90',
            period: _selectedInterval == BillingInterval.yearly ? '/ano' : '/mês',
            features: [
              'Previsões ilimitadas',
              'Usuários ilimitados',
              'API Access',
              'White-label',
              'Suporte 24/7',
              'Gerente dedicado',
            ],
            isCurrentPlan: currentTier == SubscriptionTier.enterprise,
            provider: provider,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    BuildContext context, {
    required SubscriptionTier tier,
    required String name,
    required String price,
    required String period,
    required List<String> features,
    required bool isCurrentPlan,
    required PaymentProvider provider,
    bool isRecommended = false,
  }) {
    return Card(
      elevation: isRecommended ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isRecommended ? RadianceColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RadianceColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RECOMENDADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isRecommended) const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getTierColor(tier),
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  period,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            if (_selectedInterval == BillingInterval.yearly && tier != SubscriptionTier.free)
              Text(
                'Economia de 17%',
                style: TextStyle(
                  color: RadianceColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 24),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: RadianceColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrentPlan
                    ? null
                    : () => _handlePlanSelection(context, tier, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentPlan
                      ? Colors.grey
                      : (isRecommended ? RadianceColors.primary : null),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isCurrentPlan ? 'Plano Atual' : 'Selecionar',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparação de Recursos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            _buildComparisonTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    final features = [
      ('Previsões por mês', '10', '100', 'Ilimitadas'),
      ('Usuários', '1', '5', 'Ilimitados'),
      ('Dashboard', '✓', '✓', '✓'),
      ('Export PDF/CSV', '✗', '✓', '✓'),
      ('Análises avançadas', '✗', '✓', '✓'),
      ('API Access', '✗', '✗', '✓'),
      ('White-label', '✗', '✗', '✓'),
      ('Suporte', 'Email', 'Prioritário', '24/7'),
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[100]),
          children: [
            _buildTableHeader('Recurso'),
            _buildTableHeader('Free'),
            _buildTableHeader('Pro'),
            _buildTableHeader('Enterprise'),
          ],
        ),
        ...features.map((feature) => TableRow(
              children: [
                _buildTableCell(feature.$1, bold: true),
                _buildTableCell(feature.$2),
                _buildTableCell(feature.$3),
                _buildTableCell(feature.$4),
              ],
            )),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(fontWeight: bold ? FontWeight.w600 : FontWeight.normal),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handlePlanSelection(
    BuildContext context,
    SubscriptionTier tier,
    PaymentProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ConfirmPlanDialog(
        tier: tier,
        billingInterval: _selectedInterval,
        provider: provider,
      ),
    );
  }

  Color _getTierColor(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return RadianceColors.subscriptionFree;
      case SubscriptionTier.pro:
        return RadianceColors.subscriptionPro;
      case SubscriptionTier.enterprise:
        return RadianceColors.subscriptionEnterprise;
    }
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ConfirmPlanDialog extends StatefulWidget {
  final SubscriptionTier tier;
  final BillingInterval billingInterval;
  final PaymentProvider provider;

  const _ConfirmPlanDialog({
    required this.tier,
    required this.billingInterval,
    required this.provider,
  });

  @override
  State<_ConfirmPlanDialog> createState() => _ConfirmPlanDialogState();
}

class _ConfirmPlanDialogState extends State<_ConfirmPlanDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final pricing = SubscriptionPricing.getByTier(widget.tier.name);
    final amount = widget.billingInterval == BillingInterval.yearly
        ? pricing?.yearlyPrice
        : pricing?.monthlyPrice;

    return AlertDialog(
      title: const Text('Confirmar Assinatura'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plano: ${_getTierName(widget.tier)}'),
          Text('Valor: R\$ ${amount?.toStringAsFixed(2)}'),
          Text(
            'Cobrança: ${widget.billingInterval == BillingInterval.yearly ? "Anual" : "Mensal"}',
          ),
          const SizedBox(height: 16),
          const Text(
            'Deseja confirmar a contratação deste plano?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _handleConfirm,
          child: _isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar'),
        ),
      ],
    );
  }

  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);

    final result = await widget.provider.createSubscription(
      tier: widget.tier,
      billingInterval: widget.billingInterval,
      startTrial: widget.tier != SubscriptionTier.free,
      trialDays: 14,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${failure.toString()}'),
            backgroundColor: RadianceColors.error,
          ),
        );
      },
      (subscription) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Assinatura criada com sucesso!'),
            backgroundColor: RadianceColors.success,
          ),
        );
      },
    );
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
