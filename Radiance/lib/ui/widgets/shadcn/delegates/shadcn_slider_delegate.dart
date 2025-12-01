import 'package:flutter/material.dart';
abstract class ShadcnSliderDelegate {
  void onSliderChangeStart(double value) {}
  void onSliderChanged(double value) {}
  void onSliderChangeEnd(double value) {}
  String formatSliderLabel(double value) {
    return value.toStringAsFixed(1);
  }
  Color getSliderColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  Color getTrackColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary.withValues(alpha: 0.2);
  }
  bool isValueAllowed(double value) {
    return true;
  }
  double snapValue(double value) {
    return value;
  }
  int? getSliderDivisions(double min, double max) {
    return null;
  }
  Widget? getLeadingWidget(double value) {
    return null;
  }
  Widget? getTrailingWidget(double value) {
    return null;
  }
  bool shouldShowLabel() {
    return true;
  }
}
class DefaultShadcnSliderDelegate implements ShadcnSliderDelegate {
  @override
  void onSliderChangeStart(double value) {}
  
  @override
  void onSliderChanged(double value) {}
  
  @override
  void onSliderChangeEnd(double value) {}
  
  @override
  String formatSliderLabel(double value) {
    return value.toStringAsFixed(1);
  }
  
  @override
  Color getSliderColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  
  @override
  Color getTrackColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary.withValues(alpha: 0.2);
  }
  
  @override
  bool isValueAllowed(double value) => true;
  
  @override
  double snapValue(double value) => value;
  
  @override
  int? getSliderDivisions(double min, double max) => null;
  
  @override
  Widget? getLeadingWidget(double value) => null;
  
  @override
  Widget? getTrailingWidget(double value) => null;
  
  @override
  bool shouldShowLabel() => true;
}
class VolumeSliderDelegate extends DefaultShadcnSliderDelegate {
  final Function(double)? onVolumeChanged;
  
  VolumeSliderDelegate({this.onVolumeChanged});
  
  @override
  String formatSliderLabel(double value) {
    return '${(value * 100).toInt()}%';
  }
  
  @override
  double snapValue(double value) {
    return (value * 20).round() / 20;
  }
  
  @override
  Color getSliderColor(double value, ColorScheme colorScheme) {
    if (value >= 0.8) return Colors.red;
    if (value >= 0.5) return Colors.orange;
    return Colors.green;
  }
  
  @override
  Widget? getLeadingWidget(double value) {
    IconData icon;
    if (value == 0) {
      icon = Icons.volume_off;
    } else if (value < 0.3) {
      icon = Icons.volume_mute;
    } else if (value < 0.7) {
      icon = Icons.volume_down;
    } else {
      icon = Icons.volume_up;
    }
    return Icon(icon, size: 24);
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onVolumeChanged?.call(value);
  }
  
  @override
  int? getSliderDivisions(double min, double max) {
    return 20; 
  }
}
class TemperatureSliderDelegate extends DefaultShadcnSliderDelegate {
  final Function(double)? onTemperatureChanged;
  final bool useFahrenheit;
  
  TemperatureSliderDelegate({
    this.onTemperatureChanged,
    this.useFahrenheit = false,
  });
  
  @override
  String formatSliderLabel(double value) {
    if (useFahrenheit) {
      final fahrenheit = (value * 9 / 5) + 32;
      return '${fahrenheit.toInt()}°F';
    }
    return '${value.toInt()}°C';
  }
  
  @override
  Color getSliderColor(double value, ColorScheme colorScheme) {
    if (value >= 30) return Colors.red;
    if (value >= 25) return Colors.orange;
    if (value >= 20) return Colors.yellow;
    if (value >= 15) return Colors.lightBlue;
    if (value >= 10) return Colors.blue;
    return Colors.cyan;
  }
  
  @override
  int? getSliderDivisions(double min, double max) {
    return (max - min).toInt(); 
  }
  
  @override
  Widget? getLeadingWidget(double value) {
    return Icon(
      value < 10 ? Icons.ac_unit : Icons.wb_sunny,
      size: 24,
      color: value < 10 ? Colors.blue : Colors.orange,
    );
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onTemperatureChanged?.call(value);
  }
}
class PriceRangeSliderDelegate extends DefaultShadcnSliderDelegate {
  final String currencySymbol;
  final Function(double)? onPriceChanged;
  
  PriceRangeSliderDelegate({
    this.currencySymbol = 'R\$',
    this.onPriceChanged,
  });
  
  @override
  String formatSliderLabel(double value) {
    return '$currencySymbol ${value.toStringAsFixed(2)}';
  }
  
  @override
  double snapValue(double value) {
    return (value / 10).round() * 10.0;
  }
  
  @override
  Widget? getLeadingWidget(double value) {
    return const Icon(Icons.attach_money, size: 24);
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onPriceChanged?.call(value);
  }
}
class BrightnessSliderDelegate extends DefaultShadcnSliderDelegate {
  final Function(double)? onBrightnessChanged;
  
  BrightnessSliderDelegate({this.onBrightnessChanged});
  
  @override
  String formatSliderLabel(double value) {
    return '${(value * 100).toInt()}%';
  }
  
  @override
  Widget? getLeadingWidget(double value) {
    return Icon(
      Icons.brightness_low,
      size: 24,
      color: Colors.grey[600],
    );
  }
  
  @override
  Widget? getTrailingWidget(double value) {
    return Icon(
      Icons.brightness_high,
      size: 24,
      color: Colors.yellow[700],
    );
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onBrightnessChanged?.call(value);
  }
  
  @override
  int? getSliderDivisions(double min, double max) {
    return 10; 
  }
}
class SpeedSliderDelegate extends DefaultShadcnSliderDelegate {
  final Function(double)? onSpeedChanged;
  
  SpeedSliderDelegate({this.onSpeedChanged});
  
  @override
  String formatSliderLabel(double value) {
    if (value < 0.3) return 'Lento';
    if (value < 0.6) return 'Normal';
    if (value < 0.9) return 'Rápido';
    return 'Muito Rápido';
  }
  
  @override
  Color getSliderColor(double value, ColorScheme colorScheme) {
    if (value >= 0.9) return Colors.red;
    if (value >= 0.6) return Colors.orange;
    if (value >= 0.3) return Colors.yellow;
    return Colors.green;
  }
  
  @override
  Widget? getLeadingWidget(double value) {
    return const Icon(Icons.speed, size: 24);
  }
  
  @override
  int? getSliderDivisions(double min, double max) {
    return 4; 
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onSpeedChanged?.call(value);
  }
}
class ValidatedSliderDelegate extends DefaultShadcnSliderDelegate {
  final double minAcceptable;
  final double maxAcceptable;
  final Function(double)? onValueChanged;
  
  ValidatedSliderDelegate({
    required this.minAcceptable,
    required this.maxAcceptable,
    this.onValueChanged,
  });
  
  @override
  bool isValueAllowed(double value) {
    return value >= minAcceptable && value <= maxAcceptable;
  }
  
  @override
  Color getSliderColor(double value, ColorScheme colorScheme) {
    if (!isValueAllowed(value)) {
      return Colors.red;
    }
    return colorScheme.primary;
  }
  
  @override
  String formatSliderLabel(double value) {
    if (!isValueAllowed(value)) {
      return '${value.toStringAsFixed(1)} (Inválido)';
    }
    return value.toStringAsFixed(1);
  }
  
  @override
  void onSliderChangeEnd(double value) {
    if (isValueAllowed(value)) {
      onValueChanged?.call(value);
    }
  }
}
