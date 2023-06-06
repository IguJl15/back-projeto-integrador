import 'package:password_hash/password_hash.dart';
import 'package:password_hash/salt.dart';

class Hasher {
  static const saltLength = 8;
  static const passwordHashLength = 32;
  static const rounds = 2000;

  String generateSalt() {
    return Salt.generateAsBase64String(saltLength);
  }

  String hashPassword(String password, String salt) {
    final hash =
        PBKDF2().generateBase64Key(password, salt, rounds, passwordHashLength);

    return hash;
  }
}
