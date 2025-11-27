import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/api_response.dart';

/// Rate limiter para controlar requisições por empresa
class RateLimiter {
  // Mapa: companyId -> RequestLog
  final Map<String, RequestLog> _requestLogs = {};

  // Limites por tier
  static const Map<String, RateLimitConfig> _tierLimits = {
    'free': RateLimitConfig(requestsPerMinute: 10, requestsPerHour: 100),
    'pro': RateLimitConfig(requestsPerMinute: 60, requestsPerHour: 1000),
    'enterprise': RateLimitConfig(requestsPerMinute: 300, requestsPerHour: 10000),
  };

  /// Verifica se a empresa pode fazer uma requisição
  Either<Failure, RateLimitInfo> checkLimit({
    required String companyId,
    required String tier,
  }) {
    final config = _tierLimits[tier.toLowerCase()] ?? _tierLimits['free']!;
    final now = DateTime.now();

    // Buscar ou criar log
    final log = _requestLogs.putIfAbsent(
      companyId,
      () => RequestLog(companyId: companyId),
    );

    // Limpar requisições antigas
    log.cleanOldRequests(now);

    // Verificar limite por minuto
    if (log.requestsInLastMinute(now) >= config.requestsPerMinute) {
      final resetAt = log.getNextMinuteReset(now);
      return Left(
        RateLimitFailure(
          'Rate limit exceeded: ${config.requestsPerMinute} requests per minute',
          resetAt: resetAt,
        ),
      );
    }

    // Verificar limite por hora
    if (log.requestsInLastHour(now) >= config.requestsPerHour) {
      final resetAt = log.getNextHourReset(now);
      return Left(
        RateLimitFailure(
          'Rate limit exceeded: ${config.requestsPerHour} requests per hour',
          resetAt: resetAt,
        ),
      );
    }

    // Registrar requisição
    log.addRequest(now);

    // Calcular remaining
    final remainingMinute = config.requestsPerMinute - log.requestsInLastMinute(now);
    final remainingHour = config.requestsPerHour - log.requestsInLastHour(now);

    return Right(
      RateLimitInfo(
        limit: config.requestsPerMinute,
        remaining: remainingMinute < remainingHour ? remainingMinute : remainingHour,
        resetAt: log.getNextMinuteReset(now),
      ),
    );
  }

  /// Limpa logs antigos (pode ser chamado periodicamente)
  void cleanup() {
    final now = DateTime.now();
    _requestLogs.removeWhere((_, log) {
      log.cleanOldRequests(now);
      return log.isEmpty;
    });
  }
}

/// Configuração de rate limit
class RateLimitConfig {
  final int requestsPerMinute;
  final int requestsPerHour;

  const RateLimitConfig({
    required this.requestsPerMinute,
    required this.requestsPerHour,
  });
}

/// Log de requisições por empresa
class RequestLog {
  final String companyId;
  final List<DateTime> requests = [];

  RequestLog({required this.companyId});

  void addRequest(DateTime timestamp) {
    requests.add(timestamp);
  }

  int requestsInLastMinute(DateTime now) {
    final threshold = now.subtract(const Duration(minutes: 1));
    return requests.where((r) => r.isAfter(threshold)).length;
  }

  int requestsInLastHour(DateTime now) {
    final threshold = now.subtract(const Duration(hours: 1));
    return requests.where((r) => r.isAfter(threshold)).length;
  }

  void cleanOldRequests(DateTime now) {
    final threshold = now.subtract(const Duration(hours: 1));
    requests.removeWhere((r) => r.isBefore(threshold));
  }

  DateTime getNextMinuteReset(DateTime now) {
    return DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
  }

  DateTime getNextHourReset(DateTime now) {
    return DateTime(now.year, now.month, now.day, now.hour + 1, 0);
  }

  bool get isEmpty => requests.isEmpty;
}

/// Failure específico de rate limit
class RateLimitFailure extends Failure {
  final DateTime resetAt;

  RateLimitFailure(String message, {required this.resetAt}) : super(message);
}
