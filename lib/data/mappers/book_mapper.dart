

import 'package:lectario_app/data/models/OpenLibrary/work_open_library_response.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class BookMapper {
  static Book toEntity({
    required WorkOpenLibraryResponse work,
    required BookPreview preview,
  }) {
    return Book(
      preview: preview,
      description: work.description,
      subjects: work.subjects,
    );
  }
}