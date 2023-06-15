import '../../../../core/models/base_model.dart';
import '../../../term/domain/models/term.dart';

final class Direction extends BaseModel {
  String title;
  String redirectEmail;

  List<Term> terms;

  Direction({
    required String id,
    required this.title,
    required this.redirectEmail,
    required this.terms,
    required DateTime createAt,
    required DateTime? updatedAt,
    required DateTime? deletedAt,
  }) : super(id, createAt, updatedAt, deletedAt);
}
