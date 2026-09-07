import 'package:lectario_app/data/models/OpenLibrary/books/search_open_library_response.dart';
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
    editions: openLibraryBook.editionCount,
    coverUrl:
        'https://covers.openlibrary.org/b/id/${openLibraryBook.coverId}-L.jpg',
    publishYear: openLibraryBook.firstPublishYear,
  );

  static BookPreview castDocToEntity(Doc doc) {
    final String coverUrl = (doc.coverI != null && doc.coverI! > 0)
        ? 'https://covers.openlibrary.org/b/id/${doc.coverI}-L.jpg'
        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png';

    final String bookId = doc.key.replaceAll('/works/', '');

    final String authorName = doc.authorName.isNotEmpty
        ? doc.authorName.first
        : 'Autor desconocido';

    final String authorId = doc.authorKey.isNotEmpty
        ? doc.authorKey.first.replaceAll('/authors/', '')
        : '';

    return BookPreview(
      id: bookId,
      title: doc.title,
      author: authorName,
      authorId: authorId,
      editions: doc.editionCount,
      coverUrl: coverUrl,
      publishYear: doc.firstPublishYear != 0 ? doc.firstPublishYear : null,
    );
  }
}
