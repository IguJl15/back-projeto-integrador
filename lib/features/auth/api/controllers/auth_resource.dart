import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../../core/errors/application_error.dart';
import '../../domain/dto/register_user_dto.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/register.dart';

class AuthResource extends Resource {
  AuthResource();

  @override
  get routes => [
        Route.post('/register', register),
        Route.post('/login', login),
        Route.post('/refresh', refreshTokens),
      ];

  Future<Response> login(ModularArguments args, Injector injector) async {
    final loginUseCase = injector<Login>();

    try {
      final usecaseResponse = await loginUseCase(args.data['email'], args.data['password']);

      return Response(
        HttpStatus.created,
        body: jsonEncode(usecaseResponse.toMap()),
      );
    } on ApplicationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({"error": e.toMap()}),
      );
    }
  }

  Future<Response> register(ModularArguments args, Injector injector) async {
    final registerUseCase = injector<RegisterUseCase>();

    try {
      final registerDto = RegisterUserDto.fromMap(args.data);

      final usecaseResponse = await registerUseCase(registerDto);

      return Response(
        HttpStatus.created,
        body: jsonEncode(usecaseResponse.toMap()),
      );
    } on ApplicationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({
          "error": e.toMap(),
        }),
      );
    }
  }

  Future<Response> refreshTokens(ModularArguments args, Injector injector) async {
    final refreshToken = injector<RefreshTokenUseCase>();

    try {
      final usecaseResult = await refreshToken(args.data['refreshToken'] ?? "");

      return Response(
        HttpStatus.ok,
        body: jsonEncode(usecaseResult.toMap()),
      );
    } on ApplicationError catch (e) {
      return Response(
        e.statusCode,
        body: jsonEncode({"error": e.toMap()}),
      );
    }
  }
}
