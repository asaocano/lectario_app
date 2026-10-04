import 'package:lectario_app/core/exceptions/app_exception.dart';
import 'package:lectario_app/domain/entities/author.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/authors/authors_repository.dart';
import 'package:lectario_app/presentation/providers/authors/authors_repository_provider.dart';
import 'package:lectario_app/utils/utils.dart';
import 'package:riverpod/legacy.dart';

final authorsProvider = StateNotifierProvider<AuthorNotifier, AuthorState>((
  ref,
) {
  final authorRepository = ref.watch(authorsRepositoryProvider);
  return AuthorNotifier(repository: authorRepository);
});

class AuthorNotifier extends StateNotifier<AuthorState> {
  final AuthorsRepository repository;

  AuthorNotifier({required this.repository}) : super(AuthorState());

  Future<void> loadAuthor(String authorId) async {
    try {
      state = state.copyWith(isLoading: true);

      final author = await repository.getAuthorById(authorId);

      state = state.copyWith(author: author, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: Utils.transformErrorMsg(e),
      );
    }
  }

  Future<void> loadAuthorBooks(String authorId) async {
    try {
      state = state.copyWith(isLoading: true);

      final books = await repository.getBooksByAuthor(authorId);

      state = state.copyWith(authorBooks: books, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: Utils.transformErrorMsg(e),
      );
    }
  }

  void resetState() {
    state = AuthorState();
  }
}

class AuthorState {
  final Author? author;
  final List<BookPreview> authorBooks;
  final bool isLoading;
  final String error;

  AuthorState({
    this.author,
    this.authorBooks = const [],
    this.isLoading = true,
    this.error = "",
  });

  AuthorState copyWith({
    Author? author,
    List<BookPreview>? authorBooks,
    bool? isLoading,
    String? error,
  }) {
    return AuthorState(
      author: author ?? this.author,
      authorBooks: authorBooks ?? this.authorBooks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
