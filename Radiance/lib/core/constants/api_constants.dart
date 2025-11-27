/// Constantes da API para o Diamond Prediction App
class ApiConstants {
  ApiConstants._();

  /// Base URL da API de produção
  static const String baseUrl = 'https://web-production-94f5d.up.railway.app';
  
  /// Endpoint de predição de preços de diamantes
  static const String predictDiamondPriceEndpoint = '/predict';
  
  /// URL completa para predição
  static String get predictUrl => '$baseUrl$predictDiamondPriceEndpoint';
  
  /// Timeout padrão para requisições (em segundos)
  static const int defaultTimeout = 30;
  
  /// Headers padrão para requisições
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

/// Constantes de armazenamento local
class StorageConstants {
  StorageConstants._();
  
  /// Nome do banco de dados SQLite
  static const String databaseName = 'diamond_prediction.db';
  
  /// Versão do banco de dados
  static const int databaseVersion = 1;
  
  /// Tabela de usuários
  static const String usersTable = 'users';
  
  /// Tabela de histórico de predições
  static const String predictionHistoryTable = 'prediction_history';
  
  /// Chave para usuário atual no SharedPreferences
  static const String currentUserKey = 'current_user_id';
}
