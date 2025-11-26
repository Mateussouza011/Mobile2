import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_card.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHero(context, colorScheme, textTheme, isDesktop),
                  const SizedBox(height: 48),
                  _buildFeatures(context, colorScheme, textTheme, isDesktop),
                  const SizedBox(height: 48),
                  _buildActions(context, colorScheme),
                  const SizedBox(height: 32),
                  _buildDesignSystemLink(context, colorScheme, textTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    return Column(
      children: [
        Container(
          width: isDesktop ? 200 : 160,
          height: isDesktop ? 200 : 160,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
            border: Border.all(
              color: colorScheme.surface,
              width: 4,
            ),
          ),
          child: SvgPicture.asset(
            'assets/images/diamond.svg',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'Diamond Price Predictor',
          style: (isDesktop ? textTheme.displaySmall : textTheme.headlineMedium)?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Descubra o valor real do seu diamante com nossa Inteligência Artificial avançada. Precisão, rapidez e confiança em cada avaliação.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    final features = [
      (Icons.auto_awesome, 'IA Avancada', 'Modelo treinado com milhares de diamantes'),
      (Icons.speed, 'Resultado Instantaneo', 'Obtenha estimativas em segundos'),
      (Icons.history, 'Historico Completo', 'Salve e acompanhe suas consultas'),
    ];

    if (isDesktop) {
      return Row(
        children: features.map((f) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildFeatureCard(context, colorScheme, textTheme, f.$1, f.$2, f.$3),
          ),
        )).toList(),
      );
    }

    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildFeatureCard(context, colorScheme, textTheme, f.$1, f.$2, f.$3),
      )).toList(),
    );
  }

  Widget _buildFeatureCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, IconData icon, String title, String description) {
    return ShadcnCard(
      variant: ShadcnCardVariant.outlined,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        SizedBox(
          width: 280,
          child: ShadcnButton(
            text: 'Comecar Agora',
            leadingIcon: const Icon(Icons.arrow_forward, size: 18),
            onPressed: () => context.go('/diamond-login'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          child: ShadcnButton(
            text: 'Criar Conta',
            variant: ShadcnButtonVariant.outline,
            onPressed: () => context.go('/auth/register'),
          ),
        ),
      ],
    );
  }

  Widget _buildDesignSystemLink(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Construido com nosso Design System',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        ShadcnButton(
          text: 'Ver Componentes',
          variant: ShadcnButtonVariant.ghost,
          size: ShadcnButtonSize.sm,
          trailingIcon: const Icon(Icons.open_in_new, size: 14),
          onPressed: () => context.go('/design-system'),
        ),
      ],
    );
  }
}
