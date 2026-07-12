class BookPreview {
  final String id;
  final String title;
  final String author;
  final String authorId;
  final String? coverUrl;
  final int? publishYear;

  BookPreview({
    required this.id,
    required this.title,
    required this.author,
    required this.authorId,
    this.coverUrl,
    this.publishYear 
  });
}
