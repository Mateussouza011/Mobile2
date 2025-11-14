/// Delegate para eventos do Input
/// Define os métodos de callback que o Input pode disparar
library;

/// Interface Delegate para capturar eventos do Input
/// 
/// Esta interface segue o padrão Delegate, permitindo que o código
/// cliente implemente os métodos de callback sem usar Function()
/// 
/// Exemplo de uso:
/// ```dart
/// class MyScreen extends StatelessWidget implements InputDelegate {
///   @override
///   void onChanged(String value) {
///     print('Input changed: $value');
///   }
///   
///   @override
///   void onSubmitted(String value) {
///     print('Input submitted: $value');
///   }
/// }
/// ```
abstract class InputDelegate {
  /// Chamado quando o texto do input é alterado
  void onChanged(String value);

  /// Chamado quando o usuário submete o input (Enter)
  /// 
  /// Este método é opcional
  void onSubmitted(String value) {
    // Implementação padrão vazia
  }

  /// Chamado quando o input ganha foco
  /// 
  /// Este método é opcional
  void onFocusChanged(bool hasFocus) {
    // Implementação padrão vazia
  }
}
