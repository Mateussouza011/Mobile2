/// Delegate para eventos do Button
/// Define os métodos de callback que o Button pode disparar
library;

/// Interface Delegate para capturar eventos do Button
/// 
/// Esta interface segue o padrão Delegate, permitindo que o código
/// cliente implemente os métodos de callback sem usar Function()
/// 
/// Exemplo de uso:
/// ```dart
/// class MyScreen extends StatelessWidget implements ButtonDelegate {
///   @override
///   void onPressed() {
///     print('Button pressed!');
///   }
///   
///   @override
///   void onLongPress() {
///     print('Button long pressed!');
///   }
/// }
/// ```
abstract class ButtonDelegate {
  /// Chamado quando o botão é pressionado (tap)
  void onPressed();

  /// Chamado quando o botão é pressionado longamente
  /// 
  /// Este método é opcional e pode não ser implementado
  /// dependendo da necessidade
  void onLongPress() {
    // Implementação padrão vazia
  }
}
