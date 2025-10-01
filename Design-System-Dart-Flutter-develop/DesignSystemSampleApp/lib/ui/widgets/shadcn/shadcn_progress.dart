import 'package:flutter/material.dart';

/// Variantes visuais do progress
enum ShadcnProgressVariant {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// Tamanhos do progress
enum ShadcnProgressSize {
  sm,
  default_,
  lg,
}

/// Tipos de progress
enum ShadcnProgressType {
  linear,
  circular,
  ring,
}

/// Componente de progresso baseado no Shadcn/UI
class ShadcnProgress extends StatefulWidget {
  final double? value; // null para indeterminate
  final double min;
  final double max;
  final ShadcnProgressVariant variant;
  final ShadcnProgressSize size;
  final ShadcnProgressType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? label;
  final bool showPercentage;
  final Widget? child;
  final Duration? animationDuration;
  final Curve animationCurve;
  final double? strokeWidth;
  final bool animated;

  const ShadcnProgress({
    super.key,
    this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.variant = ShadcnProgressVariant.default_,
    this.size = ShadcnProgressSize.default_,
    this.type = ShadcnProgressType.linear,
    this.backgroundColor,
    this.foregroundColor,
    this.label,
    this.showPercentage = false,
    this.child,
    this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.strokeWidth,
    this.animated = true,
  });

  /// Progress linear determinado
  const ShadcnProgress.linear({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.variant = ShadcnProgressVariant.default_,
    this.size = ShadcnProgressSize.default_,
    this.backgroundColor,
    this.foregroundColor,
    this.label,
    this.showPercentage = false,
    this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.animated = true,
  }) : type = ShadcnProgressType.linear,
       child = null,
       strokeWidth = null;

  /// Progress circular determinado
  const ShadcnProgress.circular({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.variant = ShadcnProgressVariant.default_,
    this.size = ShadcnProgressSize.default_,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.strokeWidth,
    this.animationDuration,
    this.animationCurve = Curves.easeInOut,
    this.animated = true,
  }) : type = ShadcnProgressType.circular,
       label = null,
       showPercentage = false;

  /// Progress indeterminado (loading)
  const ShadcnProgress.indeterminate({
    super.key,
    this.variant = ShadcnProgressVariant.default_,
    this.size = ShadcnProgressSize.default_,
    this.type = ShadcnProgressType.linear,
    this.backgroundColor,
    this.foregroundColor,
    this.strokeWidth,
  }) : value = null,
       min = 0.0,
       max = 100.0,
       label = null,
       showPercentage = false,
       child = null,
       animationDuration = null,
       animationCurve = Curves.easeInOut,
       animated = true;

