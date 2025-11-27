import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface para verificar conectividade
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementação da verificação de rede usando connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({Connectivity? connectivity}) 
      : connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      // Retorna true se houver qualquer tipo de conexão (wifi, mobile, ethernet)
      return result != ConnectivityResult.none;
    } catch (e) {
      // Em caso de erro na verificação, assume que há conexão
      // para não bloquear o app desnecessariamente
      return true;
    }
  }
}
