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

  Future<Response> login(Request request, Injector injector) async {
    final body = jsonDecode(await request.readAsString());
    final loginUseCase = injector<Login>();

    try {
      final usecaseResponse = loginUseCase(body['email'], body['password']);

      return Response(
        HttpStatus.created,
        body: jsonEncode(usecaseResponse.toMap()),
      );
    } on AuthError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({"error": e.toMap()}),
      );
    }
  }

  Future<Response> register(Request request, Injector injector) async {
    final registerUseCase = injector<RegisterUseCase>();

    try {
      final registerDto = RegisterUserDto.fromMap(jsonDecode(await request.readAsString()));

      final usecaseResponse = registerUseCase(registerDto);

      return Response(
        HttpStatus.created,
        body: jsonEncode(usecaseResponse.toMap()),
      );
    } on AuthError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": e.toMap(),
        }),
      );
    }
  }
}
