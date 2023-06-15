import 'dart:io';

import '../../../../core/errors/application_error.dart';

base class DirectionError extends ApplicationError {
  DirectionError(super.statusCode, super.error);
}

/// The term [term] cannot be used because it is a forbidden term
final class ForbiddenTermError extends DirectionError {
  ForbiddenTermError(String term)
      : super(
          HttpStatus.badRequest,
          'O termo "$term" não pode ser usado em direcionamentos pois é um termo proibido',
        );
}

final class MaximumTermsAllowedExceeded extends DirectionError {
  MaximumTermsAllowedExceeded(int maximumTerms)
      : super(HttpStatus.badRequest, 'O número máximo de $maximumTerms termos foi excedido');
}

final class InvalidTermError extends DirectionError {
  final String term;
  final String details;

  InvalidTermError(this.term, this.details)
      : super(
          HttpStatus.badRequest,
          'Termo "$term" inválido. $details',
        );

  @override
  Map<String, dynamic> toMap() => {
        "title": error,
        "term": term,
        "message": details,
      };
}
