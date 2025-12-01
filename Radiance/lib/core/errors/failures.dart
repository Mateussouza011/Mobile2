import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor']);
}
class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Erro de conexão']);
}
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar dados locais']);
}
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dados inválidos']);
}
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Erro de autenticação']);
}
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'Sem permissão']);
}
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado']);
}
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Erro inesperado']);
}
