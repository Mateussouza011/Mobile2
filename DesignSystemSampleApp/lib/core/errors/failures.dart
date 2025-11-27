import 'package:equatable/equatable.dart';

/// Classe base para todos os tipos de falhas na aplicação
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Falha de servidor (5xx)
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Erro no servidor']) : super(message);
}

/// Falha de conexão (timeout, sem internet)
class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'Erro de conexão']) : super(message);
}

/// Falha de cache/database local
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Erro ao acessar dados locais']) : super(message);
}

/// Falha de validação de dados
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Dados inválidos']) : super(message);
}

/// Falha de autenticação (401)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Erro de autenticação']) : super(message);
}

/// Falha de autorização (403)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([String message = 'Sem permissão']) : super(message);
}

/// Falha de não encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Recurso não encontrado']) : super(message);
}

/// Falha genérica
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'Erro inesperado']) : super(message);
}
