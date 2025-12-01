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
  const ServerFailure(super.message);
}

/// Falha no cache/banco de dados local
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Falha de banco de dados
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Falha de rede/conectividade
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Recurso não encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Não autorizado
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

/// Acesso negado/Permissão insuficiente
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

/// Falha de autenticação
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// Limite de uso excedido
class UsageLimitFailure extends Failure {
  const UsageLimitFailure(super.message);
}

/// Assinatura inválida ou expirada
class SubscriptionFailure extends Failure {
  const SubscriptionFailure(super.message);
}
