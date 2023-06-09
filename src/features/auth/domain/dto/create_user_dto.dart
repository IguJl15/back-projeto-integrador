class CreateUserDto {
  final String fullName;
  final String email;
  final String? phone;
  final String passwordHash;

  CreateUserDto(this.fullName, this.email, this.phone, this.passwordHash);
}
