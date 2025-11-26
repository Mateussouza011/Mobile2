import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_view_model_new.dart';

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
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: viewModel.isLoading
            ? _buildLoading()
            : RefreshIndicator(
                onRefresh: viewModel.refresh,
                color: const Color(0xFF18181B),
                child: _buildContent(context, viewModel),
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF18181B),
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
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                viewModel.userName[0].toUpperCase(),
                style: GoogleFonts.inter(
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
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF18181B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bem-vindo de volta',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF71717A),
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
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 18,
                color: Color(0xFF71717A),
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
            color: const Color(0xFF18181B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nova Predição',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Descubra o valor do seu diamante',
                      style: GoogleFonts.inter(
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
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF18181B),
            ),
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF71717A),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF71717A),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isSmallText ? 14 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF18181B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF71717A),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E4E7)),
        ),
        child: Row(
          children: [
            // Diamond icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.diamond_outlined,
                size: 22,
                color: Color(0xFF18181B),
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
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF18181B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    viewModel.formatRelativeDate(prediction.date),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF71717A),
                    ),
                  ),
                ],
              ),
            ),
            
            // Price
            Text(
              viewModel.formatPrice(prediction.predictedPrice),
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF18181B),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFFA1A1AA),
            ),
          ],
        ),
      ),
    );
  }
}
