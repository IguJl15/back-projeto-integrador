import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../src/app_module.dart';
import '../src/core/database/database.dart';
import 'env.dart';

void main(List<String> args) async {
  await DatabaseConnection.instance.openConnection();

  final modularHandler = Modular(
    middlewares: [logRequests(), corsHeaders()],
    module: AppModule(),
  );

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final port = Env().port ?? 8080;
  final server = await serve(modularHandler, ip, port);
  print('Server listening on $ip with port ${server.port}');
}
