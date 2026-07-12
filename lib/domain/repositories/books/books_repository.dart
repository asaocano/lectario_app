import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

abstract class BooksRepository {
  Future<List<BookPreview>> getBooksByCategory(BookCategory category, int limit, int offset);
  Future<Book> getBookDetails(BookPreview preview);
}
