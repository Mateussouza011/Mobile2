/// Delegate para eventos do Checkbox
library;

/// Interface Delegate para capturar eventos do Checkbox
abstract class CheckboxDelegate {
  /// Chamado quando o estado do checkbox é alterado
  /// 
  /// @param checked - novo estado (true = checked, false = unchecked, null = indeterminate)
  void onChanged(bool? checked);
}
