import 'package:flutter/material.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import 'home_view_model.dart';

/// HomeView - Tela principal (Dashboard) do Diamond Prediction App
/// 
/// Exibe estatísticas de predições e atalhos para funcionalidades.
/// Implementa o Design System Shadcn/UI.
class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;
  
  const HomeView({
    super.key,
    required this.viewModel,
  });
  
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Registra callback e carrega dados
    widget.viewModel.onStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
    // Carrega dados ao iniciar
    widget.viewModel.loadDashboardData();
  }
  
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.diamond, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Diamond Prediction'),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.onRefreshRequested(
              sender: widget.viewModel,
            ),
            tooltip: 'Atualizar',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => widget.viewModel.onLogoutRequested(
              sender: widget.viewModel,
            ),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: widget.viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                widget.viewModel.onRefreshRequested(sender: widget.viewModel);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saudação
                    _buildWelcomeSection(context),
                    
                    const SizedBox(height: 32),
                    
                    // Cards de estatísticas
                    _buildStatsSection(context),
                    
                    const SizedBox(height: 32),
                    
                    // Ações rápidas
                    _buildActionsSection(context),
                    
                    const SizedBox(height: 32),
                    
                    // Última predição
                    if (widget.viewModel.lastPrediction != null)
                      _buildLastPredictionSection(context),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildWelcomeSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = widget.viewModel;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${viewModel.userName}!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bem-vindo ao sistema de predição de preços de diamantes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatsSection(BuildContext context) {
    final viewModel = widget.viewModel;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estatísticas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.analytics,
                iconColor: Colors.blue,
                title: 'Total de Predições',
                value: viewModel.totalPredictions.toString(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.attach_money,
                iconColor: Colors.green,
                title: 'Preço Médio',
                value: viewModel.hasData
                    ? viewModel.formatPrice(viewModel.averagePrice)
                    : '-',
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ShadcnCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ShadcnButton(
                text: 'Nova Predição',
                leadingIcon: const Icon(Icons.add, size: 18),
                onPressed: () => widget.viewModel.onNewPredictionRequested(
                  sender: widget.viewModel,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ShadcnButton(
                text: 'Ver Histórico',
                variant: ShadcnButtonVariant.outline,
                leadingIcon: const Icon(Icons.history, size: 18),
                onPressed: () => widget.viewModel.onHistoryRequested(
                  sender: widget.viewModel,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLastPredictionSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final prediction = widget.viewModel.lastPrediction!;
    final price = (prediction['predicted_price'] as num?)?.toDouble() ?? 0.0;
    final input = prediction['input'] as Map<String, dynamic>?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Última Predição',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ShadcnCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preço Estimado',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.viewModel.formatPrice(price),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (input != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(context, 'Carat', '${input['carat']}'),
                    _buildInfoChip(context, 'Cut', '${input['cut']}'),
                    _buildInfoChip(context, 'Color', '${input['color']}'),
                    _buildInfoChip(context, 'Clarity', '${input['clarity']}'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoChip(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
