import '../../../../core/env/env.dart';
import '../../../../core/utils/tolkien.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class CreateAndSaveTokens {
  final AuthRepository authRepository;

  final Tolkien tolkien;

  CreateAndSaveTokens({
    required this.authRepository,
    required this.tolkien,
  });

  Future<AuthTokens> call(User user) async {
    final accessToken = tolkien.sign(user.toJwtMap(), Duration(seconds: Env.accessTokenExpiration));
    final refreshToken = tolkien.sign({"sub": user.id}, Duration(seconds: Env.refreshTokenExpiration));

    await authRepository.saveRefreshToken(refreshToken.jti, user.id);

    return AuthTokens(accessToken.token, refreshToken.token);
  }
}
