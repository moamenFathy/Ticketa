/// Base exception class for all application exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;

  /// Utility to extract clean message from any exception or dynamic object.
  static String extractMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    if (error is Exception) {
      final str = error.toString();
      return str.startsWith('Exception: ') ? str.substring(11) : str;
    }
    return error?.toString() ?? 'Something went wrong';
  }
}

/// Thrown when server returns an error response (4xx, 5xx).
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// Thrown when network connection issues occur (timeout, no internet).
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection error. Please check your internet.']);
}

/// Thrown for authentication/authorization errors.
class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

/// Thrown when input validation fails.
class ValidationException extends AppException {
  const ValidationException(super.message);
}
