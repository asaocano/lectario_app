import 'package:lectario_app/domain/entities/author.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

abstract class AuthorsDatasource {
  Future<Author> getAuthorById(String authorId);
  Future<List<BookPreview>> getBooksByAuthor(String authorId);
}