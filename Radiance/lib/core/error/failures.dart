import 'package:equatable/equatable.dart';

/// Classe base para todos os erros/falhas do domínio
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Falha no servidor/API
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Falha no cache/banco de dados local
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Falha de banco de dados
class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

/// Falha de rede/conectividade
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Recurso não encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

/// Não autorizado
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message) : super(message);
}

/// Acesso negado/Permissão insuficiente
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(String message) : super(message);
}

/// Falha de autenticação
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message) : super(message);
}

/// Limite de uso excedido
class UsageLimitFailure extends Failure {
  const UsageLimitFailure(String message) : super(message);
}

/// Assinatura inválida ou expirada
class SubscriptionFailure extends Failure {
  const SubscriptionFailure(String message) : super(message);
}
