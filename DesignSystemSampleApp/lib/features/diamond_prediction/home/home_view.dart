import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../DesignSystem/Theme/app_theme.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';
import 'home_view_model.dart';

/// HomeView - Dashboard moderno, minimalista e elegante
/// 
/// Inspirado no estilo visual shadcn/iOS com:
/// - Cards com métricas claras
/// - Lista de atividades recentes
/// - Ações rápidas acessíveis
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    final viewModel = context.watch<HomeViewModel>();
    
    return Scaffold(
      backgroundColor: AppColors.zinc50,
      body: SafeArea(
        child: viewModel.isLoading
            ? _buildLoading()
            : RefreshIndicator(
                onRefresh: viewModel.refresh,
                color: AppColors.zinc900,
                child: _buildContent(context, viewModel),
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.zinc900,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeViewModel viewModel) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(viewModel),
        ),
        
        // Quick Actions
        SliverToBoxAdapter(
          child: _buildQuickActions(viewModel),
        ),
        
        // Stats Cards
        SliverToBoxAdapter(
          child: _buildStatsSection(viewModel),
        ),
        
        // Recent Predictions Header
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            title: 'Atividade Recente',
            action: 'Ver tudo',
            onAction: viewModel.viewHistory,
          ),
        ),
        
        // Recent Predictions List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final prediction = viewModel.recentPredictions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PredictionCard(
                    prediction: prediction,
                    viewModel: viewModel,
                    onTap: () => viewModel.openPrediction(prediction),
                  ),
                );
              },
              childCount: viewModel.recentPredictions.length,
            ),
          ),
        ),
        
        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.zinc900,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.zinc900.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                viewModel.userName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${viewModel.userName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.zinc900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Bem-vindo de volta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.zinc500,
                  ),
                ),
              ],
            ),
          ),
          
          // Logout button
          GestureDetector(
            onTap: viewModel.logout,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.zinc200),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: AppColors.zinc500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: GestureDetector(
        onTap: viewModel.newPrediction,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.zinc900,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.zinc900.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nova Predição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Descubra o valor do seu diamante',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: Colors.white60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total',
              value: viewModel.totalPredictions.toString(),
              icon: Icons.analytics_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Média',
              value: viewModel.formatPrice(viewModel.averagePrice),
              icon: Icons.trending_up_rounded,
              isSmallText: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Maior',
              value: viewModel.formatPrice(viewModel.highestPrice),
              icon: Icons.diamond_outlined,
              isSmallText: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String action,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.zinc900,
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.zinc500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card de Estatística
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isSmallText;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.zinc500,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallText ? 14 : 20,
              fontWeight: FontWeight.w700,
              color: AppColors.zinc900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.zinc500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card de Predição Recente
class _PredictionCard extends StatelessWidget {
  final PredictionSummary prediction;
  final HomeViewModel viewModel;
  final VoidCallback onTap;

  const _PredictionCard({
    required this.prediction,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Diamond icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.zinc100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.diamond_outlined,
                  size: 22,
                  color: AppColors.zinc900,
                ),
              ),
              const SizedBox(width: 14),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${prediction.carat} ct • ${prediction.cut}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.zinc900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      viewModel.formatRelativeDate(prediction.date),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.zinc500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price
              Text(
                viewModel.formatPrice(prediction.predictedPrice),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.zinc900,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.zinc400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
