import 'package:flutter/material.dart';

enum ShadcnTooltipPosition {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class ShadcnTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Widget? richMessage;
  final ShadcnTooltipPosition position;
  final Duration showDuration;
  final Duration waitDuration;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? maxWidth;
  final bool showArrow;
  final double arrowSize;

  const ShadcnTooltip({
    super.key,
    required this.child,
    required this.message,
    this.richMessage,
    this.position = ShadcnTooltipPosition.top,
    this.showDuration = const Duration(seconds: 2),
    this.waitDuration = const Duration(milliseconds: 500),
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.maxWidth,
    this.showArrow = true,
    this.arrowSize = 6.0,
  });

  @override
  State<ShadcnTooltip> createState() => _ShadcnTooltipState();
}

class _ShadcnTooltipState extends State<ShadcnTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  OverlayEntry? _overlayEntry;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;

    final renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        targetOffset: offset,
        targetSize: size,
        message: widget.message,
        richMessage: widget.richMessage,
        position: widget.position,
        backgroundColor: widget.backgroundColor,
        textColor: widget.textColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        padding: widget.padding,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
        maxWidth: widget.maxWidth,
        showArrow: widget.showArrow,
        arrowSize: widget.arrowSize,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
    );

    overlayState.insert(_overlayEntry!);
    _animationController.forward();

    // Auto hide after duration
    Future.delayed(widget.showDuration, () {
      _removeTooltip();
    });
  }

  void _removeTooltip() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _childKey,
      onTap: _showTooltip,
      onLongPress: _showTooltip,
      child: MouseRegion(
        onEnter: (_) => Future.delayed(widget.waitDuration, _showTooltip),
        onExit: (_) => _removeTooltip(),
        child: widget.child,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final Offset targetOffset;
  final Size targetSize;
  final String message;
  final Widget? richMessage;
  final ShadcnTooltipPosition position;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? maxWidth;
  final bool showArrow;
  final double arrowSize;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const _TooltipOverlay({
    required this.targetOffset,
    required this.targetSize,
    required this.message,
    this.richMessage,
    required this.position,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.maxWidth,
    required this.showArrow,
    required this.arrowSize,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bgColor = backgroundColor ?? colorScheme.inverseSurface;
    final textColorFinal = textColor ?? colorScheme.onInverseSurface;
    final paddingFinal = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    final borderRadiusFinal = borderRadius ?? BorderRadius.circular(6);
    
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(
            scale: scaleAnimation.value,
            child: _buildPositionedTooltip(context, bgColor, textColorFinal, paddingFinal, borderRadiusFinal),
          ),
        );
      },
    );
  }

  Widget _buildPositionedTooltip(
    BuildContext context,
    Color bgColor,
    Color textColorFinal,
    EdgeInsetsGeometry paddingFinal,
    BorderRadius borderRadiusFinal,
  ) {
    final tooltipContent = Container(
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      padding: paddingFinal,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadiusFinal,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: richMessage ?? Text(
        message,
        style: TextStyle(
          color: textColorFinal,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );

    final (dx, dy) = _calculatePosition();
    
    return Positioned(
      left: dx,
      top: dy,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showArrow && _isArrowTop()) _buildArrow(bgColor),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showArrow && _isArrowLeft()) _buildArrow(bgColor),
                tooltipContent,
                if (showArrow && _isArrowRight()) _buildArrow(bgColor),
              ],
            ),
            if (showArrow && _isArrowBottom()) _buildArrow(bgColor),
          ],
        ),
      ),
    );
  }

  (double, double) _calculatePosition() {
    switch (position) {
      case ShadcnTooltipPosition.top:
        return (
          targetOffset.dx + targetSize.width / 2 - 50,  // Center horizontally
          targetOffset.dy - 40 - (showArrow ? arrowSize : 0),
        );
      case ShadcnTooltipPosition.bottom:
        return (
          targetOffset.dx + targetSize.width / 2 - 50,
          targetOffset.dy + targetSize.height + (showArrow ? arrowSize : 0),
        );
      case ShadcnTooltipPosition.left:
        return (
          targetOffset.dx - 100 - (showArrow ? arrowSize : 0),
          targetOffset.dy + targetSize.height / 2 - 20,
        );
      case ShadcnTooltipPosition.right:
        return (
          targetOffset.dx + targetSize.width + (showArrow ? arrowSize : 0),
          targetOffset.dy + targetSize.height / 2 - 20,
        );
      case ShadcnTooltipPosition.topLeft:
        return (
          targetOffset.dx,
          targetOffset.dy - 40 - (showArrow ? arrowSize : 0),
        );
      case ShadcnTooltipPosition.topRight:
        return (
          targetOffset.dx + targetSize.width - 100,
          targetOffset.dy - 40 - (showArrow ? arrowSize : 0),
        );
      case ShadcnTooltipPosition.bottomLeft:
        return (
          targetOffset.dx,
          targetOffset.dy + targetSize.height + (showArrow ? arrowSize : 0),
        );
      case ShadcnTooltipPosition.bottomRight:
        return (
          targetOffset.dx + targetSize.width - 100,
          targetOffset.dy + targetSize.height + (showArrow ? arrowSize : 0),
        );
    }
  }

  Widget _buildArrow(Color color) {
    return CustomPaint(
      size: Size(arrowSize * 2, arrowSize),
      painter: _ArrowPainter(color: color, direction: _getArrowDirection()),
    );
  }

  bool _isArrowTop() {
    return position == ShadcnTooltipPosition.bottom ||
           position == ShadcnTooltipPosition.bottomLeft ||
           position == ShadcnTooltipPosition.bottomRight;
  }

  bool _isArrowBottom() {
    return position == ShadcnTooltipPosition.top ||
           position == ShadcnTooltipPosition.topLeft ||
           position == ShadcnTooltipPosition.topRight;
  }

  bool _isArrowLeft() {
    return position == ShadcnTooltipPosition.right;
  }

  bool _isArrowRight() {
    return position == ShadcnTooltipPosition.left;
  }

  String _getArrowDirection() {
    if (_isArrowTop()) return 'up';
    if (_isArrowBottom()) return 'down';
    if (_isArrowLeft()) return 'left';
    if (_isArrowRight()) return 'right';
    return 'up';
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final String direction;

  _ArrowPainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    switch (direction) {
      case 'up':
        path.moveTo(size.width / 2, 0);
        path.lineTo(0, size.height);
        path.lineTo(size.width, size.height);
        break;
      case 'down':
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width / 2, size.height);
        break;
      case 'left':
        path.moveTo(0, size.height / 2);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case 'right':
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}