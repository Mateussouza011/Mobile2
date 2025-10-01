import 'package:flutter/material.dart';

enum ShadcnSliderType {
  single,
  range,
  stepped,
}

class ShadcnSlider extends StatefulWidget {
  final double? value;
  final RangeValues? rangeValues;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String Function(double)? labelFormatter;
  final ValueChanged<double>? onChanged;
  final ValueChanged<RangeValues>? onRangeChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<RangeValues>? onRangeChangeStart;
  final ValueChanged<RangeValues>? onRangeChangeEnd;
  final ShadcnSliderType type;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double? thumbRadius;
  final bool showLabels;
  final bool showTicks;
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  const ShadcnSlider({
    super.key,
    this.value,
    this.rangeValues,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.labelFormatter,
    this.onChanged,
    this.onRangeChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.onRangeChangeStart,
    this.onRangeChangeEnd,
    this.type = ShadcnSliderType.single,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.showLabels = true,
    this.showTicks = false,
    this.leadingWidget,
    this.trailingWidget,
  });

  // Construtor para slider simples
  const ShadcnSlider.single({
    super.key,
    required double value,
    required ValueChanged<double> onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.labelFormatter,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.showLabels = true,
    this.showTicks = false,
    this.leadingWidget,
    this.trailingWidget,
  }) : value = value,
       onChanged = onChanged,
       rangeValues = null,
       onRangeChanged = null,
       onRangeChangeStart = null,
       onRangeChangeEnd = null,
       type = ShadcnSliderType.single;

  // Construtor para slider de intervalo
  const ShadcnSlider.range({
    super.key,
    required RangeValues values,
    required ValueChanged<RangeValues> onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.labelFormatter,
    this.onRangeChangeStart,
    this.onRangeChangeEnd,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.showLabels = true,
    this.showTicks = false,
    this.leadingWidget,
    this.trailingWidget,
  }) : rangeValues = values,
       onRangeChanged = onChanged,
       value = null,
       onChanged = null,
       onChangeStart = null,
       onChangeEnd = null,
       type = ShadcnSliderType.range;

  @override
  State<ShadcnSlider> createState() => _ShadcnSliderState();
}

class _ShadcnSliderState extends State<ShadcnSlider> {
  late double _currentValue;
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.min;
    _currentRangeValues = widget.rangeValues ?? RangeValues(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(ShadcnSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      _currentValue = widget.value!;
    }
    if (widget.rangeValues != null) {
      _currentRangeValues = widget.rangeValues!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Slider com widgets laterais
        Row(
          children: [
            // Leading widget
            if (widget.leadingWidget != null) ...[
              widget.leadingWidget!,
              const SizedBox(width: 16),
            ],

            // Slider principal
            Expanded(
              child: Column(
                children: [
                  // Labels de valor
                  if (widget.showLabels) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.type == ShadcnSliderType.range
                              ? _getFormattedValue(_currentRangeValues.start)
                              : _getFormattedValue(_currentValue),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (widget.type == ShadcnSliderType.range)
                          Text(
                            _getFormattedValue(_currentRangeValues.end),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: widget.activeColor ?? colorScheme.primary,
                      inactiveTrackColor: widget.inactiveColor ?? colorScheme.outline.withValues(alpha: 0.3),
                      thumbColor: widget.thumbColor ?? colorScheme.primary,
                      overlayColor: (widget.thumbColor ?? colorScheme.primary).withValues(alpha: 0.1),
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: widget.thumbRadius ?? 12,
                      ),
                      trackHeight: 4,
                      tickMarkShape: widget.showTicks 
                          ? const RoundSliderTickMarkShape(tickMarkRadius: 2)
                          : const RoundSliderTickMarkShape(tickMarkRadius: 0),
                      showValueIndicator: ShowValueIndicator.onlyForContinuous,
                      valueIndicatorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    child: widget.type == ShadcnSliderType.range
                        ? RangeSlider(
                            values: _currentRangeValues,
                            min: widget.min,
                            max: widget.max,
                            divisions: widget.divisions,
                            labels: widget.showLabels ? RangeLabels(
                              _getFormattedValue(_currentRangeValues.start),
                              _getFormattedValue(_currentRangeValues.end),
                            ) : null,
                            onChanged: widget.enabled ? (values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                              widget.onRangeChanged?.call(values);
                            } : null,
                            onChangeStart: widget.onRangeChangeStart,
                            onChangeEnd: widget.onRangeChangeEnd,
                          )
                        : Slider(
                            value: _currentValue,
                            min: widget.min,
                            max: widget.max,
                            divisions: widget.divisions,
                            label: widget.showLabels ? _getFormattedValue(_currentValue) : null,
                            onChanged: widget.enabled ? (value) {
                              setState(() {
                                _currentValue = value;
                              });
                              widget.onChanged?.call(value);
                            } : null,
                            onChangeStart: widget.onChangeStart,
                            onChangeEnd: widget.onChangeEnd,
                          ),
                  ),

                  // Ticks/marcas
                  if (widget.showTicks && widget.divisions != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        widget.divisions! + 1,
                        (index) {
                          final value = widget.min + 
                              (widget.max - widget.min) * index / widget.divisions!;
                          return Text(
                            _getFormattedValue(value),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget
            if (widget.trailingWidget != null) ...[
              const SizedBox(width: 16),
              widget.trailingWidget!,
            ],
          ],
        ),
      ],
    );
  }

  String _getFormattedValue(double value) {
    if (widget.labelFormatter != null) {
      return widget.labelFormatter!(value);
    }
    
    if (widget.divisions != null) {
      return value.toInt().toString();
    }
    
    return value.toStringAsFixed(1);
  }
}

/// Slider de volume com ícone
class ShadcnVolumeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const ShadcnVolumeSlider({
    super.key,
    required this.value,
    required this.onChanged,  
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ShadcnSlider.single(
      value: value,
      onChanged: onChanged,
      min: 0,
      max: 100,
      enabled: enabled,
      label: 'Volume',
      labelFormatter: (value) => '${value.toInt()}%',
      leadingWidget: Icon(
        value == 0 ? Icons.volume_off : 
        value < 30 ? Icons.volume_down :
        value < 70 ? Icons.volume_up : Icons.volume_up,
        color: colorScheme.onSurfaceVariant,
      ),
      trailingWidget: Text(
        '${value.toInt()}%',
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Slider de preço com formatação de moeda
class ShadcnPriceRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final double min;
  final double max;
  final bool enabled;

  const ShadcnPriceRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1000,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShadcnSlider.range(
      values: values,
      onChanged: onChanged,
      min: min,
      max: max,
      enabled: enabled,
      label: 'Faixa de Preço',
      labelFormatter: (value) => 'R\$ ${value.toStringAsFixed(0)}',
      divisions: 20,
      showTicks: true,
    );
  }
}

/// Slider de temperatura com cores
class ShadcnTemperatureSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const ShadcnTemperatureSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color getTemperatureColor() {
      if (value < 10) return Colors.blue;
      if (value < 20) return Colors.lightBlue;
      if (value < 30) return Colors.orange;
      return Colors.red;
    }

    return ShadcnSlider.single(
      value: value,
      onChanged: onChanged,
      min: -10,
      max: 50,
      enabled: enabled,
      label: 'Temperatura',
      labelFormatter: (value) => '${value.toInt()}°C',
      activeColor: getTemperatureColor(),
      thumbColor: getTemperatureColor(),
      leadingWidget: Icon(
        Icons.thermostat,
        color: getTemperatureColor(),
      ),
      trailingWidget: Text(
        '${value.toInt()}°C',
        style: TextStyle(
          color: getTemperatureColor(),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}