import '../errors/errors.dart';

class RegisterUserDto {
  final String fullName;
  final String email;
  final String? phone;
  final String password;
  final String confirmedPassword;

  final fullNameRegex = RegExp(r"^[a-zA-Z\u00C0-\u00FF\s']+$");
  final emailRegex = RegExp(
      r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""");
  final phoneRegex =
      RegExp(r"^([+]?[\s0-9]+)?(\d{3}|[(]?[0-9]+[)])?([-]?[\s]?[0-9])+$");
  final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

  RegisterUserDto(this.fullName, this.email, this.phone, this.password,
      this.confirmedPassword);

  validate() {
    if (!fullNameRegex.hasMatch(fullName)) {
      throw AuthValidationError(
          'Full name', 'The should not contains special characters');
    } else if (!emailRegex.hasMatch(email)) {
      throw AuthValidationError('Email', 'The email is invalid');
    } else if (phone != null && !phoneRegex.hasMatch(phone!)) {
      throw AuthValidationError('Phone', 'The phone is invalid');
    } else if (password != confirmedPassword) {
      throw AuthValidationError(
          'Password', "The password and confirmed password don't match");
    } else if (!passwordRegex.hasMatch(password)) {
      throw AuthValidationError('Password', 'The password is weak like you');
    }
  }
}
