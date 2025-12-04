import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/colors.dart';
import 'theme_toggle_view_model.dart';
import 'theme_toggle_delegate.dart';

class ThemeToggleButtonView extends StatefulWidget {
  final double size;
  final bool showTooltip;
  final ThemeToggleViewModel? viewModel;
  final ThemeToggleDelegate? delegate;

  const ThemeToggleButtonView({
    super.key,
    this.size = 40,
    this.showTooltip = true,
    this.viewModel,
    this.delegate,
  });

  @override
  State<ThemeToggleButtonView> createState() => _ThemeToggleButtonViewState();
}

class _ThemeToggleButtonViewState extends State<ThemeToggleButtonView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(ThemeProvider themeProvider) {
    widget.delegate?.onAnimationStart();
    _controller.forward(from: 0).then((_) {
      widget.delegate?.onAnimationEnd();
    });
    widget.delegate?.onThemeToggle();
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    Widget button = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.delegate?.onHoverEnter();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.delegate?.onHoverExit();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 3.14159,
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleTap(themeProvider),
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _isHovered
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(widget.size / 2),
                border: Border.all(
                  color: _isHovered ? theme.colorScheme.outline : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    key: ValueKey(isDark),
                    size: widget.size * 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.showTooltip) {
      return Tooltip(
        message: isDark ? 'Mudar para tema claro' : 'Mudar para tema escuro',
        child: button,
      );
    }

    return button;
  }
}

class ThemeSwitchView extends StatelessWidget {
  final ThemeToggleDelegate? delegate;

  const ThemeSwitchView({
    super.key,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode_rounded,
          size: 18,
          color: !isDark
              ? ShadcnColors.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: isDark,
          onChanged: (_) {
            delegate?.onThemeToggle();
            themeProvider.toggleTheme();
          },
          activeColor: ShadcnColors.primary,
          activeTrackColor: ShadcnColors.primary.withValues(alpha: 0.3),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.dark_mode_rounded,
          size: 18,
          color: isDark
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

class ThemeSegmentedButtonView extends StatelessWidget {
  final ThemeToggleDelegate? delegate;

  const ThemeSegmentedButtonView({
    super.key,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ShadcnColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentButton(
            icon: Icons.light_mode_rounded,
            label: 'Claro',
            isSelected: themeProvider.themeMode == ThemeMode.light,
            onTap: () {
              delegate?.onThemeSelected(ThemeMode.light);
              themeProvider.setTheme(ThemeMode.light);
            },
            isFirst: true,
          ),
          _SegmentButton(
            icon: Icons.settings_rounded,
            label: 'Sistema',
            isSelected: themeProvider.themeMode == ThemeMode.system,
            onTap: () {
              delegate?.onThemeSelected(ThemeMode.system);
              themeProvider.setTheme(ThemeMode.system);
            },
          ),
          _SegmentButton(
            icon: Icons.dark_mode_rounded,
            label: 'Escuro',
            isSelected: themeProvider.themeMode == ThemeMode.dark,
            onTap: () {
              delegate?.onThemeSelected(ThemeMode.dark);
              themeProvider.setTheme(ThemeMode.dark);
            },
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _SegmentButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(7) : Radius.zero,
            right: isLast ? const Radius.circular(7) : Radius.zero,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
