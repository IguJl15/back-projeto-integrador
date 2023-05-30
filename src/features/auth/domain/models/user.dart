import '../../../../core/models/base_model.dart';

class User extends BaseModel {
  final String fullName;
  final String email;
  final String? phone;
  final String completeHash;

  String get salt => completeHash.split('.').first;
  String get hash => completeHash.split('.').last;

  User(
    super.id,
    this.fullName,
    this.email,
    this.phone,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
    this.completeHash,
  );

  toJwtMap() {
    return {
      "sub": id,
      "email": email,
      "name": fullName,
      "phone_number": phone,
    };
  }
}
