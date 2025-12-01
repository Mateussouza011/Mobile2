import 'package:flutter/material.dart';
enum ShadcnSeparatorOrientation {
  horizontal,
  vertical,
}
enum ShadcnSeparatorVariant {
  solid,
  dashed,
  dotted,
  gradient,
}
class ShadcnSeparator extends StatelessWidget {
  final ShadcnSeparatorOrientation orientation;
  final ShadcnSeparatorVariant variant;
  final double thickness;
  final double? length;
  final Color? color;
  final List<Color>? gradientColors;
  final double indent;
  final double endIndent;
  final String? label;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;

  const ShadcnSeparator({
    super.key,
    this.orientation = ShadcnSeparatorOrientation.horizontal,
    this.variant = ShadcnSeparatorVariant.solid,
    this.thickness = 1.0,
    this.length,
    this.color,
    this.gradientColors,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.label,
    this.labelStyle,
    this.labelPadding,
  });
  const ShadcnSeparator.horizontal({
    super.key,
    this.variant = ShadcnSeparatorVariant.solid,
    this.thickness = 1.0,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.label,
    this.labelStyle,
    this.labelPadding,
  }) : orientation = ShadcnSeparatorOrientation.horizontal,
       length = null,
       gradientColors = null;
  const ShadcnSeparator.vertical({
    super.key,
    this.variant = ShadcnSeparatorVariant.solid,
    this.thickness = 1.0,
    this.length,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : orientation = ShadcnSeparatorOrientation.vertical,
       gradientColors = null,
       label = null,
       labelStyle = null,
       labelPadding = null;
  const ShadcnSeparator.gradient({
    super.key,
    this.orientation = ShadcnSeparatorOrientation.horizontal,
    required this.gradientColors,
    this.thickness = 1.0,
    this.length,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : variant = ShadcnSeparatorVariant.gradient,
       color = null,
       label = null,
       labelStyle = null,
       labelPadding = null;
  const ShadcnSeparator.dashed({
    super.key,
    this.orientation = ShadcnSeparatorOrientation.horizontal,
    this.thickness = 1.0,
    this.length,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : variant = ShadcnSeparatorVariant.dashed,
       gradientColors = null,
       label = null,
       labelStyle = null,
       labelPadding = null;
  const ShadcnSeparator.dotted({
    super.key,
    this.orientation = ShadcnSeparatorOrientation.horizontal,
    this.thickness = 1.0,
    this.length,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : variant = ShadcnSeparatorVariant.dotted,
       gradientColors = null,
       label = null,
       labelStyle = null,
       labelPadding = null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final separatorColor = color ?? colorScheme.outline;

    if (label != null && orientation == ShadcnSeparatorOrientation.horizontal) {
      return _buildLabeledSeparator(context, separatorColor);
    }

    return _buildSeparator(context, separatorColor);
  }

  Widget _buildLabeledSeparator(BuildContext context, Color separatorColor) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: _buildSeparator(context, separatorColor),
        ),
        Padding(
          padding: labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label!,
            style: labelStyle ?? theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: _buildSeparator(context, separatorColor),
        ),
      ],
    );
  }

  Widget _buildSeparator(BuildContext context, Color separatorColor) {
    final isHorizontal = orientation == ShadcnSeparatorOrientation.horizontal;
    
    return Container(
      margin: EdgeInsets.only(
        left: isHorizontal ? indent : 0,
        right: isHorizontal ? endIndent : 0,
        top: !isHorizontal ? indent : 0,
        bottom: !isHorizontal ? endIndent : 0,
      ),
      child: switch (variant) {
        ShadcnSeparatorVariant.solid => _buildSolidSeparator(separatorColor),
        ShadcnSeparatorVariant.dashed => _buildDashedSeparator(separatorColor),
        ShadcnSeparatorVariant.dotted => _buildDottedSeparator(separatorColor),
        ShadcnSeparatorVariant.gradient => _buildGradientSeparator(),
      },
    );
  }

  Widget _buildSolidSeparator(Color separatorColor) {
    final isHorizontal = orientation == ShadcnSeparatorOrientation.horizontal;
    
    return Container(
      width: isHorizontal ? length : thickness,
      height: isHorizontal ? thickness : length,
      color: separatorColor,
    );
  }

  Widget _buildDashedSeparator(Color separatorColor) {
    final isHorizontal = orientation == ShadcnSeparatorOrientation.horizontal;
    
    return CustomPaint(
      size: Size(
        isHorizontal ? length ?? double.infinity : thickness,
        isHorizontal ? thickness : length ?? 100,
      ),
      painter: _DashedLinePainter(
        color: separatorColor,
        strokeWidth: thickness,
        isHorizontal: isHorizontal,
        dashWidth: 5.0,
        dashSpace: 3.0,
      ),
    );
  }

  Widget _buildDottedSeparator(Color separatorColor) {
    final isHorizontal = orientation == ShadcnSeparatorOrientation.horizontal;
    
    return CustomPaint(
      size: Size(
        isHorizontal ? length ?? double.infinity : thickness,
        isHorizontal ? thickness : length ?? 100,
      ),
      painter: _DottedLinePainter(
        color: separatorColor,
        strokeWidth: thickness,
        isHorizontal: isHorizontal,
        dotRadius: thickness / 2,
        dotSpace: 4.0,
      ),
    );
  }

  Widget _buildGradientSeparator() {
    final isHorizontal = orientation == ShadcnSeparatorOrientation.horizontal;
    
    return Container(
      width: isHorizontal ? length : thickness,
      height: isHorizontal ? thickness : length,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: isHorizontal ? Alignment.centerRight : Alignment.bottomCenter,
          colors: gradientColors ?? [Colors.transparent, Colors.grey, Colors.transparent],
        ),
      ),
    );
  }
}
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isHorizontal;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.isHorizontal,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final totalLength = isHorizontal ? size.width : size.height;
    final dashPattern = dashWidth + dashSpace;
    final dashCount = (totalLength / dashPattern).floor();

    for (int i = 0; i < dashCount; i++) {
      final startPos = i * dashPattern;
      final endPos = startPos + dashWidth;

      if (isHorizontal) {
        canvas.drawLine(
          Offset(startPos, size.height / 2),
          Offset(endPos, size.height / 2),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(size.width / 2, startPos),
          Offset(size.width / 2, endPos),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isHorizontal;
  final double dotRadius;
  final double dotSpace;

  _DottedLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.isHorizontal,
    required this.dotRadius,
    required this.dotSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final totalLength = isHorizontal ? size.width : size.height;
    final dotPattern = (dotRadius * 2) + dotSpace;
    final dotCount = (totalLength / dotPattern).floor();

    for (int i = 0; i < dotCount; i++) {
      final centerPos = i * dotPattern + dotRadius;

      final center = isHorizontal
          ? Offset(centerPos, size.height / 2)
          : Offset(size.width / 2, centerPos);

      canvas.drawCircle(center, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class ShadcnSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final bool showTopSeparator;
  final bool showBottomSeparator;
  final ShadcnSeparatorVariant separatorVariant;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const ShadcnSection({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.showTopSeparator = false,
    this.showBottomSeparator = true,
    this.separatorVariant = ShadcnSeparatorVariant.solid,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopSeparator) ...[
          ShadcnSeparator(variant: separatorVariant),
          const SizedBox(height: 24),
        ],
        
        if (title != null || subtitle != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: titleStyle ?? theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: subtitleStyle ?? theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        child,
        
        if (showBottomSeparator) ...[
          const SizedBox(height: 24),
          ShadcnSeparator(variant: separatorVariant),
        ],
      ],
    );
  }
}