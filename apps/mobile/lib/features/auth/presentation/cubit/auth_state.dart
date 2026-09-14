abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String message;
  AuthLoginSuccess(this.message);
}

class AuthRegisterSuccess extends AuthState {
  final String message;
  AuthRegisterSuccess(this.message);
}

class AuthEmailConfirmRequired extends AuthState {
  final String email;
  final String message;
  AuthEmailConfirmRequired({required this.email, required this.message});
}

class AuthEmailConfirmed extends AuthState {
  final String message;
  AuthEmailConfirmed(this.message);
}

class AuthResendSuccess extends AuthState {
  final String message;
  AuthResendSuccess(this.message);
}

class AuthForgotPasswordSuccess extends AuthState {
  final String message;
  AuthForgotPasswordSuccess(this.message);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
