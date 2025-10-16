/// Classe abstrata que define o contrato para tratar eventos do BottomTabBar
/// Implementa o padrão Delegate para desacoplar o tratamento de eventos
abstract class BottomTabBarDelegate {
  /// Método chamado quando um item da bottom tab bar é selecionado
  /// [index] - índice do item selecionado
  void onBottomTabBarIndexChanged(int index);
}
