import 'package:flutter/material.dart';

/// Tipos de accordion
enum ShadcnAccordionType {
  single, // Apenas um item pode estar expandido
  multiple, // Múltiplos itens podem estar expandidos
}

/// Variantes do accordion
enum ShadcnAccordionVariant {
  default_,
  outline,
  filled,
  ghost,
}

/// Item individual do accordion
class ShadcnAccordionItem {
  final String id;
  final Widget title;
  final Widget content;
  final Widget? icon;
  final bool disabled;
  final Color? backgroundColor;
  final Color? borderColor;

  const ShadcnAccordionItem({
    required this.id,
    required this.title,
    required this.content,
    this.icon,
    this.disabled = false,
    this.backgroundColor,
    this.borderColor,
  });
}

/// Componente Accordion baseado no Shadcn/UI
class ShadcnAccordion extends StatefulWidget {
  final List<ShadcnAccordionItem> items;
  final ShadcnAccordionType type;
  final ShadcnAccordionVariant variant;
  final List<String>? initialExpandedItems;
  final ValueChanged<List<String>>? onChanged;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final BorderRadius? borderRadius;
  final bool showDividers;

  const ShadcnAccordion({
    super.key,
    required this.items,
    this.type = ShadcnAccordionType.single,
    this.variant = ShadcnAccordionVariant.default_,
    this.initialExpandedItems,
    this.onChanged,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.padding,
    this.spacing = 0.0,
    this.borderRadius,
    this.showDividers = true,
  });

  /// Cria um accordion que permite apenas um item expandido
  factory ShadcnAccordion.single({
    Key? key,
    required List<ShadcnAccordionItem> items,
    ShadcnAccordionVariant variant = ShadcnAccordionVariant.default_,
    String? initialExpandedItem,
    ValueChanged<String?>? onChanged,
    Duration animationDuration = const Duration(milliseconds: 200),
    Curve animationCurve = Curves.easeInOut,
    EdgeInsetsGeometry? padding,
    double spacing = 0.0,
    BorderRadius? borderRadius,
    bool showDividers = true,
  }) {
    return ShadcnAccordion(
      key: key,
      items: items,
      type: ShadcnAccordionType.single,
      variant: variant,
      initialExpandedItems: initialExpandedItem != null ? [initialExpandedItem] : null,
      onChanged: onChanged != null 
          ? (expandedItems) => onChanged(expandedItems.isNotEmpty ? expandedItems.first : null)
          : null,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      padding: padding,
      spacing: spacing,
      borderRadius: borderRadius,
      showDividers: showDividers,
    );
  }

  /// Cria um accordion que permite múltiplos itens expandidos
  factory ShadcnAccordion.multiple({
    Key? key,
    required List<ShadcnAccordionItem> items,
    ShadcnAccordionVariant variant = ShadcnAccordionVariant.default_,
    List<String>? initialExpandedItems,
    ValueChanged<List<String>>? onChanged,
    Duration animationDuration = const Duration(milliseconds: 200),
    Curve animationCurve = Curves.easeInOut,
    EdgeInsetsGeometry? padding,
    double spacing = 0.0,
    BorderRadius? borderRadius,
    bool showDividers = true,
  }) {
    return ShadcnAccordion(
      key: key,
      items: items,
      type: ShadcnAccordionType.multiple,
      variant: variant,
      initialExpandedItems: initialExpandedItems,
      onChanged: onChanged,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      padding: padding,
      spacing: spacing,
      borderRadius: borderRadius,
      showDividers: showDividers,
    );
  }

  @override
  State<ShadcnAccordion> createState() => _ShadcnAccordionState();
}

class _ShadcnAccordionState extends State<ShadcnAccordion> with TickerProviderStateMixin {
  late Set<String> _expandedItems;
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, Animation<double>> _animations = {};

  @override
  void initState() {
    super.initState();
    _expandedItems = Set.from(widget.initialExpandedItems ?? []);
    
    // Criar controllers de animação para cada item
    for (final item in widget.items) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );
      
      final animation = CurvedAnimation(
        parent: controller,
        curve: widget.animationCurve,
      );
      
      _animationControllers[item.id] = controller;
      _animations[item.id] = animation;
      
