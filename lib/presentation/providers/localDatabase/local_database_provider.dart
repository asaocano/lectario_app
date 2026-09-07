// final localDatabaseProvider =

import 'package:lectario_app/data/repositories/localDatabase/local_storage_repository_impl.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/enums/bookshelf_status.dart';
import 'package:lectario_app/presentation/providers/localDatabase/local_storage_provider.dart';
import 'package:riverpod/legacy.dart';

final bookshelfProvider = StateNotifierProvider((ref) {
  final localStorageProvider = ref.watch(localStorageRepositoryProvider);

  return StorageBooksNotifier(localStorageRepository: localStorageProvider)
    ..loadInitialCatalogs();
});

// Cambiamos el tipo de estado al nuevo BookshelfState
class StorageBooksNotifier extends StateNotifier<BookshelfState> {
  final LocalStorageRepositoryImpl localStorageRepository;
  final int _limit = 20; // Tamaño de la página

  StorageBooksNotifier({required this.localStorageRepository})
    : super(BookshelfState());

  Future<void> loadInitialCatalogs() async {
    loadNextPage(1);
    loadNextPage(2);
    loadNextPage(3);
  }

  /// Carga la siguiente página de una categoría específica (1: WantToRead, 2: Favorites, 3: Read)
  Future<void> loadNextPage(int status) async {
    // 1. Verificar si ya llegamos al final de esa lista para no hacer peticiones en vano
    if (status == 1 && state.wantToReadLastPage) return;
    if (status == 2 && state.favoritesLastPage) return;
    if (status == 3 && state.readLastPage) return;

    // 2. Determinar la página actual basándonos en el status
    int currentPage = 0;
    if (status == 1) currentPage = state.wantToReadPage;
    if (status == 2) currentPage = state.favoritesPage;
    if (status == 3) currentPage = state.readPage;

    // 3. Consultar a la base de datos local con el offset correcto
    final newBooks = await localStorageRepository.loadBooks(
      status: status,
      limit: _limit,
      offset: currentPage * _limit,
    );

    // Si vinieron menos libros que el límite, significa que es la última página
    final isLastPage = newBooks.length < _limit;

    // 4. Actualizar el estado de manera atómica según la categoría
    if (status == 1) {
      state = state.copyWith(
        wantToRead: [...state.wantToRead, ...newBooks],
        wantToReadPage: currentPage + 1,
        wantToReadLastPage: isLastPage,
      );
    } else if (status == 2) {
      state = state.copyWith(
        favorites: [...state.favorites, ...newBooks],
        favoritesPage: currentPage + 1,
        favoritesLastPage: isLastPage,
      );
    } else if (status == 3) {
      state = state.copyWith(
        read: [...state.read, ...newBooks],
        readPage: currentPage + 1,
        readLastPage: isLastPage,
      );
    }
  }

  /// Método modificado por si mueven un libro de categoría
  Future<void> toogleBook(BookPreview preview, int status) async {
    // 1. Impactamos el cambio en la persistencia local (Drift)
    await localStorageRepository.toogleBook(preview, status);

    // 2. Clonamos las listas actuales para manipularlas de forma inmutable
    List<BookPreview> want = [...state.wantToRead];
    List<BookPreview> favs = [...state.favorites];
    List<BookPreview> readBooks = [...state.read];

    // 3. Lo eliminamos preventivamente de todas las listas
    // (por si estaba mudándose de una categoría a otra o si se desmarcó)
    want.removeWhere((b) => b.id == preview.id);
    favs.removeWhere((b) => b.id == preview.id);
    readBooks.removeWhere((b) => b.id == preview.id);

    // 4. Lo insertamos directamente en la lista destino según el estado seleccionado.
    // (Nota: Si tu toogleBook también sirve para "quitar" el libro por completo de la librería,
    // aquí podrías validar el resultado antes de insertar).
    if (status == 1) want.insert(0, preview);
    if (status == 2) favs.insert(0, preview);
    if (status == 3) readBooks.insert(0, preview);

    // 5. Actualizamos el estado de manera atómica
    state = state.copyWith(wantToRead: want, favorites: favs, read: readBooks);
  }
}

class BookshelfState {
  // Datos de las categorías
  final List<BookPreview> wantToRead;
  final List<BookPreview> favorites;
  final List<BookPreview> read;

  // Paginación individual (Página actual de cada una)
  final int wantToReadPage;
  final int favoritesPage;
  final int readPage;

  // Control de fin de scroll individual
  final bool wantToReadLastPage;
  final bool favoritesLastPage;
  final bool readLastPage;

  final bool isLoading;

  BookshelfState({
    this.wantToRead = const [],
    this.favorites = const [],
    this.read = const [],
    this.wantToReadPage = 0,
    this.favoritesPage = 0,
    this.readPage = 0,
    this.wantToReadLastPage = false,
    this.favoritesLastPage = false,
    this.readLastPage = false,
    this.isLoading = false,
  });

  BookshelfState copyWith({
    List<BookPreview>? wantToRead,
    List<BookPreview>? favorites,
    List<BookPreview>? read,
    int? wantToReadPage,
    int? favoritesPage,
    int? readPage,
    bool? wantToReadLastPage,
    bool? favoritesLastPage,
    bool? readLastPage,
    bool? isLoading,
  }) {
    return BookshelfState(
      wantToRead: wantToRead ?? this.wantToRead,
      favorites: favorites ?? this.favorites,
      read: read ?? this.read,
      wantToReadPage: wantToReadPage ?? this.wantToReadPage,
      favoritesPage: favoritesPage ?? this.favoritesPage,
      readPage: readPage ?? this.readPage,
      wantToReadLastPage: wantToReadLastPage ?? this.wantToReadLastPage,
      favoritesLastPage: favoritesLastPage ?? this.favoritesLastPage,
      readLastPage: readLastPage ?? this.readLastPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
