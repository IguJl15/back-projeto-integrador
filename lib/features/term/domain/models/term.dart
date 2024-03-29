final class Term {
  final String id;
  final String description;
  final bool isForbidden;

  Term(
    this.id,
    this.description,
    this.isForbidden,
  );

  factory Term.newfound(String description) => Term(
        '',
        description,
        false,
      );

  factory Term.fromClearMap(Map<String, dynamic> map) {
    return Term(
      map['id'] ?? '',
      map['description'] ?? '',
      bool.tryParse((map['isForbidden'] ?? '').toString()) ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'isForbidden': isForbidden,
      };

  @override
  bool operator ==(covariant Term other) {
    if (identical(this, other)) return true;

    return other.id == id && other.description == description && other.isForbidden == isForbidden;
  }

  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ isForbidden.hashCode;
}
