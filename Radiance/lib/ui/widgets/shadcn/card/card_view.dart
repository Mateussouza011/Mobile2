import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'card_view_model.dart';
import 'card_delegate.dart';

class ShadcnCardView extends StatefulWidget {
  final Widget? child;
  final List<Widget>? children;
  final String? title;
  final String? subtitle;
  final String? description;
  final Widget? header;
  final Widget? footer;
  final Widget? leading;
  final Widget? trailing;
  final Widget? image;
  final Widget? overlay;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final ValueChanged<bool>? onHover;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool>? onSelectionChanged;
  final ShadcnCardVariant variant;
  final ShadcnCardSize size;
  final ShadcnCardLayout layout;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final double? spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? shadowColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final double? elevation;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final DecorationImage? backgroundImage;
  final BlendMode? backgroundBlendMode;
  final bool enabled;
  final bool loading;
  final Widget? loadingWidget;
  final bool expandable;
  final bool expanded;
  final ValueChanged<bool>? onExpandChanged;
  final Duration? animationDuration;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final int? maxTitleLines;
  final int? maxSubtitleLines;
  final int? maxDescriptionLines;
  final TextOverflow titleOverflow;
  final TextOverflow subtitleOverflow;
  final TextOverflow descriptionOverflow;
  final Widget? badge;
  final Widget? statusIndicator;
  final List<Widget>? tags;
  final List<Widget>? actions;

  const ShadcnCardView({
    super.key,
    this.child,
    this.children,
    this.title,
    this.subtitle,
    this.description,
    this.header,
    this.footer,
    this.leading,
    this.trailing,
    this.image,
    this.overlay,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onHover,
    this.selectable = false,
    this.selected = false,
    this.onSelectionChanged,
    this.variant = ShadcnCardVariant.default_,
    this.size = ShadcnCardSize.default_,
    this.layout = ShadcnCardLayout.vertical,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.contentPadding,
    this.spacing,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.backgroundColor,
    this.borderColor,
    this.shadowColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.boxShadow,
    this.gradient,
    this.backgroundImage,
    this.backgroundBlendMode,
    this.enabled = true,
    this.loading = false,
    this.loadingWidget,
    this.expandable = false,
    this.expanded = false,
    this.onExpandChanged,
    this.animationDuration,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.maxTitleLines,
    this.maxSubtitleLines,
    this.maxDescriptionLines,
    this.titleOverflow = TextOverflow.ellipsis,
    this.subtitleOverflow = TextOverflow.ellipsis,
    this.descriptionOverflow = TextOverflow.ellipsis,
    this.badge,
    this.statusIndicator,
    this.tags,
    this.actions,
  });

  const ShadcnCardView.simple({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
  })  : children = null,
        title = null,
        subtitle = null,
        description = null,
        header = null,
        footer = null,
        leading = null,
        trailing = null,
        image = null,
        overlay = null,
        onLongPress = null,
        onDoubleTap = null,
        onHover = null,
        selectable = false,
        selected = false,
        onSelectionChanged = null,
        variant = ShadcnCardVariant.default_,
        size = ShadcnCardSize.default_,
        layout = ShadcnCardLayout.vertical,
        width = null,
        height = null,
        contentPadding = null,
        spacing = null,
        crossAxisAlignment = CrossAxisAlignment.start,
        mainAxisAlignment = MainAxisAlignment.start,
        mainAxisSize = MainAxisSize.min,
        borderColor = null,
        shadowColor = null,
        borderWidth = null,
        boxShadow = null,
        gradient = null,
        backgroundImage = null,
        backgroundBlendMode = null,
        enabled = true,
        loading = false,
        loadingWidget = null,
        expandable = false,
        expanded = false,
        onExpandChanged = null,
        animationDuration = null,
        titleStyle = null,
        subtitleStyle = null,
        descriptionStyle = null,
        maxTitleLines = null,
        maxSubtitleLines = null,
        maxDescriptionLines = null,
        titleOverflow = TextOverflow.ellipsis,
        subtitleOverflow = TextOverflow.ellipsis,
        descriptionOverflow = TextOverflow.ellipsis,
        badge = null,
        statusIndicator = null,
        tags = null,
        actions = null;

