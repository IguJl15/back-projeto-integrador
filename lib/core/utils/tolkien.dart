import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../features/auth/domain/errors/errors.dart';
import '../env/env.dart';
import 'uu_aidi.dart';

class Tolkien {
  final UuAidi uuAidi;
  final secret = Env.apiSecret;

  Tolkien({required this.uuAidi});

  void verify(String token) {
    try {
      JWT.verify(token, SecretKey(secret));
    } on JWTException catch (e) {
      if (e.message.contains('expired')) throw JwtExpiredError(e.message);
      throw JwtError(e.message);
    }
  }

  Map<String, dynamic> getPayload(String token) {
    return JWT.decode(token).payload;
  }

  ({String token, String jti}) sign(Map<String, dynamic> payload, Duration expiresIn) {
    final jti = payload["jti"] ??= uuAidi.generateV4();

    final jwt = JWT(payload);

    return (
      jti: jti,
      token: jwt.sign(SecretKey(secret), expiresIn: expiresIn),
    );
  }
}
