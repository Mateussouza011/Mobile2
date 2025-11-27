import 'package:flutter/material.dart';
import '../../../DesignSystem/Theme/app_theme.dart';

/// Variantes visuais do card
enum ShadcnCardVariant {
  default_,
  elevated,
  outlined,
  filled,
  ghost,
}

/// Tamanhos do card
enum ShadcnCardSize {
  sm,
  default_,
  lg,
  xl,
}

/// Tipos de layout do card
enum ShadcnCardLayout {
  vertical,
  horizontal,
  grid,
  custom,
}

/// Componente Card baseado no Shadcn/UI - Versão Genérica e Flexível
class ShadcnCard extends StatefulWidget {
  // Conteúdo principal
  final Widget? child;
  final List<Widget>? children;
  
  // Estrutura do card
  final String? title;
  final String? subtitle;
  final String? description;
  final Widget? header;
  final Widget? footer;
  final Widget? leading;
  final Widget? trailing;
  final Widget? image;
  final Widget? overlay;
  
  // Comportamento e interação
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final ValueChanged<bool>? onHover;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool>? onSelectionChanged;
  
  // Estilo visual
  final ShadcnCardVariant variant;
  final ShadcnCardSize size;
  final ShadcnCardLayout layout;
  
  // Dimensões e espaçamento
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final double? spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  
  // Customização visual avançada
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
  
  // Estados visuais
  final bool enabled;
  final bool loading;
  final Widget? loadingWidget;
  final bool expandable;
  final bool expanded;
  final ValueChanged<bool>? onExpandChanged;
  final Duration? animationDuration;
  
  // Customização de texto
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final int? maxTitleLines;
  final int? maxSubtitleLines;
  final int? maxDescriptionLines;
  final TextOverflow titleOverflow;
  final TextOverflow subtitleOverflow;
  final TextOverflow descriptionOverflow;
  
  // Badges e indicadores
  final Widget? badge;
  final Widget? statusIndicator;
  final List<Widget>? tags;
  final List<Widget>? actions;
  
