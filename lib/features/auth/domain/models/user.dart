import '../../../../core/models/base_model.dart';

final class User extends BaseModel {
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

  Map<String, dynamic> toJwtMap() {
    return {
      "sub": id,
      "email": email,
      "name": fullName,
      "phone_number": phone,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory User.fromJwtMap(Map<String, dynamic> jwtMap) {
    return User(
      jwtMap["sub"],
      jwtMap["name"],
      jwtMap["email"],
      jwtMap["phone_number"],
      DateTime.tryParse(jwtMap["created_at"] ?? '') ?? DateTime.now(),
      null,
      null,
      '',
    );
  }
}
