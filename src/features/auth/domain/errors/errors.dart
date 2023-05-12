abstract class AuthError {
  final String message;

  AuthError(this.message);
}

class AuthValidationError extends AuthError {
  final String field;
  final String error;

  AuthValidationError(this.field, this.error) : super('');
}
