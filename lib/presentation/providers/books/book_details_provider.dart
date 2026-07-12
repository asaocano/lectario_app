import 'package:lectario_app/core/exceptions/app_exception.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/books/books_repository.dart';
import 'package:lectario_app/presentation/providers/books/books_repository_provider.dart';
import 'package:lectario_app/utils/utils.dart';
import 'package:riverpod/legacy.dart';

/// Provider encargado de exponer el estado de los detalles de un libro.
///
/// Crea una instancia de [BookDetailsNotifier] utilizando el
/// [BooksRepository] inyectado mediante Riverpod.
final bookDetailsProvider =
    StateNotifierProvider<BookDetailsNotifier, BookDetailsState>((ref) {
      final booksRepository = ref.watch(booksRepositoryProvider);
      return BookDetailsNotifier(repository: booksRepository);
    });

/// Controla el estado asociado a la pantalla de detalles de un libro.
///
/// Se encarga de solicitar la información completa al repositorio y
/// actualizar el estado de carga, éxito o error para que la interfaz
/// pueda reaccionar a cada cambio.
class BookDetailsNotifier extends StateNotifier<BookDetailsState> {
  /// Repositorio utilizado para obtener la información del libro.
  final BooksRepository repository;

  /// Crea un nuevo notifier para administrar el estado de los detalles
  /// de un libro.
  BookDetailsNotifier({required this.repository}) : super(BookDetailsState());

  /// Obtiene la información completa de un libro.
  ///
  /// Recibe un [BookPreview] con la información básica del libro y utiliza
  /// el repositorio para recuperar el resto de sus datos.
  ///
  /// Durante la petición:
  /// * Activa el indicador de carga.
  /// * Actualiza el estado con el libro obtenido cuando la petición finaliza.
  /// * En caso de error, almacena un mensaje listo para mostrarse en la UI.
  Future<void> loadDetails({required BookPreview preview}) async {
    try {
      state = state.copyWith(isLoading: true, error: "");

      final book = await repository.getBookDetails(preview);

      state = state.copyWith(isLoading: false, book: book);
    } on AppException catch (ex) {
      state = state.copyWith(
        isLoading: false,
        error: Utils.transformErrorMsg(ex),
      );
    }
  }
}

/// Representa el estado de la pantalla de detalles de un libro.
///
/// Contiene:
/// * [book]: la información completa del libro.
/// * [isLoading]: indica si la información se está cargando.
/// * [error]: mensaje de error listo para mostrarse en la interfaz.
class BookDetailsState {
  /// Información completa del libro.
  final Book? book;

  /// Indica si la petición continúa en progreso.
  final bool isLoading;

  /// Mensaje de error mostrado en la interfaz cuando ocurre una excepción.
  final String error;

  /// Crea un nuevo estado.
  ///
  /// Por defecto, la pantalla inicia en estado de carga hasta que se
  /// obtiene la información del libro.
  const BookDetailsState({
    this.book,
    this.isLoading = true,
    this.error = "",
  });

  /// Devuelve una nueva instancia del estado reemplazando únicamente
  /// las propiedades indicadas.
  BookDetailsState copyWith({
    Book? book,
    bool? isLoading,
    String? error,
  }) {
    return BookDetailsState(
      book: book ?? this.book,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}