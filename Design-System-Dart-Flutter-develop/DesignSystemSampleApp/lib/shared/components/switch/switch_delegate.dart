/// Delegate para eventos do Switch
library;

/// Interface Delegate para capturar eventos do Switch
abstract class SwitchDelegate {
  /// Chamado quando o estado do switch é alterado
  void onChanged(bool value);
}