  @override
  State<ShadcnProgress> createState() => _ShadcnProgressState();
}

class _ShadcnProgressState extends State<ShadcnProgress> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _indeterminateController;
  late Animation<double> _progressAnimation;
  late Animation<double> _indeterminateAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _indeterminateController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.value ?? 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: widget.animationCurve,
    ));
    
    _indeterminateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _indeterminateController,
      curve: Curves.linear,
    ));

    if (widget.value != null && widget.animated) {
      _progressController.forward();
    }
    
    if (widget.value == null) {
      _indeterminateController.repeat();
    }
  }

  @override
  void didUpdateWidget(ShadcnProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.value != oldWidget.value && widget.value != null) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.value!,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: widget.animationCurve,
      ));
      
      if (widget.animated) {
        _progressController.reset();
        _progressController.forward();
      }
    }
    
    // Controlar animação indeterminada
    if (widget.value == null && oldWidget.value != null) {
      _indeterminateController.repeat();
    } else if (widget.value != null && oldWidget.value == null) {
      _indeterminateController.stop();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _indeterminateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      ShadcnProgressType.linear => _buildLinearProgress(context),
      ShadcnProgressType.circular => _buildCircularProgress(context),
      ShadcnProgressType.ring => _buildRingProgress(context),
    };
  }

  Widget _buildLinearProgress(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor) = _getColors(colorScheme);
    
    final height = switch (widget.size) {
      ShadcnProgressSize.sm => 6.0,
      ShadcnProgressSize.default_ => 8.0,
      ShadcnProgressSize.lg => 12.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label e percentual
        if (widget.label != null || widget.showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (widget.showPercentage && widget.value != null)
                Text(
                  '${((widget.value! / widget.max) * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // Barra de progresso
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: widget.value == null 
              ? _buildIndeterminateLinear(foregroundColor, height)
              : _buildDeterminateLinear(foregroundColor, height),
        ),
      ],
    );
  }

  Widget _buildDeterminateLinear(Color foregroundColor, double height) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progress = (_progressAnimation.value - widget.min) / (widget.max - widget.min);
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndeterminateLinear(Color foregroundColor, double height) {
    return AnimatedBuilder(
      animation: _indeterminateAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              left: -100 + (_indeterminateAnimation.value * 200),
              child: Container(
                width: 100,
                height: height,
                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor) = _getColors(colorScheme);
    
    final size = switch (widget.size) {
      ShadcnProgressSize.sm => 32.0,
      ShadcnProgressSize.default_ => 48.0,
      ShadcnProgressSize.lg => 64.0,
    };
    
    final strokeWidth = widget.strokeWidth ?? switch (widget.size) {
      ShadcnProgressSize.sm => 3.0,
      ShadcnProgressSize.default_ => 4.0,
      ShadcnProgressSize.lg => 6.0,
    };

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fundo
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: 1.0,
              color: backgroundColor,
              strokeWidth: strokeWidth,
            ),
          ),
          
          // Círculo de progresso
          if (widget.value != null)
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final progress = (_progressAnimation.value - widget.min) / (widget.max - widget.min);
                return CustomPaint(
                  size: Size(size, size),
                  painter: _CircleProgressPainter(
                    progress: progress.clamp(0.0, 1.0),
                    color: foregroundColor,
                    strokeWidth: strokeWidth,
                  ),
                );
              },
            )
          else
            // Progresso indeterminado circular
            AnimatedBuilder(
              animation: _indeterminateController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _indeterminateAnimation.value * 2 * 3.14159,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: _CircleProgressPainter(
                      progress: 0.25,
                      color: foregroundColor,
                      strokeWidth: strokeWidth,
                    ),
                  ),
                );
              },
            ),
          
          // Conteúdo central
          if (widget.child != null)
            widget.child!
          else if (widget.value != null)
            Text(
              '${((widget.value! / widget.max) * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: switch (widget.size) {
                  ShadcnProgressSize.sm => 10.0,
                  ShadcnProgressSize.default_ => 12.0,
                  ShadcnProgressSize.lg => 14.0,
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRingProgress(BuildContext context) {
    // Similar ao circular, mas com visual de anel mais espesso
    return _buildCircularProgress(context);
  }

  (Color, Color) _getColors(ColorScheme colorScheme) {
    if (widget.backgroundColor != null && widget.foregroundColor != null) {
      return (widget.backgroundColor!, widget.foregroundColor!);
    }

    return switch (widget.variant) {
      ShadcnProgressVariant.default_ => (
        colorScheme.surfaceContainerHighest,
        colorScheme.primary,
      ),
      ShadcnProgressVariant.secondary => (
        colorScheme.surfaceContainerHighest,
        colorScheme.secondary,
      ),
      ShadcnProgressVariant.success => (
        const Color(0xFFDCFCE7),
        const Color(0xFF166534),
      ),
      ShadcnProgressVariant.warning => (
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
      ),
      ShadcnProgressVariant.error => (
        colorScheme.errorContainer,
        colorScheme.error,
      ),
    };
  }
}

/// Painter personalizado para progresso circular
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const startAngle = -1.5708; // -90 graus (topo)
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Componente de progresso em etapas
class ShadcnStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final ShadcnProgressVariant variant;
  final bool showLabels;

  const ShadcnStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.variant = ShadcnProgressVariant.default_,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = switch (variant) {
      ShadcnProgressVariant.default_ => colorScheme.primary,
      ShadcnProgressVariant.secondary => colorScheme.secondary,
      ShadcnProgressVariant.success => const Color(0xFF166534),
      ShadcnProgressVariant.warning => const Color(0xFF92400E),
      ShadcnProgressVariant.error => colorScheme.error,
    };

    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              // Step circle
              final stepIndex = index ~/ 2;
              final isActive = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;
              
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive || isCurrent ? activeColor : colorScheme.surfaceContainerHighest,
                  border: isCurrent && !isActive 
                      ? Border.all(color: activeColor, width: 2)
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isActive
                      ? Icon(
                          Icons.check,
                          color: colorScheme.onPrimary,
                          size: 16,
                        )
                      : Text(
                          '${stepIndex + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isCurrent ? activeColor : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            } else {
              // Connection line
              final stepIndex = index ~/ 2;
              final isActive = stepIndex < currentStep;
              
              return Expanded(
                child: Container(
                  height: 2,
                  color: isActive ? activeColor : colorScheme.surfaceContainerHighest,
                ),
              );
            }
          }),
        ),
        
        if (showLabels && stepLabels != null) ...[
          const SizedBox(height: 12),
          Row(
            children: stepLabels!.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isActive = index <= currentStep;
              
              return Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? activeColor : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}