      // Inicializar estado expandido
      if (_expandedItems.contains(item.id)) {
        controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleItem(String itemId) {
    if (widget.items.any((item) => item.id == itemId && item.disabled)) {
      return;
    }

    setState(() {
      if (_expandedItems.contains(itemId)) {
        // Fechar item
        _expandedItems.remove(itemId);
        _animationControllers[itemId]?.reverse();
      } else {
        // Abrir item
        if (widget.type == ShadcnAccordionType.single) {
          // Fechar todos os outros itens
          for (final expandedId in _expandedItems.toList()) {
            _animationControllers[expandedId]?.reverse();
          }
          _expandedItems.clear();
        }
        
        _expandedItems.add(itemId);
        _animationControllers[itemId]?.forward();
      }
    });

    widget.onChanged?.call(_expandedItems.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        children: widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isExpanded = _expandedItems.contains(item.id);
          final isLast = index == widget.items.length - 1;
          
          return Column(
            children: [
              _buildAccordionItem(item, isExpanded),
              if (!isLast && widget.spacing > 0)
                SizedBox(height: widget.spacing)
              else if (!isLast && widget.showDividers && widget.variant != ShadcnAccordionVariant.outline)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccordionItem(ShadcnAccordionItem item, bool isExpanded) {
    final colorScheme = Theme.of(context).colorScheme;
    final animation = _animations[item.id]!;
    
    final (backgroundColor, borderColor, contentBackgroundColor) = _getItemColors(
      colorScheme, 
      item, 
      isExpanded,
    );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: widget.variant == ShadcnAccordionVariant.outline
            ? Border.all(color: borderColor)
            : null,
        borderRadius: widget.borderRadius ?? (widget.variant == ShadcnAccordionVariant.outline
            ? BorderRadius.circular(8)
            : null),
      ),
      child: Column(
        children: [
          // Header (sempre visível)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.disabled ? null : () => _toggleItem(item.id),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Ícone customizado ou ícone padrão
                    if (item.icon != null) ...[
                      item.icon!,
                      const SizedBox(width: 12),
                    ],
                    
                    // Título
                    Expanded(
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: item.disabled 
                              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ) ?? const TextStyle(),
                        child: item.title,
                      ),
                    ),
                    
                    // Seta de expansão
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: widget.animationDuration,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: item.disabled 
                            ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Conteúdo (expansível)
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: animation.value,
                  child: Container(
                    width: double.infinity,
                    color: contentBackgroundColor,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ) ?? const TextStyle(),
                      child: item.content,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  (Color, Color, Color) _getItemColors(
    ColorScheme colorScheme, 
    ShadcnAccordionItem item, 
    bool isExpanded,
  ) {
    // Cores customizadas do item têm prioridade
    if (item.backgroundColor != null && item.borderColor != null) {
      return (
        item.backgroundColor!,
        item.borderColor!,
        item.backgroundColor!.withValues(alpha: 0.5),
      );
    }

    return switch (widget.variant) {
      ShadcnAccordionVariant.default_ => (
        Colors.transparent,
        colorScheme.outline,
        Colors.transparent,
      ),
      ShadcnAccordionVariant.outline => (
        isExpanded 
            ? colorScheme.surfaceContainerLowest
            : Colors.transparent,
        isExpanded 
            ? colorScheme.primary.withValues(alpha: 0.3)
            : colorScheme.outline,
        colorScheme.surfaceContainerLowest,
      ),
      ShadcnAccordionVariant.filled => (
        colorScheme.surfaceContainerHighest,
        colorScheme.outline,
        colorScheme.surfaceContainer,
      ),
      ShadcnAccordionVariant.ghost => (
        isExpanded 
            ? colorScheme.surfaceContainerLowest
            : Colors.transparent,
        Colors.transparent,
        colorScheme.surfaceContainerLowest,
      ),
    };
  }
}

/// FAQ Accordion - Template pronto para uso
class ShadcnFAQAccordion extends StatelessWidget {
  final List<({String question, String answer})> faqs;
  final ShadcnAccordionVariant variant;

  const ShadcnFAQAccordion({
    super.key,
    required this.faqs,
    this.variant = ShadcnAccordionVariant.default_,
  });

  @override
  Widget build(BuildContext context) {
    final items = faqs.map((faq) => ShadcnAccordionItem(
      id: faq.question.hashCode.toString(),
      title: Text(
        faq.question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Text(faq.answer),
      icon: const Icon(Icons.help_outline, size: 20),
    )).toList();

    return ShadcnAccordion.single(
      items: items,
      variant: variant,
    );
  }
}

/// Settings Accordion - Template para configurações
class ShadcnSettingsAccordion extends StatelessWidget {
  final List<({String title, String description, List<Widget> settings})> sections;

  const ShadcnSettingsAccordion({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final items = sections.map((section) => ShadcnAccordionItem(
      id: section.title.hashCode.toString(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (section.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              section.description,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
      content: Column(
        children: section.settings
            .expand((setting) => [setting, const SizedBox(height: 12)])
            .take(section.settings.length * 2 - 1)
            .toList(),
      ),
      icon: const Icon(Icons.settings_outlined, size: 20),
    )).toList();

    return ShadcnAccordion.multiple(
      items: items,
      variant: ShadcnAccordionVariant.outline,
      spacing: 8,
    );
  }
}