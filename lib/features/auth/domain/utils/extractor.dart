import 'package:shelf/shelf.dart';

import '../../../../core/utils/tolkien.dart';
import '../models/user.dart';

base class RequestExtractor {
  final Tolkien tolkien;

  RequestExtractor(this.tolkien);

  User getUser(Request request) {
    final token = request.headers['authorization']!.split(" ").last;
    return User.fromJwtMap(tolkien.getPayload(token));
  }
}
