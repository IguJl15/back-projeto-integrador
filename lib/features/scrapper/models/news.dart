class News {
  final String id;
  final String title;
  final String url;
  final String? imageUrl;
  final String? content;
  final DateTime? publishedAt;

  News({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.content,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'url': url,
        'imageUrl': imageUrl,
        'content': content,
        'publishedAt': publishedAt?.toIso8601String(),
      };
}
