import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../src/app_module.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final modularHandler = Modular(
    middlewares: [logRequests()],
    module: AppModule(),
  );

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(modularHandler, ip, port);
  print('Server listening on $ip with port ${server.port}');
}
