import 'dart:io';

abstract class AuthError {
  final int statusCode;
  final String error;

  AuthError(this.statusCode, this.error);

  Map<String, dynamic> toMap() => {"title": error};
}

class AuthValidationError extends AuthError {
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

class UserNotFound extends AuthError {
  UserNotFound(String? message) : super(HttpStatus.notFound, message ?? "User not found");
}

class EmailAlreadyInUse extends AuthError {
  EmailAlreadyInUse() : super(HttpStatus.badRequest, "Este email ja está em uso");
}
