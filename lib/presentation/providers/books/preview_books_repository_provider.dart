import 'package:lectario_app/data/datasources/books/books_datasource_impl.dart';
import 'package:lectario_app/data/repositories/books/preview_books_repository_impl.dart';
import 'package:riverpod/riverpod.dart';

final previewBooksRepositoryProvider = Provider((ref) {
  return BooksRepositoryImpl(datasource: BooksDatasourceImpl());
});
