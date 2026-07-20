import 'package:lectario_app/core/network/api_client.dart';
import 'package:lectario_app/data/mappers/author_mapper.dart';
import 'package:lectario_app/data/models/OpenLibrary/authors/author_open_library_response.dart';
import 'package:lectario_app/domain/datasources/authors/authors_datasource.dart';
import 'package:lectario_app/domain/entities/author.dart';

class AuthorsDatasourceImpl implements AuthorsDatasource {
  final ApiClient apiClient;

  AuthorsDatasourceImpl({required this.apiClient});

  @override
  Future<Author> getAuthorById(String authorId) async {
    final response = await apiClient.get('authors/$authorId.json');

    final AuthorOpenLibraryResponse openLibraryResponse =
        AuthorOpenLibraryResponse.fromJson(response.data);
        
    return AuthorMapper.toEntity(authorOpenLibrary: openLibraryResponse);
  }
}
