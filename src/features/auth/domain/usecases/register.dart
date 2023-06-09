import '../dto/create_user_dto.dart';
import '../dto/register_user_dto.dart';
import '../errors/errors.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/hasher.dart';
import '../../../../core/utils/tolkien.dart';

class RegisterUseCase {
  final Hasher hasher;
  final AuthRepository authRepository;
  final Tolkien tolkien;

  RegisterUseCase({
    required this.authRepository,
    required this.hasher,
    required this.tolkien,
  });

  Future<AuthTokens> call(RegisterUserDto registerUserDto) async {
    registerUserDto.validate();
    //gerar hash da senha

    final existingUser = await authRepository.getUserByEmail(registerUserDto.email);
    if (existingUser != null) throw EmailAlreadyInUse();

    final salt = hasher.generateSalt();
    String hashPassword = hasher.hashPassword(registerUserDto.password, salt);
    //criar um novo CreateUserDto
    final createUserDto = CreateUserDto(
      registerUserDto.fullName,
      registerUserDto.email,
      registerUserDto.phone,
      '$salt.$hashPassword',
    );
    //salvar o dto no bd
    final User newUser = await authRepository.saveUser(createUserDto);
    //gerar e retornar tokens JWT
    final accessToken = tolkien.sign(newUser.toJwtMap(), Duration(minutes: 30));
    final refreshToken = tolkien.newRefreshJwtToken();

    return AuthTokens(accessToken, refreshToken);
  }
}
