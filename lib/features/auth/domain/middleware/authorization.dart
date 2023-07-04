import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/utils/tolkien.dart';
import '../errors/errors.dart';

class AuthorizationMiddleware extends ModularMiddleware {
  final Tolkien tolkien;

  AuthorizationMiddleware(this.tolkien);

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    return (Request request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden('Acesso negado');
      }

      final header = request.headers['authorization'] ?? '';
      final token = header.split(' ').lastOrNull;

      if (token == null) return Response.forbidden('Acesso negado. Header de autorização mal formado');

      try {
        tolkien.verify(token);

        return handler(request);
      } on JwtError catch (e) {
        return Response(
          e.statusCode,
          body: jsonEncode({'error': e.toMap()}),
        );
      }
    };
  }
}
