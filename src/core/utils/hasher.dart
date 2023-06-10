import 'dart:io';

import 'package:password_hash/password_hash.dart';

import '../../../bin/env.dart';

class Hasher {
  final saltLength = Env().passwordSaltLength;
  final passwordHashLength = Env().passwordHashLength;
  final rounds = Env().passwordHashRounds;

  String generateSalt() {
    return Salt.generateAsBase64String(saltLength);
  }

  String hashPassword(String password, String salt) {
    final hash = PBKDF2().generateBase64Key(password, salt, rounds, passwordHashLength);

    return hash;
  }
}
