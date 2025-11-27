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
  const ServerFailure([super.message = 'Erro no servidor']);
}

/// Falha de conexão (timeout, sem internet)
class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Erro de conexão']);
}

/// Falha de cache/database local
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar dados locais']);
}

/// Falha de validação de dados
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dados inválidos']);
}

/// Falha de autenticação (401)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Erro de autenticação']);
}

/// Falha de autorização (403)
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'Sem permissão']);
}

/// Falha de não encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado']);
}

/// Falha genérica
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Erro inesperado']);
}
