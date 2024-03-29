import '../../../../core/utils/tolkien.dart';
import '../errors/errors.dart';
import '../models/auth_tokens.dart';
import '../repositories/auth_repository.dart';
import 'create_and_save_tokens.dart';

class RefreshTokenUseCase {
  final CreateAndSaveTokens createTokens;
  final AuthRepository authRepository;

  final Tolkien tolkien;

  RefreshTokenUseCase({
    required this.createTokens,
    required this.authRepository,
    required this.tolkien,
  });

  Future<AuthTokens> call(String token) async {
    try {
      tolkien.verify(token);
    } on JwtError catch (e) {
      if (e is JwtExpiredError) {
        final jwtId = tolkien.getPayload(token);
        authRepository.deleteToken(jwtId['jti']);
      }
      rethrow;
    }

    final payload = tolkien.getPayload(token);
    authRepository.deleteToken(payload["jti"]);

    if (payload["sub"] == null) {
      throw JwtError("invalid sub");
    }

    final user = await authRepository.getUserOrNull(payload["sub"]);

    if (user == null) {
      throw UserNotFound(null);
    }

    return await createTokens(user);
  }
}
