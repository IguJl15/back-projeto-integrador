import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'uu_aidi.dart';

class Tolkien {
  final UuAidi uuAidi;
  static const secret = "my super secret";

  Tolkien({required this.uuAidi});

  String sign(Map<String, dynamic> payload, Duration expiresIn) {
    if (!payload.containsKey("jti")) payload["jti"] = uuAidi.generateV4();

    final jwt = JWT(payload);

    return jwt.sign(SecretKey(secret), expiresIn: expiresIn);
  }

  String newRefreshJwtToken() => sign({"jti": uuAidi.generateV4()}, Duration(days: 15));
}
