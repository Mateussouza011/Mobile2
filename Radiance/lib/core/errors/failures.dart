import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}
class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Connection error']);
}
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error accessing local data']);
}
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid data']);
}
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication error']);
}
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'No permission']);
}
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected error']);
}
