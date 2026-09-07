import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String googleBooksKey = dotenv.env['GOOGLE_BOOKS_KEY'] ?? 'No hay key';
  static String googleBooksApi = dotenv.env['GOOGLE_BOOKS_API'] ?? '';
  static String openLibraryApi = dotenv.env['OPEN_LIBRARY_API'] ?? '';
}
