import '../dto/create_user_dto.dart';
import '../dto/register_user_dto.dart';
import '../errors/errors.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/hasher.dart';
import 'create_and_save_tokens.dart';

class RegisterUseCase {
  final CreateAndSaveTokens createTokens;
  final AuthRepository authRepository;

  final Hasher hasher;

  RegisterUseCase({
    required this.createTokens,
    required this.authRepository,
    required this.hasher,
  });

  Future<AuthTokens> call(RegisterUserDto registerUserDto) async {
    registerUserDto.validate();

    final existingUser = await authRepository.getUserByEmail(registerUserDto.email);
    if (existingUser != null) throw EmailAlreadyInUse();

    final salt = hasher.generateSalt();
    String hashPassword = hasher.hashPassword(registerUserDto.password, salt);

    final createUserDto = CreateUserDto(
      registerUserDto.fullName,
      registerUserDto.email,
      registerUserDto.phone,
      '$salt.$hashPassword',
    );

    final User newUser = await authRepository.saveUser(createUserDto);

    return await createTokens(newUser);
  }
}
