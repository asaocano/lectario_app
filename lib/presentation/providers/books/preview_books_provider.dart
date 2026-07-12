import 'package:lectario_app/config/constants/book_categories.dart';
import 'package:lectario_app/core/exceptions/app_exception.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/repositories/books/books_repository.dart';
import 'package:lectario_app/presentation/providers/books/books_repository_provider.dart';
import 'package:lectario_app/utils/utils.dart';
import 'package:riverpod/legacy.dart';

/// Provider encargado de administrar el catálogo principal de libros.
///
/// Inicializa una instancia de [PreviewBooksNotifier] y carga
/// automáticamente las categorías configuradas en [BookCategories]
/// cuando el provider es creado.
final previewBooksProvider =
    StateNotifierProvider<PreviewBooksNotifier, PreviewBooksState>((ref) {
      final previewBooksRepository = ref.watch(booksRepositoryProvider);

      return PreviewBooksNotifier(repository: previewBooksRepository)
        ..loadInitialCatalogs();
    });

/// Gestiona el estado del catálogo de libros mostrado en la aplicación.
///
/// Cada categoría se almacena en una sección independiente, permitiendo
/// controlar su paginación, estado de carga y lista de libros de forma
/// individual.
class PreviewBooksNotifier extends StateNotifier<PreviewBooksState> {
  /// Repositorio utilizado para obtener los libros.
  final BooksRepository repository;

  /// Crea un nuevo notifier inicializando una sección vacía para cada
  /// categoría definida en [BookCategories].
  PreviewBooksNotifier({required this.repository})
    : super(
        PreviewBooksState(
          sections: BookCategories.values
              .map((category) => BookSection(category: category))
              .toList(),
        ),
      );

  /// Obtiene una nueva página de libros para la categoría indicada.
  ///
  /// El proceso:
  /// * Marca la sección como cargando.
  /// * Calcula el offset correspondiente a la página actual.
  /// * Solicita los libros al repositorio.
  /// * Agrega los resultados a la lista existente.
  /// * Incrementa el contador de página.
  ///
  /// Si ocurre un error, se almacena un mensaje listo para mostrarse
  /// en la interfaz y la sección vuelve a estado no cargando.
  Future<void> loadCategory({required BookCategory category}) async {
    try {
      BookSection section = state.sections.firstWhere(
        (section) => section.category == category,
      );

      state = state.copyWith(
        sections: state.sections
            .map(
              (section) => section.category.id == category.id
                  ? section.copyWith(isLoading: true)
                  : section,
            )
            .toList(),
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
                isLoading: false,
              )
            : section,
      );

      state = state.copyWith(sections: updateSections.toList());
    } on AppException catch (ex) {
      state = state.copyWith(
        error: Utils.transformErrorMsg(ex),
        sections: state.sections
            .map(
              (section) => section.category.id == category.id
                  ? section.copyWith(isLoading: false)
                  : section,
            )
            .toList(),
      );
    }
  }

  /// Carga simultáneamente las categorías iniciales del catálogo.
  ///
  /// Utiliza [Future.wait] para ejecutar todas las solicitudes en paralelo,
  /// reduciendo el tiempo de carga inicial de la pantalla principal.
  Future<void> loadInitialCatalogs() async {
    await Future.wait(
      BookCategories.values.map((category) => loadCategory(category: category)),
    );
  }
}

/// Representa una sección del catálogo de libros.
///
/// Cada sección mantiene la información asociada a una categoría:
/// * Categoría mostrada.
/// * Libros cargados.
/// * Estado de carga.
/// * Página actual utilizada para la paginación.
class BookSection {
  /// Categoría a la que pertenece la sección.
  final BookCategory category;

  /// Libros actualmente cargados para la categoría.
  final List<BookPreview> books;

  /// Indica si la sección se encuentra realizando una petición.
  final bool isLoading;

  /// Página actual utilizada para calcular el siguiente offset.
  final int page;

  /// Crea una nueva sección del catálogo.
  const BookSection({
    required this.category,
    this.books = const [],
    this.page = 0,
    this.isLoading = true,
  });

  /// Devuelve una nueva instancia reemplazando únicamente las propiedades
  /// indicadas.
  BookSection copyWith({List<BookPreview>? books, int? page, bool? isLoading}) {
    return BookSection(
      category: category,
      books: books ?? this.books,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Estado del catálogo principal de libros.
///
/// Contiene todas las secciones disponibles y cualquier mensaje de error
/// generado durante la carga de información.
class PreviewBooksState {
  /// Secciones mostradas en el catálogo.
  final List<BookSection> sections;

  /// Mensaje de error listo para mostrarse en la interfaz.
  final String error;

  /// Crea un nuevo estado del catálogo.
  const PreviewBooksState({required this.sections, this.error = ""});

  /// Devuelve una nueva instancia reemplazando únicamente las propiedades
  /// indicadas.
  PreviewBooksState copyWith({List<BookSection>? sections, String? error}) {
    return PreviewBooksState(
      sections: sections ?? this.sections,
      error: error ?? this.error,
    );
  }
}