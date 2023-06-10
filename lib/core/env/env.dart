import 'dart:io';

import 'package:dotenv_gen/dotenv_gen.dart';

part 'env.g.dart';

@DotEnvGen()
abstract class Env {
  const factory Env() = _$Env;
  const Env._();

  // Database
  String get databaseName;
  String get databaseHost;
  int get databasePort;
  String get databaseUser;
  String get databasePassword;

  // Tolkens signature;
  String get apiSecret;

// Password hash generation;
  int get passwordSaltLength;
  int get passwordHashLength;
  int get passwordHashRounds;

  int? get port => int.tryParse(Platform.environment['PORT'] ?? "");
}
