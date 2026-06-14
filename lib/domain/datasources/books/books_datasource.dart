import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

abstract class BooksDatasource {
  Future<List<BookPreview>> getBooksByCategory(BookCategory category, int limit, int offset);
}
