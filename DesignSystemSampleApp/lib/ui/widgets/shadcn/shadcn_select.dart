import 'package:flutter/material.dart';
import '../../../DesignSystem/Theme/app_theme.dart';

class ShadcnSelectOption<T> {
  final T value;
  final String label;
  final Widget? icon;
  final bool enabled;

  const ShadcnSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

class ShadcnSelect<T> extends StatefulWidget {
  final List<ShadcnSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final bool searchable;
  final String? searchHint;

  const ShadcnSelect({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.width,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.searchable = false,
    this.searchHint = 'Buscar...',
  });

  @override
  State<ShadcnSelect<T>> createState() => _ShadcnSelectState<T>();
}

class _ShadcnSelectState<T> extends State<ShadcnSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;
  late TextEditingController _searchController;
  List<ShadcnSelectOption<T>> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredOptions = widget.options;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    setState(() {
      _isOpen = true;
    });

    _filteredOptions = widget.options;
    _searchController.clear();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SelectDropdown<T>(
        layerLink: _layerLink,
        width: widget.width ?? size.width,
        options: _filteredOptions,
        onChanged: (value) {
          widget.onChanged?.call(value);
          _closeDropdown();
        },
        searchable: widget.searchable,
        searchController: _searchController,
        searchHint: widget.searchHint!,
        onSearchChanged: _onSearchChanged,
        backgroundColor: widget.backgroundColor,
        borderColor: widget.borderColor,
        borderRadius: widget.borderRadius,
        textStyle: widget.textStyle,
        onClose: _closeDropdown,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    setState(() {
      _isOpen = false;
    });

    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) =>
                option.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    // Update overlay
    _overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final bgColor = widget.backgroundColor ?? AppColors.surface;
    final borderColorFinal = widget.borderColor ?? AppColors.border;
    final borderRadiusFinal = widget.borderRadius ?? BorderRadius.circular(12);
    final paddingFinal = widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    final selectedOption = widget.options.cast<ShadcnSelectOption<T>?>().firstWhere(
      (option) => option?.value == widget.value,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Select Field
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Focus(
              focusNode: _focusNode,
              child: Container(
                width: widget.width,
                padding: paddingFinal,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: borderRadiusFinal,
                  border: Border.all(
                    color: widget.errorText != null
                        ? AppColors.destructive
                        : _isOpen
                            ? AppColors.ring
                            : borderColorFinal,
                    width: _isOpen ? 2 : 1,
                  ),
                  boxShadow: _isOpen ? [
                    BoxShadow(
                      color: AppColors.ring.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  children: [
                    // Prefix Icon
                    if (widget.prefixIcon != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          color: _isOpen ? AppColors.onSurface : AppColors.zinc400,
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Selected Option or Placeholder
                    Expanded(
                      child: selectedOption != null
                          ? Row(
                              children: [
                                if (selectedOption.icon != null) ...[
                                  selectedOption.icon!,
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    selectedOption.label,
                                    style: widget.textStyle ??
                                        theme.textTheme.bodyMedium?.copyWith(
                                          color: widget.enabled
                                              ? AppColors.onSurface
                                              : AppColors.onSurface.withValues(alpha: 0.5),
                                          fontSize: 15,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              widget.placeholder ?? 'Selecione uma opção',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.zinc400,
                                fontSize: 15,
                              ),
                            ),
                    ),

                    // Suffix Icon or Dropdown Arrow
                    widget.suffixIcon ??
                        AnimatedRotation(
                          turns: _isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: widget.enabled
                                ? AppColors.zinc400
                                : AppColors.zinc400.withValues(alpha: 0.5),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Helper Text
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.zinc500,
            ),
          ),
        ],

        // Error Text
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.destructive,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _SelectDropdown<T> extends StatefulWidget {
  final LayerLink layerLink;
  final double width;
  final List<ShadcnSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool searchable;
  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final VoidCallback onClose;

  const _SelectDropdown({
    required this.layerLink,
    required this.width,
    required this.options,
    required this.onChanged,
    required this.searchable,
    required this.searchController,
    required this.searchHint,
    required this.onSearchChanged,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.textStyle,
    required this.onClose,
  });

  @override
  State<_SelectDropdown<T>> createState() => _SelectDropdownState<T>();
}

class _SelectDropdownState<T> extends State<_SelectDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CompositedTransformFollower(
          link: widget.layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 8,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              color: Colors.transparent,
              child: Container(
                width: widget.width,
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.surface,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.borderColor ?? AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Field
                    if (widget.searchable) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: widget.searchController,
                          onChanged: widget.onSearchChanged,
                          decoration: InputDecoration(
                            hintText: widget.searchHint,
                            prefixIcon: const Icon(Icons.search, size: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.ring),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                    ],

                    // Options List
                    Flexible(
                      child: widget.options.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Nenhuma opção encontrada',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.zinc500,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: widget.options.length,
                              itemBuilder: (context, index) {
                                final option = widget.options[index];
                                return _SelectOptionTile<T>(
                                  option: option,
                                  onTap: () => widget.onChanged(option.value),
                                  textStyle: widget.textStyle,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectOptionTile<T> extends StatelessWidget {
  final ShadcnSelectOption<T> option;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const _SelectOptionTile({
    required this.option,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.enabled ? onTap : null,
        hoverColor: AppColors.zinc100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (option.icon != null) ...[
                option.icon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  option.label,
                  style: textStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: option.enabled
                            ? AppColors.onSurface
                            : AppColors.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}