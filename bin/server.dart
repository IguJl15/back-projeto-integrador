import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../src/features/auth/api/controllers/auth_controller.dart';
import '../src/features/auth/domain/repositories/auth_repository.dart';
import '../src/features/auth/domain/usecases/login.dart';
import '../src/features/auth/domain/usecases/register.dart';
import '../src/features/auth/domain/utils/hasher.dart';
import '../src/features/auth/domain/utils/tolkien.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final AuthRepository repository = ListAuthRepository();
  final hasher = Hasher();
  final tolkien = Tolkien();

  final registerUseCase = RegisterUseCase(
    authRepository: repository,
    hasher: hasher,
    tolkien: tolkien,
  );
  final loginUseCase = Login(
    authRepository: repository,
    hahser: hasher,
    tolkien: tolkien,
  );

  final authController = AuthController(registerUseCase, loginUseCase);

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addHandler(
    AuthController.getRoute(authController),
  );

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on $ip with port ${server.port}');
}
