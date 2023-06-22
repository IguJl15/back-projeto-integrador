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
      bool.tryParse(map['isForbidden'] ?? '') ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'isForbidden': isForbidden,
      };
}
