class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'https://web-production-94f5d.up.railway.app';
  static const String predictDiamondPriceEndpoint = '/predict';
  static String get predictUrl => '$baseUrl$predictDiamondPriceEndpoint';
  static const int defaultTimeout = 30;
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
class StorageConstants {
  StorageConstants._();
  static const String databaseName = 'diamond_prediction.db';
  static const int databaseVersion = 1;
  static const String usersTable = 'users';
  static const String predictionHistoryTable = 'prediction_history';
  static const String currentUserKey = 'current_user_id';
}
