import 'package:logger/logger.dart';

/// Wrapper simplificado para logging da aplicação
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  void debug(dynamic message) {
    _logger.d(message);
  }

  void info(dynamic message) {
    _logger.i(message);
  }

  void warning(dynamic message) {
    _logger.w(message);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void verbose(dynamic message) {
    _logger.t(message);
  }

  void wtf(dynamic message) {
    _logger.f(message);
  }
}
