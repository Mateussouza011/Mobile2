import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../errors/exceptions.dart';
class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient({
    required String baseUrl,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.add(_LogInterceptor(_logger));
    _dio.interceptors.add(_ErrorInterceptor());
  }
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionException('Tempo de conexão esgotado');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 
                       error.response?.data?['error'] ??
                       'Erro no servidor';
        return ServerException(message, statusCode);
      
      case DioExceptionType.cancel:
        return ConnectionException('Requisição cancelada');
      
      case DioExceptionType.unknown:
        final errorMsg = error.error?.toString() ?? '';
        if (errorMsg.contains('SocketException') || 
            errorMsg.contains('Failed host lookup') ||
            errorMsg.contains('Network is unreachable')) {
          return ConnectionException('Sem conexão com a internet');
        }
        if (errorMsg.contains('Connection refused')) {
          return ConnectionException('Não foi possível conectar ao servidor');
        }
        if (errorMsg.contains('XMLHttpRequest error')) {
          return ConnectionException('Erro de conexão (CORS ou rede)');
        }
        return ServerException('Erro desconhecido: ${error.message}\nDetalhes: $errorMsg');
      
      default:
        return ServerException('Erro inesperado');
    }
  }
}
class _LogInterceptor extends Interceptor {
  final Logger logger;

  _LogInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('🚀 REQUEST[${options.method}] => ${options.uri}');
    logger.d('Headers: ${options.headers}');
    logger.d('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
    logger.i('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}');
    logger.e('Message: ${err.message}');
    logger.e('Data: ${err.response?.data}');
    super.onError(err, handler);
  }
}
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
