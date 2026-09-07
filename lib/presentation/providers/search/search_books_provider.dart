import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/providers/books/books_repository_provider.dart';
import 'package:riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedBooksProvider =
    StateNotifierProvider<SearchBooksNotifier, List<BookPreview>>((ref) {
      final bookRepository = ref.read(booksRepositoryProvider);
      return SearchBooksNotifier(
        searchBooks: bookRepository.getBooksByQuery,
        ref: ref,
      );
    });

typedef SearchBooksCallback = Future<List<BookPreview>> Function(String query);

class SearchBooksNotifier extends StateNotifier<List<BookPreview>> {
  final SearchBooksCallback searchBooks;
  final Ref ref;

  SearchBooksNotifier({required this.searchBooks, required this.ref})
    : super([]);

  Future<List<BookPreview>> searchBooksByQuery(String query) async {
    final List<BookPreview> books = await searchBooks(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = books;
    return books;
  }
}
