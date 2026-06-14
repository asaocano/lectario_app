import 'package:dio/dio.dart';
import 'package:lectario_app/config/constants/environment.dart';
import 'package:lectario_app/data/mappers/book_mapper.dart';
import 'package:lectario_app/data/models/OpenLibrary/open_library_response.dart';
import 'package:lectario_app/domain/datasources/books/books_datasource.dart';
import 'package:lectario_app/domain/entities/book_category.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class BooksDatasourceImpl extends BooksDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.openLibraryApi));

  List<BookPreview> _jsonToBooks(
    Map<String, dynamic> json,
    BookCategory category,
  ) {
    final openLibraryResponse = OpenLibraryResponse.fromJson(json);

    final List<BookPreview> books = openLibraryResponse.works
        // .where((openLibraryBook) => category.matches(openLibraryBook.subject))
        .map((book) => BookMapper.castToEntity(book))
        .toList();

    return books;
  }

  @override
  Future<List<BookPreview>> getBooksByCategory(
    BookCategory category,
    int limit,
    int offset,
  ) async {
    try {
      final response = await dio.get(
        'subjects/${category.apiValue}.json',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      final books = _jsonToBooks(response.data, category);
      return books;
    } catch (e) {
      print(e);
      return <BookPreview>[];
    }
  }
}
