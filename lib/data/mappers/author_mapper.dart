import 'package:lectario_app/data/models/OpenLibrary/authors/author_open_library_response.dart';
import 'package:lectario_app/domain/entities/author.dart';

class AuthorMapper {
  static Author toEntity({
    required AuthorOpenLibraryResponse authorOpenLibrary,
  }) {
    return Author(
      name: authorOpenLibrary.name,
      personalName: authorOpenLibrary.personalName,
      birthDate: authorOpenLibrary.birthDate,
      deathDate: authorOpenLibrary.deathDate,
      biography: authorOpenLibrary.bio,
      photoId: authorOpenLibrary.photos.first,
    );
  }
}