  @override
  State<ShadcnCardView> createState() => _ShadcnCardViewState();
}

class _ShadcnCardViewState extends State<ShadcnCardView>
    with SingleTickerProviderStateMixin {
  late final ShadcnCardViewModel _viewModel;
  late final ShadcnCardService _service;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _viewModel = ShadcnCardViewModel();
    _viewModel.setVariant(widget.variant);
    _viewModel.setSize(widget.size);
    _viewModel.setLayout(widget.layout);
    _viewModel.setEnabled(widget.enabled);
    _viewModel.setLoading(widget.loading);
    _viewModel.setSelected(widget.selected);
    _viewModel.setExpanded(widget.expanded);

    _service = ShadcnCardService(
      viewModel: _viewModel,
      onTapCallback: widget.onTap,
      onLongPressCallback: widget.onLongPress,
      onDoubleTapCallback: widget.onDoubleTap,
      onHoverCallback: widget.onHover,
      onSelectionCallback: widget.onSelectionChanged,
      onExpandCallback: widget.onExpandChanged,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(ShadcnCardView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.variant != oldWidget.variant) {
      _viewModel.setVariant(widget.variant);
    }
    if (widget.size != oldWidget.size) {
      _viewModel.setSize(widget.size);
    }
    if (widget.layout != oldWidget.layout) {
      _viewModel.setLayout(widget.layout);
    }
    if (widget.enabled != oldWidget.enabled) {
      _viewModel.setEnabled(widget.enabled);
    }
    if (widget.loading != oldWidget.loading) {
      _viewModel.setLoading(widget.loading);
    }
    if (widget.selected != oldWidget.selected) {
      _viewModel.setSelected(widget.selected);
    }
    if (widget.expanded != oldWidget.expanded) {
      _viewModel.setExpanded(widget.expanded);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ShadcnCardViewModel>(
        builder: (context, viewModel, child) {
          return _buildCard(context, viewModel);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, ShadcnCardViewModel viewModel) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color bgColor = widget.backgroundColor ?? viewModel.getBackgroundColor(colorScheme);
    Color? bColor = widget.borderColor ?? viewModel.getBorderColor(colorScheme);
    double elev = widget.elevation ?? viewModel.getElevation();
    BorderRadius bRadius = widget.borderRadius ?? viewModel.getBorderRadius();
    EdgeInsetsGeometry pad = widget.padding ?? viewModel.getPadding();
    double itemSpacing = widget.spacing ?? viewModel.getSpacing();

    List<BoxShadow>? shadows = widget.boxShadow;
    if (shadows == null && elev > 0) {
      shadows = [
        BoxShadow(
          color: widget.shadowColor ?? Colors.black.withValues(alpha: 0.1),
          blurRadius: elev * 2,
          offset: Offset(0, elev / 2),
        ),
      ];
    }

    Widget cardContent = _buildContent(theme, viewModel, itemSpacing);

    if (viewModel.isLoading) {
      cardContent = Stack(
        children: [
          cardContent,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: bRadius,
              ),
              child: Center(
                child: widget.loadingWidget ??
                    CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
              ),
            ),
          ),
        ],
      );
    }

    Widget card = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: bRadius,
        border: bColor != null
            ? Border.all(color: bColor, width: widget.borderWidth ?? 1)
            : null,
        boxShadow: shadows,
        image: widget.backgroundImage,
        backgroundBlendMode: widget.backgroundBlendMode,
      ),
      child: ClipRRect(
        borderRadius: bRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap != null ? () => _service.onTap() : null,
            onLongPress: widget.onLongPress != null ? () => _service.onLongPress() : null,
            onDoubleTap: widget.onDoubleTap != null ? () => _service.onDoubleTap() : null,
            onHover: (hovered) => _service.onHoverChanged(hovered),
            borderRadius: bRadius,
            child: Container(
              padding: pad,
              child: cardContent,
            ),
          ),
        ),
      ),
    );

    if (widget.overlay != null) {
      card = Stack(
        children: [
          card,
          Positioned.fill(child: widget.overlay!),
        ],
      );
    }

    return card;
  }

  Widget _buildContent(
    ThemeData theme,
    ShadcnCardViewModel viewModel,
    double spacing,
  ) {
    if (widget.child != null) {
      return widget.child!;
    }

    List<Widget> contentItems = [];

    if (widget.header != null) {
      contentItems.add(widget.header!);
      contentItems.add(SizedBox(height: spacing));
    }

    if (widget.image != null) {
      contentItems.add(widget.image!);
      contentItems.add(SizedBox(height: spacing));
    }

    if (widget.badge != null) {
      contentItems.add(widget.badge!);
      contentItems.add(SizedBox(height: spacing / 2));
    }

    if (widget.title != null || widget.leading != null || widget.trailing != null) {
      contentItems.add(_buildTitleRow(theme, viewModel));
      if (widget.subtitle != null || widget.description != null) {
        contentItems.add(SizedBox(height: spacing / 2));
      }
    }

    if (widget.subtitle != null) {
      contentItems.add(
        Text(
          widget.subtitle!,
          style: widget.subtitleStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
          maxLines: widget.maxSubtitleLines,
          overflow: widget.subtitleOverflow,
        ),
      );
      if (widget.description != null) {
        contentItems.add(SizedBox(height: spacing / 2));
      }
    }

    if (widget.description != null) {
      contentItems.add(
        Text(
          widget.description!,
          style: widget.descriptionStyle ??
              theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
          maxLines: widget.maxDescriptionLines,
          overflow: widget.descriptionOverflow,
        ),
      );
    }

    if (widget.tags != null && widget.tags!.isNotEmpty) {
      contentItems.add(SizedBox(height: spacing));
      contentItems.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.tags!,
        ),
      );
    }

    if (widget.children != null) {
      for (var child in widget.children!) {
        contentItems.add(child);
      }
    }

    if (widget.actions != null && widget.actions!.isNotEmpty) {
      contentItems.add(SizedBox(height: spacing));
      contentItems.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widget.actions!,
        ),
      );
    }

    if (widget.footer != null) {
      contentItems.add(SizedBox(height: spacing));
      contentItems.add(widget.footer!);
    }

    switch (viewModel.layout) {
      case ShadcnCardLayout.horizontal:
        return Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: contentItems,
        );
      case ShadcnCardLayout.vertical:
      default:
        return Column(
          crossAxisAlignment: widget.crossAxisAlignment,
          mainAxisAlignment: widget.mainAxisAlignment,
          mainAxisSize: widget.mainAxisSize,
          children: contentItems,
        );
    }
  }

  Widget _buildTitleRow(ThemeData theme, ShadcnCardViewModel viewModel) {
    return Row(
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: widget.titleStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: widget.maxTitleLines,
                  overflow: widget.titleOverflow,
                ),
            ],
          ),
        ),
        if (widget.statusIndicator != null) ...[
          const SizedBox(width: 8),
          widget.statusIndicator!,
        ],
        if (widget.trailing != null) ...[
          const SizedBox(width: 8),
          widget.trailing!,
        ],
        if (widget.expandable) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              viewModel.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () => _service.toggleExpanded(),
          ),
        ],
        if (widget.selectable) ...[
          const SizedBox(width: 8),
          Checkbox(
            value: viewModel.isSelected,
            onChanged: (_) => _service.toggleSelection(),
          ),
        ],
      ],
    );
  }
}
