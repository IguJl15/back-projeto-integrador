import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Tolkien {
  static const secret = "my super secret";

  String sign(Map<String, dynamic> payload) {
    final jwt = JWT(payload);
    return jwt.sign(SecretKey(secret), expiresIn: const Duration(minutes: 30));
  }
}
