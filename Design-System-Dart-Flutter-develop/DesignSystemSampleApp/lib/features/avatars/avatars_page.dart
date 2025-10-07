import 'package:flutter/material.dart';
import '../../ui/widgets/shadcn/shadcn_avatar.dart';

class AvatarsPage extends StatelessWidget {
  const AvatarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Avatars',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Tamanhos',
            '',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  ShadcnAvatar(
                    initials: 'AB',
                    size: ShadcnAvatarSize.sm,
                  ),
                  ShadcnAvatar(
                    initials: 'CD',
                    size: ShadcnAvatarSize.md,
                  ),
                  ShadcnAvatar(
                    initials: 'EF',
                    size: ShadcnAvatarSize.lg,
                  ),
                  ShadcnAvatar(
                    initials: 'GH',
                    size: ShadcnAvatarSize.xl,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Com Iniciais',
            '',
            [
              const SizedBox(height: 20),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  ShadcnAvatar(
                    initials: 'JD',
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  ShadcnAvatar(
                    initials: 'MS',
                    backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                  ShadcnAvatar(
                    initials: 'AL',
                    backgroundColor: colorScheme.tertiary.withValues(alpha: 0.1),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            context,
            'Fallback',
            '',
            [
              const SizedBox(height: 20),
              const Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  ShadcnAvatar(),
                  ShadcnAvatar(size: ShadcnAvatarSize.lg),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...children,
      ],
    );
  }
}