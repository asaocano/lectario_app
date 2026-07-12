import 'package:lectario_app/data/models/OpenLibrary/open_library_response.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class BookPreviewMapper {
  static BookPreview castToEntity(Work openLibraryBook) => BookPreview(
    id: openLibraryBook.key.replaceAll('/works/', ''),
    title: openLibraryBook.title,
    author: openLibraryBook.authors.isNotEmpty
        ? openLibraryBook.authors.first.name
        : 'Autor desconocido',
    authorId: openLibraryBook.authors.isNotEmpty
        ? openLibraryBook.authors.first.key.replaceAll('/authors/', '')
        : '',
    coverUrl:
        'https://covers.openlibrary.org/b/id/${openLibraryBook.coverId}-L.jpg',
    publishYear: openLibraryBook.firstPublishYear,
  );
}
