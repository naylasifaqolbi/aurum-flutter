class NewsModel {
  final String title;
  final String description;
  final String url;
  final String source;
  final DateTime? publishedAt;

  const NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    this.publishedAt,
  });
}
