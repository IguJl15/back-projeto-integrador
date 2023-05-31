import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../domain/dto/register_user_dto.dart';
import '../../domain/errors/errors.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';

class AuthResource extends Resource {
  AuthResource();

  @override
  get routes => [
        Route.get('/register', register),
        Route.get('/login', login),
      ];

  Future<Response> login(ModularArguments args, Injector injector) async {
    final body = args.data;
    final loginUseCase = injector<Login>();

    try {
      final usecaseResponse = loginUseCase(body['email'], body['password']);

      return Response(
        HttpStatus.created,
        body: jsonEncode({
          "accessToken": usecaseResponse,
        }),
      );
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

  Future<Response> register(ModularArguments args, Injector injector) async {
    final registerUseCase = injector<RegisterUseCase>();

    try {
      final registerDto = RegisterUserDto(
        args.data['fullName'] ?? '',
        args.data['email'] ?? '',
        args.data['phone'],
        args.data['password'] ?? '',
        args.data['confirmedPassword'] ?? '',
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
