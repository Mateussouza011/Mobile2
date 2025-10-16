/// Classe abstrata que define o contrato para tratar eventos do TabComponent
/// Implementa o padrão Delegate para desacoplar o tratamento de eventos
abstract class TabDelegate {
  /// Método chamado quando um tab é selecionado
  /// [index] - índice do tab selecionado
  void onTabIndexChanged(int index);
}
