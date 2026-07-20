import 'package:lectario_app/domain/entities/author.dart';

abstract class AuthorsDatasource {
  Future<Author> getAuthorById(String authorId);
}