  const ShadcnCard({
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

  // Constructors específicos
  
  // Card simples com apenas conteúdo
  const ShadcnCard.simple({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
  }) : children = null,
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

  // Card com imagem
  const ShadcnCard.withImage({
    super.key,
    required this.image,
    this.title,
    this.description,
    this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  }) : children = null,
       subtitle = null,
       header = null,
       footer = null,
       leading = null,
       trailing = null,
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
       margin = null,
       contentPadding = null,
       spacing = null,
       crossAxisAlignment = CrossAxisAlignment.start,
       mainAxisAlignment = MainAxisAlignment.start,
       mainAxisSize = MainAxisSize.min,
       borderColor = null,
       shadowColor = null,
       borderWidth = null,
       elevation = null,
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

  // Card expansível
  const ShadcnCard.expandable({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leading,
    this.expanded = false,
    this.onExpandChanged,
    this.animationDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.borderRadius,
  }) : children = null,
       description = null,
       header = null,
       footer = null,
       trailing = null,
       image = null,
       overlay = null,
       onTap = null,
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
       padding = null,
       margin = null,
       contentPadding = null,
       spacing = null,
       crossAxisAlignment = CrossAxisAlignment.start,
       mainAxisAlignment = MainAxisAlignment.start,
       mainAxisSize = MainAxisSize.min,
       borderColor = null,
       shadowColor = null,
       borderWidth = null,
       elevation = null,
       boxShadow = null,
       gradient = null,
       backgroundImage = null,
       backgroundBlendMode = null,
       enabled = true,
       loading = false,
       loadingWidget = null,
       expandable = true,
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
  State<ShadcnCard> createState() => _ShadcnCardState();
}

class _ShadcnCardState extends State<ShadcnCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expanded;
    
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ShadcnCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      _isExpanded = widget.expanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleTap() {
    if (!widget.enabled) return;
    
    if (widget.expandable) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
      
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      
      widget.onExpandChanged?.call(_isExpanded);
    }
    
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determinar cores e estilos baseados na variante
    Color bgColor = widget.backgroundColor ?? AppColors.surface;
    Color borderColorFinal = widget.borderColor ?? AppColors.border;
    double elevationFinal = widget.elevation ?? 0;
    BorderRadius borderRadiusFinal = widget.borderRadius ?? BorderRadius.circular(16);
    EdgeInsetsGeometry paddingFinal = widget.padding ?? const EdgeInsets.all(24);
    double spacingFinal = widget.spacing ?? 16;
    
    // Estados visuais
    if (!widget.enabled) {
      bgColor = bgColor.withValues(alpha: 0.5);
    }
    
    if (widget.selected) {
      borderColorFinal = AppColors.primary;
    }
    
    if (_isHovered && widget.onTap != null) {
      bgColor = AppColors.zinc50;
    }
    
    if (_isPressed) {
      bgColor = AppColors.zinc100;
    }

    // Construir conteúdo do card
    Widget cardContent = _buildCardContent(theme, colorScheme, spacingFinal);
    
    // Aplicar padding
    if (paddingFinal != EdgeInsets.zero) {
      cardContent = Padding(
        padding: paddingFinal,
        child: cardContent,
      );
    }
    
    // Container principal
    Widget cardContainer = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: borderRadiusFinal,
        border: Border.all(
          color: borderColorFinal,
          width: widget.borderWidth ?? 1,
        ),
        boxShadow: widget.boxShadow ?? (elevationFinal > 0 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: elevationFinal,
            offset: Offset(0, elevationFinal / 2),
          ),
        ] : null),
        image: widget.backgroundImage,
        backgroundBlendMode: widget.backgroundBlendMode,
      ),
      child: cardContent,
    );
    
    // Adicionar overlay se especificado
    if (widget.overlay != null) {
      cardContainer = Stack(
        children: [
          cardContainer,
          Positioned.fill(child: widget.overlay!),
        ],
      );
    }
    
    // Adicionar interatividade
    if (widget.onTap != null || 
        widget.onLongPress != null || 
        widget.onDoubleTap != null ||
        widget.expandable ||
        widget.selectable) {
      cardContainer = Material(
        color: Colors.transparent,
        borderRadius: borderRadiusFinal,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: widget.onLongPress,
          onDoubleTap: widget.onDoubleTap,
          onHover: (hovered) {
            setState(() {
              _isHovered = hovered;
            });
            widget.onHover?.call(hovered);
          },
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: borderRadiusFinal,
          child: cardContainer,
        ),
      );
    }
    
    // Adicionar seleção visual
    if (widget.selectable) {
      cardContainer = Stack(
        children: [
          cardContainer,
          if (widget.selected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
        ],
      );
    }
    
    // Aplicar margem
    if (widget.margin != null) {
      cardContainer = Container(
        margin: widget.margin,
        child: cardContainer,
      );
    }
    
    return cardContainer;
  }

  Widget _buildCardContent(ThemeData theme, ColorScheme colorScheme, double spacing) {
    if (widget.loading) {
      return _buildLoadingContent();
    }
    
    List<Widget> contentChildren = [];
    
    // Imagem no topo (para layout vertical)
    if (widget.image != null && widget.layout == ShadcnCardLayout.vertical) {
      contentChildren.add(widget.image!);
      contentChildren.add(SizedBox(height: spacing));
    }
    
    // Header
    if (widget.header != null) {
      contentChildren.add(widget.header!);
      contentChildren.add(SizedBox(height: spacing));
    }
    
    // Conteúdo principal baseado no layout
    if (widget.layout == ShadcnCardLayout.horizontal) {
      contentChildren.add(_buildHorizontalLayout(theme, colorScheme, spacing));
    } else {
      contentChildren.addAll(_buildVerticalContent(theme, colorScheme, spacing));
    }
    
    // Footer
    if (widget.footer != null) {
      contentChildren.add(SizedBox(height: spacing));
      contentChildren.add(widget.footer!);
    }
    
    // Aplicar expansão se necessário
    if (widget.expandable) {
      return Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        children: [
          // Cabeçalho sempre visível
          _buildExpandableHeader(theme, colorScheme),
          // Conteúdo expansível
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              crossAxisAlignment: widget.crossAxisAlignment,
              children: contentChildren,
            ),
          ),
        ],
      );
    }
    
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: contentChildren,
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme, ColorScheme colorScheme, double spacing) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leading (imagem ou ícone)
        if (widget.leading != null || widget.image != null) ...[
          widget.leading ?? widget.image!,
          SizedBox(width: spacing),
        ],
        
        // Conteúdo principal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTextContent(theme, colorScheme, spacing),
          ),
        ),
        
        // Trailing
        if (widget.trailing != null) ...[
          SizedBox(width: spacing),
          widget.trailing!,
        ],
      ],
    );
  }

  List<Widget> _buildVerticalContent(ThemeData theme, ColorScheme colorScheme, double spacing) {
    List<Widget> children = [];
    
    // Badge e status indicator no topo
    if (widget.badge != null || widget.statusIndicator != null) {
      children.add(Row(
        children: [
          if (widget.badge != null) widget.badge!,
          const Spacer(),
          if (widget.statusIndicator != null) widget.statusIndicator!,
        ],
      ));
      children.add(SizedBox(height: spacing));
    }
    
    // Leading widget
    if (widget.leading != null) {
      children.add(widget.leading!);
      children.add(SizedBox(height: spacing));
    }
    
    // Conteúdo de texto
    children.addAll(_buildTextContent(theme, colorScheme, spacing));
    
    // Tags
    if (widget.tags != null && widget.tags!.isNotEmpty) {
      children.add(SizedBox(height: spacing));
      children.add(Wrap(
        spacing: 8,
        runSpacing: 4,
        children: widget.tags!,
      ));
    }
    
    // Conteúdo principal
    if (widget.child != null) {
      children.add(SizedBox(height: spacing));
      children.add(widget.child!);
    }
    
    if (widget.children != null) {
      children.add(SizedBox(height: spacing));
      children.addAll(widget.children!);
    }
    
    // Actions
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      children.add(SizedBox(height: spacing));
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.actions!,
      ));
    }
    
    // Trailing
    if (widget.trailing != null) {
      children.add(SizedBox(height: spacing));
      children.add(widget.trailing!);
    }
    
    return children;
  }

  List<Widget> _buildTextContent(ThemeData theme, ColorScheme colorScheme, double spacing) {
    List<Widget> textChildren = [];
    
    if (widget.title != null) {
      textChildren.add(
        Text(
          widget.title!,
          style: widget.titleStyle ?? theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          maxLines: widget.maxTitleLines,
          overflow: widget.titleOverflow,
        ),
      );
    }
    
    if (widget.subtitle != null) {
      if (textChildren.isNotEmpty) textChildren.add(SizedBox(height: spacing / 2));
      textChildren.add(
        Text(
          widget.subtitle!,
          style: widget.subtitleStyle ?? theme.textTheme.titleMedium?.copyWith(
            color: AppColors.zinc500,
          ),
          maxLines: widget.maxSubtitleLines,
          overflow: widget.subtitleOverflow,
        ),
      );
    }
    
    if (widget.description != null) {
      if (textChildren.isNotEmpty) textChildren.add(SizedBox(height: spacing / 2));
      textChildren.add(
        Text(
          widget.description!,
          style: widget.descriptionStyle ?? theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.zinc500,
          ),
          maxLines: widget.maxDescriptionLines,
          overflow: widget.descriptionOverflow,
        ),
      );
    }
    
    return textChildren;
  }

  Widget _buildExpandableHeader(ThemeData theme, ColorScheme colorScheme) {
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
                  style: widget.titleStyle ?? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              if (widget.subtitle != null)
                Text(
                  widget.subtitle!,
                  style: widget.subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.zinc500,
                  ),
                ),
            ],
          ),
        ),
        Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.zinc500,
        ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.zinc200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.zinc100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
