import '../errors/errors.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../utils/hasher.dart';
import '../utils/tolkien.dart';

class Login {
  final AuthRepository authRepository;
  final Tolkien tolkien;
  final Hasher hasher;

  Login({
    required this.authRepository,
    required this.tolkien,
    required this.hasher,
  });

  String call(String email, String password) {
    //procurar usuario pelo email
    User? user = authRepository.getUserByEmail(email);
    //se nao existir um usuario com esse email, retornar erro de usuario nao encontrado
    if (user == null) {
      throw UserNotFound('User not found');
    }
    //se tiver, de boa
    //fazer hash da senha enviada
    final String passwordHash = hasher.hashPassword(password, user.salt);
    //comparar o hash do usuario encontrado com o hash gerado
    //se forem diferentes: usuario nao encontrado
    if (user.hash != passwordHash) {
      throw UserNotFound('User not found');
    }
    //se nao, deu bom
    //gerar novo JWT e retornar pro front
    return tolkien.sign(user.toJwtMap());
  }
}
