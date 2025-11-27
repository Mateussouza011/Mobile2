import 'package:flutter/material.dart';

/// Delegate para customizar o comportamento do ShadcnSlider
/// 
/// Este delegate permite centralizar toda a lógica de sliders,
/// incluindo formatação de labels, cores dinâmicas e validação,
/// seguindo o padrão Delegate para desacoplamento e reutilização.
abstract class ShadcnSliderDelegate {
  /// Chamado quando o usuário começa a arrastar o slider
  /// 
  /// [value] é o valor inicial do slider
  void onSliderChangeStart(double value) {}
  
  /// Chamado continuamente enquanto o usuário arrasta o slider
  /// 
  /// [value] é o valor atual do slider
  void onSliderChanged(double value) {}
  
  /// Chamado quando o usuário solta o slider
  /// 
  /// [value] é o valor final do slider
  void onSliderChangeEnd(double value) {}
  
  /// Formata o label que aparece acima do slider
  /// 
  /// [value] é o valor atual do slider
  /// Retorna a string formatada a ser exibida
  String formatSliderLabel(double value) {
    return value.toStringAsFixed(1);
  }
  
  /// Retorna a cor do slider baseado no valor atual
  /// 
  /// [value] é o valor atual do slider
  /// [colorScheme] é o esquema de cores do tema atual
  Color getSliderColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary;
  }
  
  /// Retorna a cor da track (trilha) do slider
  /// 
  /// [value] é o valor atual do slider
  /// [colorScheme] é o esquema de cores do tema atual
  Color getTrackColor(double value, ColorScheme colorScheme) {
    return colorScheme.primary.withValues(alpha: 0.2);
  }
  
  /// Valida se um valor é permitido
  /// 
  /// [value] é o valor a ser validado
  /// Retorna true se o valor é válido, false caso contrário
  bool isValueAllowed(double value) {
    return true;
  }
  
  /// Ajusta o valor para "snap" em valores específicos
  /// 
  /// [value] é o valor original
  /// Retorna o valor ajustado (pode ser o mesmo se não houver snap)
  double snapValue(double value) {
    return value;
  }
  
  /// Define o número de divisões do slider
  /// 
  /// [min] é o valor mínimo do slider
  /// [max] é o valor máximo do slider
  /// Retorna o número de divisões ou null para slider contínuo
  int? getSliderDivisions(double min, double max) {
    return null;
  }
  
  /// Retorna o ícone a ser exibido à esquerda do slider
  Widget? getLeadingWidget(double value) {
    return null;
  }
  
  /// Retorna o ícone a ser exibido à direita do slider
  Widget? getTrailingWidget(double value) {
    return null;
  }
  
  /// Define se deve mostrar o label
  bool shouldShowLabel() {
    return true;
  }
}

/// Implementação padrão do ShadcnSliderDelegate
/// 
/// Fornece comportamento básico sem customizações.
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

/// Delegate para slider de volume
/// 
/// Formata valores como porcentagem e muda cor baseado no nível.
class VolumeSliderDelegate extends DefaultShadcnSliderDelegate {
  final Function(double)? onVolumeChanged;
  
  VolumeSliderDelegate({this.onVolumeChanged});
  
  @override
  String formatSliderLabel(double value) {
    return '${(value * 100).toInt()}%';
  }
  
  @override
  double snapValue(double value) {
    // Snap para múltiplos de 0.05 (5%)
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
    // Salvar nas preferências
    // SharedPreferences.setDouble('volume', value);
  }
  
  @override
  int? getSliderDivisions(double min, double max) {
    return 20; // 5% de incremento
  }
}

/// Delegate para slider de temperatura
/// 
/// Mostra valores em graus Celsius com cores apropriadas.
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
    return (max - min).toInt(); // Uma divisão por grau
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

/// Delegate para slider de preço/faixa de valores
/// 
/// Formata valores monetários com símbolo de moeda.
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
    // Snap para múltiplos de 10
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

/// Delegate para slider de brilho
/// 
/// Controla brilho da tela com ícones apropriados.
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
    return 10; // 10% de incremento
  }
}

/// Delegate para slider de progresso/velocidade
/// 
/// Mostra velocidade com cores graduais.
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
    return 4; // Lento, Normal, Rápido, Muito Rápido
  }
  
  @override
  void onSliderChangeEnd(double value) {
    onSpeedChanged?.call(value);
  }
}

/// Delegate para slider com validação
/// 
/// Impede valores fora de uma faixa aceitável.
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
