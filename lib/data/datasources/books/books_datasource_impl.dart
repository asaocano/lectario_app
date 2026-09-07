import 'package:lectario_app/core/network/api_client.dart';
import 'package:lectario_app/data/mappers/book_mapper.dart';
import 'package:lectario_app/data/mappers/book_preview_mapper.dart';
import 'package:lectario_app/data/models/OpenLibrary/books/search_open_library_response.dart';
import 'package:lectario_app/data/models/OpenLibrary/open_library_response.dart';
import 'package:lectario_app/data/models/OpenLibrary/work_open_library_response.dart';
import 'package:lectario_app/domain/datasources/books/books_datasource.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class BooksDatasourceImpl extends BooksDatasource {
  final ApiClient apiClient;

  BooksDatasourceImpl({required this.apiClient});

  List<BookPreview> _jsonToBooks(
    Map<String, dynamic> json,
    BookCategory category,
  ) {
    final openLibraryResponse = OpenLibraryResponse.fromJson(json);

    final List<BookPreview> books = openLibraryResponse.works
        // .where((openLibraryBook) => category.matches(openLibraryBook.subject))
        .map((book) => BookPreviewMapper.castToEntity(book))
        .toList();

    return books;
  }

  /// Convierte la respuesta del endpoint de búsqueda (search.json) a entidades BookPreview
  List<BookPreview> _searchResponseToBooks(Map<String, dynamic> json) {
    final searchResponse = SearchOpenLibraryResponse.fromJson(json);

    final List<BookPreview> books = searchResponse.docs
        .map((book) => BookPreviewMapper.castDocToEntity(book))
        .toList();

    return books;
  }

  @override
  Future<List<BookPreview>> getBooksByCategory(
    BookCategory category,
    int limit,
    int offset,
  ) async {
    final response = await apiClient.get(
      'subjects/${category.apiValue}.json',
      queryParams: {'limit': limit, 'offset': offset},
    );

    final books = _jsonToBooks(response.data, category);
    return books;
  }

  @override
  Future<Book> getBookDetails(BookPreview preview) async {
    final response = await apiClient.get('works/${preview.id}.json');
    final work = WorkOpenLibraryResponse.fromJson(response.data);

    final book = BookMapper.toEntity(work: work, preview: preview);
    return book;
  }

  @override
  Future<List<BookPreview>> getBooksByQuery(String query) async {
    // Si la búsqueda viene vacía, evitamos hacer una petición innecesaria a la red
    if (query.trim().isEmpty) return [];

    try {
      final response = await apiClient.get(
        'search.json',
        queryParams: {
          'title': query,
          'language': 'spa',
          'fields': 'key,title,author_name,author_key,cover_i,first_publish_year, edition_count'
        },
      );

      final books = _searchResponseToBooks(response.data);
      return books;
    } catch (e) {
      // Manejo de errores resiliente
      return [];
    }
  }
}
