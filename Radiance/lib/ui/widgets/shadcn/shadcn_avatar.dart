import 'package:flutter/material.dart';

enum ShadcnAvatarSize {
  sm,
  md,
  lg,
  xl,
}

class ShadcnAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final ShadcnAvatarSize size;
  final Color? backgroundColor;

  const ShadcnAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = ShadcnAvatarSize.md,
    this.backgroundColor,
  });

  double get _size {
    switch (size) {
      case ShadcnAvatarSize.sm:
        return 32.0;
      case ShadcnAvatarSize.md:
        return 40.0;
      case ShadcnAvatarSize.lg:
        return 56.0;
      case ShadcnAvatarSize.xl:
        return 80.0;
    }
  }

  double get _fontSize {
    switch (size) {
      case ShadcnAvatarSize.sm:
        return 12.0;
      case ShadcnAvatarSize.md:
        return 16.0;
      case ShadcnAvatarSize.lg:
        return 20.0;
      case ShadcnAvatarSize.xl:
        return 28.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: _size,
      height: _size,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: backgroundColor ?? colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(_size / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_size / 2),
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  width: _size,
                  height: _size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildFallback(colorScheme),
                )
              : _buildFallback(colorScheme),
        ),
      ),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Center(
        child: initials != null
            ? Text(
                initials!.toUpperCase(),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            : Icon(
                Icons.person,
                color: colorScheme.onSurfaceVariant,
                size: _size * 0.6,
              ),
      ),
    );
  }
}