import 'package:flutter/material.dart';

/// Variantes do skeleton
enum ShadcnSkeletonVariant {
  rectangular,
  rounded,
  circular,
  text,
}

/// Animações do skeleton
enum ShadcnSkeletonAnimation {
  none,
  pulse,
  wave,
  shimmer,
}

/// Componente Skeleton baseado no Shadcn/UI
class ShadcnSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final ShadcnSkeletonVariant variant;
  final ShadcnSkeletonAnimation animation;
  final Color? color;
  final Color? highlightColor;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  final Widget? child;

  const ShadcnSkeleton({
    super.key,
    this.width,
    this.height,
    this.variant = ShadcnSkeletonVariant.rectangular,
    this.animation = ShadcnSkeletonAnimation.pulse,
    this.color,
    this.highlightColor,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.child,
  });

  /// Skeleton circular (para avatares)
  const ShadcnSkeleton.avatar({
    super.key,
    this.width = 40.0,
    this.height = 40.0,
    this.animation = ShadcnSkeletonAnimation.pulse,
    this.color,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : variant = ShadcnSkeletonVariant.circular,
       borderRadius = null,
       child = null;

  /// Skeleton para texto
  const ShadcnSkeleton.text({
    super.key,
    this.width,
    this.height = 16.0,
    this.animation = ShadcnSkeletonAnimation.pulse,
    this.color,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : variant = ShadcnSkeletonVariant.text,
       borderRadius = null,
       child = null;

  /// Skeleton retangular arredondado
  const ShadcnSkeleton.rounded({
    super.key,
    this.width,
    this.height,
    this.animation = ShadcnSkeletonAnimation.pulse,
    this.color,
    this.highlightColor,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : variant = ShadcnSkeletonVariant.rounded,
       child = null;

  @override
  State<ShadcnSkeleton> createState() => _ShadcnSkeletonState();
}

class _ShadcnSkeletonState extends State<ShadcnSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = switch (widget.animation) {
      ShadcnSkeletonAnimation.pulse => Tween<double>(
        begin: 0.6,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )),
      ShadcnSkeletonAnimation.wave => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      )),
      ShadcnSkeletonAnimation.shimmer => Tween<double>(
        begin: -1.0,
        end: 2.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )),
      ShadcnSkeletonAnimation.none => Tween<double>(
        begin: 1.0,
        end: 1.0,
      ).animate(_animationController),
    };

    if (widget.animation != ShadcnSkeletonAnimation.none) {
      _animationController.repeat(reverse: widget.animation == ShadcnSkeletonAnimation.pulse);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skeletonColor = widget.color ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: _buildDecoration(skeletonColor, highlightColor),
          child: widget.child,
        );
      },
    );
  }

  BoxDecoration _buildDecoration(Color baseColor, Color highlightColor) {
    final shape = switch (widget.variant) {
      ShadcnSkeletonVariant.circular => BoxShape.circle,
      _ => BoxShape.rectangle,
    };

    final borderRadius = widget.variant == ShadcnSkeletonVariant.circular
        ? null
        : widget.borderRadius ?? _getDefaultBorderRadius();

    return switch (widget.animation) {
      ShadcnSkeletonAnimation.pulse => BoxDecoration(
        color: baseColor.withValues(alpha: _animation.value),
        shape: shape,
        borderRadius: borderRadius,
      ),
      ShadcnSkeletonAnimation.wave => BoxDecoration(
        color: Color.lerp(baseColor, highlightColor, (_animation.value * 2 - 1).abs()),
        shape: shape,
        borderRadius: borderRadius,
      ),
      ShadcnSkeletonAnimation.shimmer => BoxDecoration(
        shape: shape,
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: [
            (_animation.value - 0.3).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 0.3).clamp(0.0, 1.0),
          ],
        ),
      ),
      ShadcnSkeletonAnimation.none => BoxDecoration(
        color: baseColor,
        shape: shape,
        borderRadius: borderRadius,
      ),
    };
  }

  BorderRadius? _getDefaultBorderRadius() {
    return switch (widget.variant) {
      ShadcnSkeletonVariant.rectangular => null,
      ShadcnSkeletonVariant.rounded => BorderRadius.circular(8.0),
      ShadcnSkeletonVariant.text => BorderRadius.circular(4.0),
      ShadcnSkeletonVariant.circular => null,
    };
  }
}

