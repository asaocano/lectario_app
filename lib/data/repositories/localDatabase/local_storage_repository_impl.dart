import 'package:lectario_app/data/datasources/localDatabase/local_storage_datasource_impl.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/localDatabase/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final LocalStorageDatasourceImpl datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<bool> isBookOnShelf(String bookId) {
    return datasource.isBookOnShelf(bookId);
  }

  @override
  Future<void> toogleBook(BookPreview preview, int status) {
    return datasource.toogleBook(preview, status);
  }

  @override
  Future<List<BookPreview>> loadBooks({int limit = 10, int offset = 0, int status = 1}) {
    return datasource.loadBooks(limit: limit, offset: offset, status: status);
  }
}
