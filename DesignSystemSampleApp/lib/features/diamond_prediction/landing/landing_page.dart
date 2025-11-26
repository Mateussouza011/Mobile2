import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// LandingPage - Página inicial do Diamond Price Prediction App
/// 
/// Apresenta o aplicativo e direciona o usuário para o login.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Ícone do diamante animado
                    _buildDiamondIcon(),
                    
                    const SizedBox(height: 40),
                    
                    // Título principal
                    Text(
                      'Diamond Price',
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    // Subtítulo
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF00d4ff), Color(0xFF7c3aed)],
                      ).createShader(bounds),
                      child: Text(
                        'Prediction',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Descrição
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        'Descubra o valor do seu diamante com precisão usando nossa tecnologia de Machine Learning avançada.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Features cards
                    _buildFeaturesSection(),
                    
                    const SizedBox(height: 48),
                    
                    // Botão de começar
                    _buildStartButton(context),
                    
                    const SizedBox(height: 24),
                    
                    // Link secundário
                    TextButton(
                      onPressed: () {
                        // Poderia levar para uma página de informações
                      },
                      child: Text(
                        'Saiba mais sobre nossa tecnologia',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF00d4ff),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Footer
                    _buildFooter(),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiamondIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00d4ff).withOpacity(0.2),
            const Color(0xFF7c3aed).withOpacity(0.2),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00d4ff).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00d4ff).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.diamond_outlined,
          size: 60,
          color: Color(0xFF00d4ff),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': Icons.psychology_outlined,
        'title': 'IA Avançada',
        'description': 'Modelos de ML treinados com milhares de diamantes',
      },
      {
        'icon': Icons.speed_outlined,
        'title': 'Resultado Instantâneo',
        'description': 'Obtenha a predição em segundos',
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Alta Precisão',
        'description': 'Algoritmos otimizados para máxima acurácia',
      },
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: features.map((feature) => _buildFeatureCard(
        icon: feature['icon'] as IconData,
        title: feature['title'] as String,
        description: feature['description'] as String,
      )).toList(),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF7c3aed).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00d4ff),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/diamond-login'),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7c3aed), Color(0xFF00d4ff)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7c3aed).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Começar Agora',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterIcon(Icons.security_outlined),
            const SizedBox(width: 24),
            _buildFooterIcon(Icons.lock_outline),
            const SizedBox(width: 24),
            _buildFooterIcon(Icons.verified_user_outlined),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '© 2025 Diamond Price Prediction. Todos os direitos reservados.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Colors.white38,
        size: 20,
      ),
    );
  }
}
