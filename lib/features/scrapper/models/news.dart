import '../../term/domain/models/term.dart';

class News {
  final String id;
  final String title;
  final String url;
  final String? imageUrl;
  final String? content;
  final List<Term> terms;
  final DateTime? publishedAt;

  News({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.content,
    required this.terms,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'url': url,
        'imageUrl': imageUrl,
        'content': content,
        'terms': terms.map((e) => e.toMap()).toList(),
        'publishedAt': publishedAt?.toIso8601String(),
      };

  News copyWith({
    String? id,
    String? title,
    String? url,
    String? imageUrl,
    String? content,
    List<Term>? terms,
    DateTime? publishedAt,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      terms: terms ?? this.terms,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
