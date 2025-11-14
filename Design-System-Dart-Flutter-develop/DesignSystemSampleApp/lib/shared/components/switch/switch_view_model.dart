/// ViewModel do Switch
library;

/// ViewModel imutável do Switch
class SwitchViewModel {
  /// Label do switch
  final String? label;
  
  /// Estado do switch
  final bool value;
  
  /// Se o switch está habilitado
  final bool enabled;
  
  /// Descrição/helper text
  final String? description;

  const SwitchViewModel({
    this.label,
    this.value = false,
    this.enabled = true,
    this.description,
  });

  SwitchViewModel copyWith({
    String? label,
    bool? value,
    bool? enabled,
    String? description,
  }) {
    return SwitchViewModel(
      label: label ?? this.label,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }
}
