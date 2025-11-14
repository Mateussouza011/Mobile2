/// ViewModel do Checkbox
library;

/// ViewModel imutável do Checkbox
class CheckboxViewModel {
  /// Label do checkbox
  final String? label;
  
  /// Estado checked (true = checked, false = unchecked, null = indeterminate)
  final bool? checked;
  
  /// Se o checkbox está habilitado
  final bool enabled;
  
  /// Descrição/helper text
  final String? description;

  const CheckboxViewModel({
    this.label,
    this.checked = false,
    this.enabled = true,
    this.description,
  });

  CheckboxViewModel copyWith({
    String? label,
    bool? checked,
    bool? enabled,
    String? description,
  }) {
    return CheckboxViewModel(
      label: label ?? this.label,
      checked: checked,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
    );
  }
}
