/// Interface para verificar conectividade
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementação da verificação de rede
/// Nota: Em produção, use o pacote 'connectivity_plus' para verificação real
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: Implementar verificação real com connectivity_plus
    // Por enquanto, assumimos que sempre há conexão
    return true;
  }
}
