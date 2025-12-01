import 'package:dartz/dartz.dart';
import '../../../api_keys/data/repositories/api_key_repository.dart';
import '../../../api_keys/domain/entities/api_key.dart';
import '../../../../core/error/failures.dart';

/// Middleware de autenticação para API REST
class ApiAuthMiddleware {
  final ApiKeyRepository _apiKeyRepository;

  ApiAuthMiddleware({required ApiKeyRepository apiKeyRepository})
      : _apiKeyRepository = apiKeyRepository;

  /// Valida o token de autorização do header
  Future<Either<Failure, ApiKey>> authenticate(String? authHeader) async {
    // Verificar se o header existe
    if (authHeader == null || authHeader.isEmpty) {
      return const Left(UnauthorizedFailure('Authorization header is required'));
    }

    // Verificar formato Bearer
    if (!authHeader.startsWith('Bearer ')) {
      return const Left(UnauthorizedFailure('Invalid authorization format. Use: Bearer <api_key>'));
    }

    // Extrair token
    final token = authHeader.substring(7).trim();

    if (token.isEmpty) {
      return const Left(UnauthorizedFailure('API key is required'));
    }

    // Validar formato da chave (deve começar com rdk_)
    if (!token.startsWith('rdk_')) {
      return const Left(UnauthorizedFailure('Invalid API key format'));
    }

    // Validar chave no repositório
    final result = await _apiKeyRepository.validateApiKey(token);

    return result.fold(
      (failure) => const Left(UnauthorizedFailure('Invalid or expired API key')),
      (apiKey) {
        // Verificar se a chave está ativa
        if (!apiKey.isActive) {
          return const Left(UnauthorizedFailure('API key has been revoked'));
        }

        // Verificar se a chave expirou
        if (apiKey.isExpired) {
          return const Left(UnauthorizedFailure('API key has expired'));
        }

        return Right(apiKey);
      },
    );
  }

  /// Verifica se a API key tem uma permissão específica
  bool hasPermission(ApiKey apiKey, String permission) {
    return apiKey.permissions.contains(permission);
  }

  /// Verifica múltiplas permissões (OR)
  bool hasAnyPermission(ApiKey apiKey, List<String> permissions) {
    return permissions.any((p) => apiKey.permissions.contains(p));
  }

  /// Verifica múltiplas permissões (AND)
  bool hasAllPermissions(ApiKey apiKey, List<String> permissions) {
    return permissions.every((p) => apiKey.permissions.contains(p));
  }
}
