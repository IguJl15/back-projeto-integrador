import '../dto/create_user_dto.dart';
import '../dto/register_user_dto.dart';
import '../errors/errors.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../utils/hasher.dart';
import '../utils/tolkien.dart';

class RegisterUseCase {
  final Hasher hasher;
  final AuthRepository authRepository;
  final Tolkien tolkien;

  RegisterUseCase({
    required this.authRepository,
    required this.hasher,
    required this.tolkien,
  });

  call(RegisterUserDto registerUserDto) {
    registerUserDto.validate();
    //gerar hash da senha
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
    final User newUser = authRepository.saveUser(createUserDto);
    //gerar e retornar tokens JWT
    return tolkien.sign(newUser.toJwtMap());
  }
}
