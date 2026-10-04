import 'package:lectario_app/core/network/api_client.dart';
import 'package:lectario_app/data/mappers/author_mapper.dart';
import 'package:lectario_app/data/models/OpenLibrary/authors/author_books_open_library_response.dart';
import 'package:lectario_app/data/models/OpenLibrary/authors/author_open_library_response.dart';
import 'package:lectario_app/domain/datasources/authors/authors_datasource.dart';
import 'package:lectario_app/domain/entities/author.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class AuthorsDatasourceImpl implements AuthorsDatasource {
  final ApiClient apiClient;

  AuthorsDatasourceImpl({required this.apiClient});

  List<BookPreview> _jsonToBooks(Map<String, dynamic> json) {
    final openLibraryResponse = AuthorBooksOpenLibraryResponse.fromJson(json);

    final List<BookPreview> books = openLibraryResponse.docs
        .map((book) => AuthorMapper.toBookPreview(book))
        .toList();

    return books;
  }

  @override
  Future<Author> getAuthorById(String authorId) async {
    final response = await apiClient.get('authors/$authorId.json');

    final AuthorOpenLibraryResponse openLibraryResponse =
        AuthorOpenLibraryResponse.fromJson(response.data);

    return AuthorMapper.toEntity(authorOpenLibrary: openLibraryResponse);
  }

  @override
  Future<List<BookPreview>> getBooksByAuthor(String authorId) async{
    final response = await apiClient.get(
      "search.json",
      queryParams: {
        'author_key': authorId,
        'limit': 20,
        'fields':
            'key,title,author_name,author_key,cover_i,first_publish_year,edition_count',
      },
    );
    
    final books = _jsonToBooks(response.data);
    return books;
  }
}
