import 'package:lectario_app/data/datasources/books/books_datasource_impl.dart';
import 'package:lectario_app/data/repositories/books/preview_books_repository_impl.dart';
import 'package:lectario_app/presentation/providers/network/api_client_provider.dart';
import 'package:riverpod/riverpod.dart';

/// Provider que expone la implementación del repositorio de libros.
///
/// Se encarga de construir la cadena de dependencias necesaria para
/// acceder a los datos:
///
/// * Obtiene una instancia de [ApiClient].
/// * La inyecta en [BooksDatasourceImpl].
/// * Crea y expone una instancia de [BooksRepositoryImpl].
///
/// De esta forma, el resto de la aplicación únicamente depende del
/// repositorio y no necesita conocer cómo se construyen sus dependencias.
final booksRepositoryProvider = Provider((ref) {
  return BooksRepositoryImpl(
    datasource: BooksDatasourceImpl(
      apiClient: ref.watch(apiClientProvider),
    ),
  );
});