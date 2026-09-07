import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

abstract class LocalStorageRepository {
  Future<void> toogleBook(BookPreview preview, int status);
  Future<bool> isBookOnShelf(String bookId);
  Future<List<BookPreview>> loadBooks({int limit = 10, int offset = 0, int status});
}
