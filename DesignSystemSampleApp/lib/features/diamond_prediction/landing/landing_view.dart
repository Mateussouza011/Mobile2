import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'landing_view_model.dart';

/// LandingView - Design moderno, minimalista e elegante
/// 
/// Inspirado no estilo visual shadcn/iOS com:
/// - Layout simétrico e limpo
/// - Cores neutras com acentos sutis
/// - Tipografia refinada
/// - Micro-interações suaves
class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
    
    // Inicializa o ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandingViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Configura a status bar para modo escuro
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final viewModel = context.watch<LandingViewModel>();
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height - MediaQuery.of(context).padding.top,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // Logo/Icon
              _buildLogo(),
              
              const SizedBox(height: 48),
              
              // Headline
              _buildHeadline(),
              
              const SizedBox(height: 16),
              
              // Subheadline
              _buildSubheadline(),
              
              const SizedBox(height: 48),
              
              // Features
              _buildFeatures(viewModel),
              
              const SizedBox(height: 56),
              
              // CTA Button
              _buildCTAButton(viewModel),
              
              const SizedBox(height: 16),
              
              // Secondary link
              _buildSecondaryLink(viewModel),
              
              const SizedBox(height: 48),
              
              // Trust badges
              _buildTrustBadges(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF18181B), Color(0xFF3F3F46)],
          ).createShader(bounds),
          child: const Icon(
            Icons.diamond_outlined,
            size: 36,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'Diamond Price\nPrediction',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF18181B),
        height: 1.2,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSubheadline() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Text(
        'Descubra o valor real do seu diamante com precisão usando inteligência artificial.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF71717A),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatures(LandingViewModel viewModel) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: viewModel.features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FeatureCard(feature: feature),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCTAButton(LandingViewModel viewModel) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      width: double.infinity,
      child: _PrimaryButton(
        label: 'Começar',
        onPressed: viewModel.getStarted,
      ),
    );
  }

  Widget _buildSecondaryLink(LandingViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.learnMore,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Como funciona?',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TrustBadge(icon: Icons.verified_outlined, label: 'Verificado'),
        const SizedBox(width: 24),
        _TrustBadge(icon: Icons.lock_outline, label: 'Seguro'),
        const SizedBox(width: 24),
        _TrustBadge(icon: Icons.speed_outlined, label: 'Rápido'),
      ],
    );
  }
}

/// Card de Feature - Design minimalista
class _FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE4E4E7),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              size: 22,
              color: const Color(0xFF18181B),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF18181B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF71717A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Color(0xFFA1A1AA),
          ),
        ],
      ),
    );
  }
}

/// Botão Primário - Estilo shadcn
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _isPressed 
              ? const Color(0xFF27272A) 
              : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge de Confiança
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFFA1A1AA),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA1A1AA),
          ),
        ),
      ],
    );
  }
}
