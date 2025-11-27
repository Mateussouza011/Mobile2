import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';
import 'home_delegate.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import '../../../ui/widgets/shadcn/shadcn_alert.dart';

class HomeView extends StatefulWidget {
  final HomeDelegate delegate;

  const HomeView({super.key, required this.delegate});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.delegate.loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 800;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.diamond_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Radiance'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => widget.delegate.loadStats(),
                tooltip: 'Atualizar',
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
                tooltip: 'Sair',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcome(viewModel, colorScheme, textTheme),
                            const SizedBox(height: 24),
                            if (viewModel.errorMessage != null) ...[
                              ShadcnAlert(
                                variant: ShadcnAlertVariant.destructive,
                                title: 'Erro',
                                description: viewModel.errorMessage!,
                              ),
                              const SizedBox(height: 24),
                            ],
                            _buildStatsCards(viewModel, colorScheme, textTheme, isDesktop),
                            const SizedBox(height: 32),
                            _buildActionCards(colorScheme, textTheme, isDesktop),
                            const SizedBox(height: 32),
                            if (viewModel.lastPrediction != null)
                              _buildLastPrediction(viewModel, colorScheme, textTheme),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildWelcome(HomeViewModel viewModel, ColorScheme colorScheme, TextTheme textTheme) {
    final user = viewModel.currentUser;
    final greeting = _getGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting${user != null ? ', ${user.name.split(' ').first}' : ''}!',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Acompanhe suas previsoes e faca novas consultas de precos de diamantes.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  Widget _buildStatsCards(HomeViewModel viewModel, ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    final cards = <Widget>[
      _buildStatCard(
        Icons.analytics_outlined,
        'Total de Predicoes',
        viewModel.totalPredictions.toString(),
        colorScheme.primary,
        colorScheme,
        textTheme,
      ),
      _buildStatCard(
        Icons.attach_money,
        'Preco Medio',
        viewModel.averagePrice > 0 ? '\$${viewModel.averagePrice.toStringAsFixed(2)}' : '--',
        Colors.green,
        colorScheme,
        textTheme,
      ),
      _buildStatCard(
        Icons.calendar_today_outlined,
        'Ultima Consulta',
        viewModel.lastPrediction != null ? _formatDate(viewModel.lastPrediction!.createdAt) : '--',
        Colors.orange,
        colorScheme,
        textTheme,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: card))).toList(),
      );
    }

    return Column(
      children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 16), child: card)).toList(),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color iconColor, ColorScheme colorScheme, TextTheme textTheme) {
    return ShadcnCard(
      variant: ShadcnCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    final cards = <Widget>[
      _buildActionCard(
        Icons.add_circle_outline,
        'Nova Predicao',
        'Calcule o valor de um novo diamante com base em suas caracteristicas',
        colorScheme.primary,
        () => widget.delegate.navigateToPrediction(),
        colorScheme,
        textTheme,
      ),
      _buildActionCard(
        Icons.history,
        'Ver Historico',
        'Consulte todas as suas predicoes anteriores',
        Colors.purple,
        () => widget.delegate.navigateToHistory(),
        colorScheme,
        textTheme,
      ),
      _buildActionCard(
        Icons.groups_outlined,
        'Team Dashboard',
        'Acompanhe metricas e atividades da equipe',
        Colors.blue,
        () => widget.delegate.navigateToTeamDashboard(),
        colorScheme,
        textTheme,
      ),
      _buildActionCard(
        Icons.key_outlined,
        'API Keys',
        'Gerencie suas chaves de API para integracao',
        Colors.teal,
        () => widget.delegate.navigateToApiKeys(),
        colorScheme,
        textTheme,
      ),
      _buildActionCard(
        Icons.file_download_outlined,
        'Exportar Relatorios',
        'Exporte suas previsoes em PDF ou CSV',
        Colors.orange,
        () => widget.delegate.navigateToExport(),
        colorScheme,
        textTheme,
      ),
      _buildActionCard(
        Icons.person_add_outlined,
        'Convidar Membros',
        'Gerencie convites para sua equipe',
        Colors.indigo,
        () => widget.delegate.navigateToTeamInvitations(),
        colorScheme,
        textTheme,
      ),
    ];

    if (isDesktop) {
      // Em desktop, mostrar 2 linhas com 3 cards cada
      return Column(
        children: [
          Row(
            children: cards.take(3).map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: card))).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: cards.skip(3).take(3).map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: card))).toList(),
          ),
        ],
      );
    }

    return Column(
      children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 16), child: card)).toList(),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String description, Color iconColor, VoidCallback onTap, ColorScheme colorScheme, TextTheme textTheme) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ShadcnCard(
        variant: ShadcnCardVariant.outlined,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  const SizedBox(height: 4),
                  Text(description, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: colorScheme.onSurfaceVariant, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLastPrediction(HomeViewModel viewModel, ColorScheme colorScheme, TextTheme textTheme) {
    final prediction = viewModel.lastPrediction!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ultima Predicao', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        const SizedBox(height: 16),
        ShadcnCard(
          variant: ShadcnCardVariant.outlined,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.diamond, color: colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${prediction.carat} quilates', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      Text('${prediction.cut} - ${prediction.color} - ${prediction.clarity}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${prediction.predictedPrice.toStringAsFixed(2)}', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
                  Text(_formatDate(prediction.createdAt), style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Hoje';
    if (difference.inDays == 1) return 'Ontem';
    if (difference.inDays < 7) return 'Ha ${difference.inDays} dias';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.delegate.logout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
