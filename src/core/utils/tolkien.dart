import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'uu_aidi.dart';

class Tolkien {
  final UuAidi uuAidi;
  static const secret = "my super secret";

  Tolkien({required this.uuAidi});


  ({String token, String jti}) sign(Map<String, dynamic> payload, Duration expiresIn) {
    final jti = payload["jti"] ??= uuAidi.generateV4();

    final jwt = JWT(payload);

    return (
      jti: jti,
      token: jwt.sign(SecretKey(secret), expiresIn: expiresIn),
    );
  }
}
