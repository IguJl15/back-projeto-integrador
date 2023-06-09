import '../../domain/models/user.dart';

class UserDataModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String completeHash;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserDataModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.completeHash,
  });

  User toEntity() {
    return User(
      id,
      fullName,
      email,
      phone,
      createdAt,
      updatedAt,
      deletedAt,
      completeHash,
    );
  }
}
