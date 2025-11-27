/// Exceção de servidor
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exceção de conexão
class ConnectionException implements Exception {
  final String message;
  
  ConnectionException(this.message);
  
  @override
  String toString() => 'ConnectionException: $message';
}

/// Exceção de cache
class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

/// Exceção de validação
class ValidationException implements Exception {
  final String message;
  
  ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
}
