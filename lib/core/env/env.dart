import 'dart:io';

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  // Database
  @EnviedField()
  static String databaseName = _Env.databaseName;
  @EnviedField()
  static String databaseHost = _Env.databaseHost;
  @EnviedField()
  static int databasePort = _Env.databasePort;
  @EnviedField()
  static String databaseUser = _Env.databaseUser;
  @EnviedField()
  static String databasePassword = _Env.databasePassword;

  // Tolkens
  @EnviedField()
  static String apiSecret = _Env.apiSecret;
  @EnviedField()
  static int accessTokenExpiration = _Env.accessTokenExpiration;
  @EnviedField()
  static int refreshTokenExpiration = _Env.refreshTokenExpiration;

// Password hash generation;
  @EnviedField()
  static int passwordSaltLength = _Env.passwordSaltLength;
  @EnviedField()
  static int passwordHashLength = _Env.passwordHashLength;
  @EnviedField()
  static int passwordHashRounds = _Env.passwordHashRounds;

  @EnviedField(defaultValue: 8080)
  static int port = _Env.port;
}
