import 'package:collection/collection.dart';

import '../../../../core/models/base_model.dart';
import '../../../term/domain/models/term.dart';

final class Direction extends BaseModel {
  String title;
  String redirectEmail;

  List<Term> inclusionTerms;
  List<Term> exclusionTerms;

  DirectionStatus status;
  String userId;

  Direction({
    required String id,
    required this.title,
    required this.redirectEmail,
    required this.inclusionTerms,
    required this.exclusionTerms,
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
        'inclusionTerms': inclusionTerms.map((e) => e.toMap()).toList(),
        'exclusionTerms': exclusionTerms.map((e) => e.toMap()).toList(),
        'status': status.toString(),
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(covariant Direction other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.title == title &&
        other.redirectEmail == redirectEmail &&
        other.status == status &&
        listEquals(other.inclusionTerms, inclusionTerms) &&
        listEquals(other.exclusionTerms, exclusionTerms) &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        redirectEmail.hashCode ^
        inclusionTerms.hashCode ^
        exclusionTerms.hashCode ^
        userId.hashCode;
  }
}

enum DirectionStatus {
  inProgress('in progress'),
  suspended('suspended'),
  canceled('canceled');

  const DirectionStatus(this.verbose);

  final String verbose;

  @override
  String toString() => verbose;

  static DirectionStatus? tryParse(String value) {
    try {
      return DirectionStatus.parse(value);
    } on FormatException catch (_) {
      return null;
    }
  }

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
