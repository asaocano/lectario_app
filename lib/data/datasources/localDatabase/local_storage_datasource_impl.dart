import 'package:drift/drift.dart';
import 'package:lectario_app/config/database/database.dart';
import 'package:lectario_app/domain/datasources/localDatabase/local_storage_datasource.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class LocalStorageDatasourceImpl implements LocalStorageDatasource {
  final AppDatabase database;

  LocalStorageDatasourceImpl([AppDatabase? databaseToUse])
    : database = databaseToUse ?? db;
  @override
  Future<bool> isBookOnShelf(String bookId) async {
    final query = database.select(database.bookshelf)
      ..where((table) => table.id.equals(bookId));

    final isInShelf = await query.getSingleOrNull();

    return isInShelf != null;
  }

  @override
  Future<void> toogleBook(BookPreview preview, int status) async {
    final isInShelf = await isBookOnShelf(preview.authorId);

    if (isInShelf) {
      database.update(database.bookshelf)
        ..where((table) => table.id.equals(preview.authorId))
        ..write(BookshelfCompanion(status: Value(status)));

      return;
    }

    await database
        .into(database.bookshelf)
        .insert(
          BookshelfCompanion.insert(
            id: preview.authorId,
            title: preview.title,
            author: preview.author,
            authorId: preview.authorId,
            editions: preview.editions,
            coverUrl: Value(preview.coverUrl),
            publishYear: Value(preview.publishYear),
            status: status,
          ),
        );
  }

  @override
  Future<List<BookPreview>> loadBooks({
    int limit = 10,
    int offset = 0,
    int status = 1,
  }) async {
    final query = database.select(database.bookshelf)
      ..limit(limit, offset: offset)
      ..where((row) => row.status.equals(status));

    final bookRows = await query.get();

    final books = bookRows.map(
      (row) => BookPreview(
        id: row.id,
        title: row.title,
        author: row.author,
        authorId: row.authorId,
        coverUrl: row.coverUrl,
        publishYear: row.publishYear,
        editions: row.editions,
      ),
    );

    return books.toList();
  }
}
