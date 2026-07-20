import 'package:lectario_app/data/datasources/authors/authors_datasource_impl.dart';
import 'package:lectario_app/domain/entities/author.dart';
import 'package:lectario_app/domain/repositories/authors/authors_repository.dart';

class AuthorsRepositoryImpl implements AuthorsRepository {
  final AuthorsDatasourceImpl datasource;

  AuthorsRepositoryImpl({required this.datasource});

  @override
  Future<Author> getAuthorById(String authorId) {
    return datasource.getAuthorById(authorId);
  }
}
