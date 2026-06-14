import 'package:lectario_app/config/constants/book_categories.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/books/books_repository.dart';
import 'package:lectario_app/presentation/providers/books/preview_books_repository_provider.dart';
import 'package:riverpod/legacy.dart';

final previewBooksProvider =
    StateNotifierProvider<PreviewBooksNotifier, PreviewBooksState>((ref) {
      final previewBooksRepository = ref.watch(previewBooksRepositoryProvider);
      return PreviewBooksNotifier(repository: previewBooksRepository)
        ..loadInitialCatalogs();
    });

class PreviewBooksNotifier extends StateNotifier<PreviewBooksState> {
  final BooksRepository repository;

  PreviewBooksNotifier({required this.repository})
    : super(
        PreviewBooksState(
          sections: BookCategories.values
              .map((category) => BookSection(category: category))
              .toList(),
        ),
      );

  Future<void> loadCategory({required BookCategory category}) async {
    state = state.copyWith(isLoading: true);

    final section = state.sections.firstWhere(
      (section) => section.category == category,
    );
    final limit = 20;
    final page = section.page;
    final offset = limit * page;

    final newBooks = await repository.getBooksByCategory(
      category,
      limit,
      offset,
    );
    final updateSections = state.sections.map(
      (section) => section.category.id == category.id
          ? section.copyWith(
              books: [...section.books, ...newBooks],
              page: section.page + 1,
            )
          : section,
    );

    state = state.copyWith(sections: updateSections.toList(), isLoading: false);
  }

  Future<void> loadInitialCatalogs() async {
    await Future.wait(
      BookCategories.values.map((category) => loadCategory(category: category)),
    );
  }
}

class BookSection {
  final BookCategory category;
  final List<BookPreview> books;
  final int page;

  const BookSection({
    required this.category,
    this.books = const [],
    this.page = 0,
  });

  BookSection copyWith({List<BookPreview>? books, int? page}) {
    return BookSection(
      category: category,
      books: books ?? this.books,
      page: page ?? this.page,
    );
  }
}

class PreviewBooksState {
  final List<BookSection> sections;
  final bool isLoading;

  const PreviewBooksState({required this.sections, this.isLoading = false});

  PreviewBooksState copyWith({List<BookSection>? sections, bool? isLoading}) {
    return PreviewBooksState(
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
