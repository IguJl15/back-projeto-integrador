import '../../../auth/domain/dto/register_user_dto.dart';
import '../../../term/domain/models/term.dart';
import '../errors/direction_errors.dart';

final class CreateDirectionDto {
  final String userId;
  final String title;
  final String redirectEmail;
  final List<Term> inclusionTerms;
  final List<Term> exclusionTerms;

  CreateDirectionDto(
    this.userId,
    this.title,
    this.redirectEmail,
    this.inclusionTerms,
    this.exclusionTerms,
  );

  static final uuidREgex = RegExp(r'/^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i');

  void validate() {
    if (userId.isEmpty || uuidREgex.hasMatch(userId)) throw DirectionValidationError("User ID", "UUID inválido");

    if (title.length < 4) throw DirectionValidationError("Título", "O Título deve conter pelo menos 4 caracteres");
    if (title.length > 70) throw DirectionValidationError("Título", "O Título deve conter no máximo 70 caracteres");

    if (RegisterUserDto.emailRegex.hasMatch(redirectEmail)) {
      throw DirectionValidationError("Email para redirecionamento", "Email inválido");
    }

    if (inclusionTerms.isEmpty) throw DirectionValidationError('Termos', 'A lista de termos não pode estar vazia');
    if (inclusionTerms.length > 70 || exclusionTerms.length > 70) {
      throw DirectionValidationError(
        'Termos',
        'A lista de termos não conter no máximo 70 termos',
      );
    }
  }
}
