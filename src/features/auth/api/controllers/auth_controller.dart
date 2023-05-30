import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../domain/dto/register_user_dto.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';

class AuthController {
  final RegisterUseCase registerUseCase;
  final Login loginUseCase;

  AuthController(
    this.registerUseCase,
    this.loginUseCase,
  );

  static Router getRoute(AuthController controller) => Router()
    ..get('/register', controller.register)
    ..get('/login', controller.login);

  Future<Response> login(Request req) async {
    final body = await req.readAsString();
    final bodyMap = jsonDecode(body);

    try {
      final usecaseResponse = loginUseCase(bodyMap['email'], bodyMap['password']);

      return Response(HttpStatus.created,
          body: jsonEncode(
            {
              "accessToken": usecaseResponse,
            },
          ));
    } on AuthValidationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": {
            "title": e.error,
            "field": e.field,
            "message": e.detail,
          },
        }),
      );
    } on AuthError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": {"title": e.error},
        }),
      );
    }
  }

  @Route.get('register')
  Future<Response> register(Request req) async {
    final body = await req.readAsString();
    final bodyMap = jsonDecode(body);

    try {
      final registerDto = RegisterUserDto(
        bodyMap['fullName'] ?? '',
        bodyMap['email'] ?? '',
        bodyMap['phone'],
        bodyMap['password'] ?? '',
        bodyMap['confirmedPassword'] ?? '',
      );

      final usecaseResponse = registerUseCase(registerDto);

      return Response(HttpStatus.created,
          body: jsonEncode(
            {
              "accessToken": usecaseResponse,
            },
          ));
    } on AuthValidationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": {
            "title": e.error,
            "field": e.field,
            "message": e.detail,
          },
        }),
      );
    } on AuthError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": {"title": e.error},
        }),
      );
    }
  }
}
