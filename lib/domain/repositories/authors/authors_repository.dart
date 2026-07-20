import 'package:lectario_app/domain/entities/author.dart';

abstract class AuthorsRepository {
  Future<Author> getAuthorById(String authorId);
}