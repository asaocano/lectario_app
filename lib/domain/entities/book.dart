import 'package:lectario_app/domain/entities/book_preview.dart';

class Book {
  final BookPreview preview;
  final String? description;
  final List<String> subjects;

  Book({required this.preview, this.description, this.subjects = const []});

  Book copyWith({
    BookPreview? preview,
    String? description,
    List<String>? subjects,
  }) {
    return Book(
      preview: preview ?? this.preview,
      description: description ?? this.description,
      subjects: subjects ?? this.subjects,
    );
  }
}
