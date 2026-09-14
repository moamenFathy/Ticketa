import 'package:ticketa/core/errors/exceptions.dart';

/// Base Failure class representing domain/presentation error models.
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  factory Failure.fromException(dynamic error) {
    if (error is AppException) {
      if (error is NetworkException) return NetworkFailure(error.message);
      if (error is AuthException) return AuthFailure(error.message);
      if (error is ValidationException) return ValidationFailure(error.message);
      return ServerFailure(error.message);
    }
    return ServerFailure(AppException.extractMessage(error));
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection error. Please check your internet.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
