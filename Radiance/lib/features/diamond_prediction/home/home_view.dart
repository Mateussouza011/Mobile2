import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';
import 'home_delegate.dart';
import '../../../ui/widgets/shadcn/shadcn.dart';
import '../../../ui/widgets/theme_toggle/theme_toggle.dart';
import '../../../core/theme/colors.dart';

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
                const Text('Diamond Predictor'),
              ],
            ),
            actions: [
              const ThemeToggleButton(size: 36),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => widget.delegate.loadStats(),
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
                tooltip: 'Logout',
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
                                title: 'Error',
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
          'Track your predictions and make new diamond price queries.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildStatsCards(HomeViewModel viewModel, ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cards = <Widget>[
      _buildStatCard(
        Icons.analytics_outlined,
        'Total Predictions',
        viewModel.totalPredictions.toString(),
        colorScheme.primary,
        colorScheme,
        textTheme,
      ),
      _buildStatCard(
        Icons.attach_money,
        'Average Price',
        viewModel.averagePrice > 0 ? '\$${viewModel.averagePrice.toStringAsFixed(2)}' : '--',
        isDark ? ShadcnColors.chart[2] : ShadcnColors.chart[2],
        colorScheme,
        textTheme,
      ),
      _buildStatCard(
        Icons.calendar_today_outlined,
        'Last Query',
        viewModel.lastPrediction != null ? _formatDate(viewModel.lastPrediction!.createdAt) : '--',
        isDark ? ShadcnColors.chart[3] : ShadcnColors.chart[3],
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
              color: iconColor.withValues(alpha: 0.1),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final cards = <Widget>[
      _buildPrimaryActionCard(
        icon: Icons.add_circle_outline,
        title: 'New Prediction',
        description: 'Calculate the value of a new diamond based on its characteristics',
        onTap: () => widget.delegate.navigateToPrediction(),
        colorScheme: colorScheme,
        textTheme: textTheme,
        isDark: isDark,
      ),
      _buildActionCard(
        Icons.history,
        'View History',
        'Check all your previous predictions',
        isDark ? ShadcnColors.chart[0] : ShadcnColors.chart[0],
        () => widget.delegate.navigateToHistory(),
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

  Widget _buildPrimaryActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ]
                  : [
                      colorScheme.primary.withValues(alpha: 0.1),
                      colorScheme.primary.withValues(alpha: 0.02),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'AI',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
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
                color: iconColor.withValues(alpha: 0.1),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Prediction', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
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
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.diamond, color: colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${prediction.carat} carats', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      Text('${prediction.cut} - ${prediction.color} - ${prediction.clarity}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${prediction.predictedPrice.toStringAsFixed(2)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? ShadcnColors.chart[2] : ShadcnColors.chart[2],
                    ),
                  ),
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

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.delegate.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

