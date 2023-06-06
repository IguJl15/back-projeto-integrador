import '../errors/errors.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/hasher.dart';
import '../../../../core/utils/tolkien.dart';

class Login {
  final AuthRepository authRepository;
  final Tolkien tolkien;
  final Hasher hasher;

  Login({
    required this.authRepository,
    required this.tolkien,
    required this.hasher,
  });

  AuthTokens call(String email, String password) {
    User? user = authRepository.getUserByEmail(email);

    if (user == null) {
      throw UserNotFound('User not found');
    }

    final String passwordHash = hasher.hashPassword(password, user.salt);
    if (user.hash != passwordHash) {
      throw UserNotFound('User not found');
    }

    final accessToken = tolkien.sign(user.toJwtMap(), Duration(minutes: 30));
    final refreshToken = tolkien.newRefreshJwtToken();

    return AuthTokens(accessToken, refreshToken);
  }
}
