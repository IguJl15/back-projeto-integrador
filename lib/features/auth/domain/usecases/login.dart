import '../../../../core/utils/hasher.dart';
import '../errors/errors.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import 'create_and_save_tokens.dart';

class Login {
  final CreateAndSaveTokens createTokens;
  final AuthRepository authRepository;

  final Hasher hasher;

  Login({
    required this.createTokens,
    required this.authRepository,
    required this.hasher,
  });

  Future<AuthTokens> call(String email, String password) async {
    User? user = await authRepository.getUserByEmail(email);

    if (user == null) {
      throw UserNotFound('User not found');
    }

    final String passwordHash = hasher.hashPassword(password, user.salt);
    if (user.hash != passwordHash) {
      throw UserNotFound('User not found');
    }

    return await createTokens(user);
  }
}
