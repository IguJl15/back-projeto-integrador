import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:back_projeto_integrador/app_module.dart';
import 'package:back_projeto_integrador/core/database/database.dart';

import 'package:back_projeto_integrador/core/env/env.dart';

void main(List<String> args) async {
  await DatabaseConnection.instance.openConnection();

  final modularHandler = Modular(
    middlewares: [logRequests(), corsHeaders()],
    module: AppModule(),
  );

  HttpOverrides.global = ScrapGlobalHttpOverrides();

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final port = Env.port;
  final server = await serve(modularHandler, ip, port);
  print('Server listening on $ip with port ${server.port}');
}

class ScrapGlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
