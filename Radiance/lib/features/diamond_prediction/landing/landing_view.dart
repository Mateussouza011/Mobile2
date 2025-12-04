import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../navigation/diamond_coordinator.dart';
import '../../auth/navigation/auth_coordinator.dart';
import '../../../ui/widgets/shadcn/shadcn.dart';

class LandingView extends StatelessWidget {
  final DiamondCoordinator diamondCoordinator;
  final AuthCoordinator authCoordinator;

  const LandingView({
    super.key,
    required this.diamondCoordinator,
    required this.authCoordinator,
  });

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
          width: isDesktop ? 120 : 100,
          height: isDesktop ? 120 : 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.6),
                ShadcnColors.chart[0].withValues(alpha: 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.diamond_outlined,
            size: isDesktop ? 56 : 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Diamond Price Predictor',
          style: (isDesktop ? textTheme.headlineLarge : textTheme.headlineMedium)?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Use artificial intelligence to estimate diamond values based on their physical characteristics.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatures(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, bool isDesktop) {
    final features = [
      (Icons.auto_awesome, 'Advanced AI', 'Model trained with thousands of diamonds'),
      (Icons.speed, 'Instant Results', 'Get estimates in seconds'),
      (Icons.history, 'Complete History', 'Save and track your queries'),
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
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
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
            text: 'Get Started',
            leadingIcon: const Icon(Icons.arrow_forward, size: 18),
            onPressed: () => authCoordinator.goToLogin(),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          child: ShadcnButton(
            text: 'Create Account',
            variant: ShadcnButtonVariant.outline,
            onPressed: () => authCoordinator.goToRegister(),
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
          'Built with our Design System',
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        ShadcnButton(
          text: 'View Components',
          variant: ShadcnButtonVariant.ghost,
          size: ShadcnButtonSize.sm,
          trailingIcon: const Icon(Icons.open_in_new, size: 14),
          onPressed: () => diamondCoordinator.goToHome(),
        ),
      ],
    );
  }
}
