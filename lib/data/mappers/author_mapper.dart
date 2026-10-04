import 'package:lectario_app/data/models/OpenLibrary/authors/author_books_open_library_response.dart';
import 'package:lectario_app/data/models/OpenLibrary/authors/author_open_library_response.dart';
import 'package:lectario_app/domain/entities/author.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class AuthorMapper {
  static Author toEntity({
    required AuthorOpenLibraryResponse authorOpenLibrary,
  }) {
    return Author(
      name: authorOpenLibrary.name,
      personalName: authorOpenLibrary.personalName,
      birthDate: authorOpenLibrary.birthDate,
      deathDate: authorOpenLibrary.deathDate,
      biography: authorOpenLibrary.bio,
      photoId: authorOpenLibrary.photos.first,
    );
  }

  static BookPreview toBookPreview(Doc authorBook) {
    return BookPreview(
      id: authorBook.key.replaceAll('/works/', ''),
      title: authorBook.title,
      author: authorBook.authorName.first,
      authorId: authorBook.authorKey.first,
      editions: authorBook.editionCount,
      coverUrl: (authorBook.coverI > 0)
          ? 'https://covers.openlibrary.org/b/id/${authorBook.coverI}-L.jpg'
          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
    );
  }
}
