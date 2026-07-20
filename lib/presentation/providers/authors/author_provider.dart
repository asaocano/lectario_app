import 'package:lectario_app/core/exceptions/app_exception.dart';
import 'package:lectario_app/domain/entities/author.dart';
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
}

class AuthorState {
  final Author? author;
  final bool isLoading;
  final String error;

  AuthorState({this.author, this.isLoading = true, this.error = ""});

  AuthorState copyWith({Author? author, bool? isLoading, String? error}) {
    return AuthorState(
      author: author ?? this.author,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
