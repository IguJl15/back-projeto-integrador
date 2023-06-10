import 'package:uuid/uuid.dart';

class UuAidi {
  Uuid uuid = Uuid();

  String generateV4() {
    return uuid.v4();
  }
}