/// Componente para criar layouts skeleton complexos
class ShadcnSkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const ShadcnSkeletonList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < itemCount - 1 ? spacing : 0),
            child: itemBuilder(context, index),
          );
        }),
      ),
    );
  }
}

/// Skeletons pré-definidos para casos comuns
class ShadcnSkeletonTemplates {
  /// Skeleton para card de post
  static Widget postCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com avatar e nome
          Row(
            children: [
              ShadcnSkeleton.avatar(width: 40, height: 40),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShadcnSkeleton.text(width: 100),
                  SizedBox(height: 4),
                  ShadcnSkeleton.text(width: 80, height: 12),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Conteúdo do post
          ShadcnSkeleton.text(width: double.infinity),
          SizedBox(height: 8),
          ShadcnSkeleton.text(width: 250),
          SizedBox(height: 8),
          ShadcnSkeleton.text(width: 180),
          SizedBox(height: 16),
          
          // Imagem
          ShadcnSkeleton.rounded(
            width: double.infinity,
            height: 200,
          ),
          SizedBox(height: 16),
          
          // Ações
          Row(
            children: [
              ShadcnSkeleton.rounded(width: 60, height: 32),
              SizedBox(width: 12),
              ShadcnSkeleton.rounded(width: 60, height: 32),
              SizedBox(width: 12),
              ShadcnSkeleton.rounded(width: 60, height: 32),
            ],
          ),
        ],
      ),
    );
  }

  /// Skeleton para item de lista
  static Widget listItem() {
    return const Row(
      children: [
        ShadcnSkeleton.avatar(width: 48, height: 48),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadcnSkeleton.text(width: double.infinity),
              SizedBox(height: 8),
              ShadcnSkeleton.text(width: 200, height: 12),
            ],
          ),
        ),
        SizedBox(width: 16),
        ShadcnSkeleton.rounded(width: 24, height: 24),
      ],
    );
  }

  /// Skeleton para card de produto
  static Widget productCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do produto
          ShadcnSkeleton.rounded(
            width: double.infinity,
            height: 150,
          ),
          
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do produto
                ShadcnSkeleton.text(width: double.infinity),
                SizedBox(height: 8),
                
                // Descrição
                ShadcnSkeleton.text(width: 120, height: 12),
                SizedBox(height: 12),
                
                // Preço
                ShadcnSkeleton.text(width: 80, height: 18),
                SizedBox(height: 12),
                
                // Botão
                ShadcnSkeleton.rounded(
                  width: double.infinity,
                  height: 36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton para perfil de usuário
  static Widget userProfile() {
    return const Column(
      children: [
        // Avatar grande
        ShadcnSkeleton.avatar(width: 100, height: 100),
        SizedBox(height: 16),
        
        // Nome
        ShadcnSkeleton.text(width: 150, height: 20),
        SizedBox(height: 8),
        
        // Bio
        ShadcnSkeleton.text(width: 200, height: 14),
        SizedBox(height: 4),
        ShadcnSkeleton.text(width: 180, height: 14),
        SizedBox(height: 16),
        
        // Estatísticas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ShadcnSkeleton.text(width: 30, height: 18),
                SizedBox(height: 4),
                ShadcnSkeleton.text(width: 60, height: 12),
              ],
            ),
            Column(
              children: [
                ShadcnSkeleton.text(width: 30, height: 18),
                SizedBox(height: 4),
                ShadcnSkeleton.text(width: 60, height: 12),
              ],
            ),
            Column(
              children: [
                ShadcnSkeleton.text(width: 30, height: 18),
                SizedBox(height: 4),
                ShadcnSkeleton.text(width: 60, height: 12),
              ],
            ),
          ],
        ),
      ],
    );
  }
}