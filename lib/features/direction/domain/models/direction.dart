import '../../../../core/models/base_model.dart';
import '../../../term/domain/models/term.dart';

final class Direction extends BaseModel {
  String title;
  String redirectEmail;

  List<Term> terms;

  DirectionStatus status;
  String userId;

  Direction({
    required String id,
    required this.title,
    required this.redirectEmail,
    required this.terms,
    required this.userId,
    required DateTime createdAt,
    this.status = DirectionStatus.inProgress,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(id, createdAt, updatedAt, deletedAt);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'redirectEmail': redirectEmail,
        'terms': terms.map((e) => e.toMap()).toList(),
        'status': status.toString(),
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

enum DirectionStatus {
  inProgress('in progress'),
  suspended('suspended'),
  canceled('canceled');

  const DirectionStatus(this.verbose);

  final String verbose;

  @override
  String toString() => verbose;

  static DirectionStatus parse(String value) {
    if (RegExp('in[_ ]?progress', caseSensitive: false).hasMatch(value)) {
      return DirectionStatus.inProgress;
    } else {
      return switch (value) {
        'suspended' => DirectionStatus.suspended,
        'canceled' => DirectionStatus.canceled,
        _ => throw FormatException(),
      };
    }
  }
}
