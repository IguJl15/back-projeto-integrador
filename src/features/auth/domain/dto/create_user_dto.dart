import '../models/user.dart';

class CreateUserDto {
  final String fullName;
  final String email;
  final String? phone;
  final String passwordHash;

  CreateUserDto(this.fullName, this.email, this.phone, this.passwordHash);

  toUser() {
    return User(
      '',
      fullName,
      email,
      phone,
      DateTime.now(),
      null,
      null,
      passwordHash,
    );
  }
}
