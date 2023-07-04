import 'dart:io';

base class ApplicationError {
  final int statusCode;
  final String error;

  ApplicationError(this.statusCode, this.error);

  Map<String, dynamic> toMap() => {"title": error};
}

base class NotFoundError extends ApplicationError {
  NotFoundError([String? error]) : super(HttpStatus.notFound, error ?? "Não encontrado");
}
