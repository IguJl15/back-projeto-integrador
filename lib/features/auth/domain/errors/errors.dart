import 'dart:io';

base class AuthError {
  final int statusCode;
  final String error;

  AuthError(this.statusCode, this.error);

  Map<String, dynamic> toMap() => {"title": error};
}

final class AuthValidationError extends AuthError {
  final String field;
  final String detail;

  AuthValidationError(this.field, this.detail) : super(HttpStatus.badRequest, "Campo Inválido");

  @override
  Map<String, dynamic> toMap() => {
        "title": error,
        "field": field,
        "message": detail,
      };
}

final class UserNotFound extends AuthError {
  UserNotFound(String? message) : super(HttpStatus.notFound, message ?? "User not found");
}

final class EmailAlreadyInUse extends AuthError {
  EmailAlreadyInUse() : super(HttpStatus.badRequest, "Este email ja está em uso");
}

base class JwtError extends AuthError {
  JwtError(String message) : super(401, message);
}

final class JwtExpiredError extends JwtError {
  JwtExpiredError(super.message);
}
