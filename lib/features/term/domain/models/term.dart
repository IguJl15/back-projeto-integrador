import '../../../../core/models/base_model.dart';

final class Term extends BaseModel {
  String description;

  Term(
    super.id,
    this.description,
    super.createdAt,
    super.updatedAt,
    super.deletedAt,
  );

  factory Term.newfound(String id, String description) => Term(
        id,
        description,
        DateTime.now(),
        null,
        null,
      );
}
