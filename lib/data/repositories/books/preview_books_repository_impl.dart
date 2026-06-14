import 'package:lectario_app/domain/datasources/books/books_datasource.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/books/books_repository.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksDatasource datasource;

  BooksRepositoryImpl({required this.datasource});

  @override
  Future<List<BookPreview>> getBooksByCategory(
    BookCategory category,
    int limit,
    int offset,
  ) {
    return datasource.getBooksByCategory(category, limit, offset);
  }
}
