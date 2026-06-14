class BookPreview {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final int? publishYear;

  BookPreview({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.publishYear,
  });
}
