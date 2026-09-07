import 'package:lectario_app/data/models/OpenLibrary/books/open_library_response.dart';
import 'package:lectario_app/data/models/OpenLibrary/books/search_open_library_response.dart';
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

  static BookPreview castResponseToEntity(Doc openLibraryBook) => BookPreview(
    id: openLibraryBook.key.replaceAll('/works/', ''),
    title: openLibraryBook.title,
    author: openLibraryBook.authorName.isNotEmpty
        ? openLibraryBook.authorName.first
        : 'Autor Desconocido',
    authorId: openLibraryBook.authorKey.isNotEmpty
        ? openLibraryBook.authorKey.first
        : '',
    editions: openLibraryBook.editionCount,
    coverUrl: openLibraryBook.coverI != 0
        ? 'https://covers.openlibrary.org/b/id/${openLibraryBook.coverI}-M.jpg'
        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
    publishYear: openLibraryBook.firstPublishYear,
  );
}
