import 'package:flutter/material.dart';

class ShadcnProgress extends StatelessWidget {
  final double value;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const ShadcnProgress({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? colorScheme.primary,
          ),
        ),
      ),
    );
  }
}