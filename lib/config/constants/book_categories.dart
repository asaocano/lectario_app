import 'package:lectario_app/domain/entities/book_category.dart';

abstract final class BookCategories {
  const BookCategories._();

  static const scienceFiction = BookCategory(
    id: 'science-fiction',
    title: 'Ciencia ficción',
    apiValue: 'science_fiction',
    subjects: {
      'science fiction',
      'science-fiction',
      'ciencia ficción',
      'ciencia-ficción',
      'fiction, science fiction, general',
      'english science fiction',
    },
  );

  static const fantasy = BookCategory(
    id: 'fantasy',
    title: 'Fantasía',
    apiValue: 'fantasy',
    subjects: {
      'fantasy',
      'fantasy fiction',
      'high fantasy',
      'epic fantasy',
      'magic',
      'dragons',
    },
  );

  static const mystery = BookCategory(
    id: 'mystery',
    title: 'Misterio',
    apiValue: 'mystery',
    subjects: {
      'mystery',
      'mystery fiction',
      'detective',
      'detective and mystery stories',
      'crime',
      'crime fiction',
      'murder',
    },
  );

  static const horror = BookCategory(
    id: 'horror',
    title: 'Terror',
    apiValue: 'horror',
    subjects: {
      'horror',
      'horror fiction',
      'ghost stories',
      'supernatural',
      'gothic fiction',
      'haunted houses',
      'monsters',
    },
  );

  static const romance = BookCategory(
    id: 'romance',
    title: 'Romance',
    apiValue: 'romance',
    subjects: {'romance', 'romantic fiction', 'love stories', 'courtship'},
  );

  static final List<BookCategory> values = [
    scienceFiction,
    fantasy,
    mystery,
    horror,
    romance,
  ];

  static BookCategory? fromId(String id) {
    try {
      return values.firstWhere((category) => category.id == id);
    } catch (_) {
      return null;
    }
  }

  static BookCategory? fromapiValue(String apiValue) {
    try {
      return values.firstWhere((category) => category.apiValue == apiValue);
    } catch (_) {
      return null;
    }
  }
}
