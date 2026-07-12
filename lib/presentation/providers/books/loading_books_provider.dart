import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/presentation/providers/books/preview_books_provider.dart';

/// Indica si todas las secciones del catálogo de libros continúan cargando.
///
/// Este provider observa el estado expuesto por [previewBooksProvider] y
/// devuelve `true` únicamente cuando todas las secciones del catálogo
/// permanecen en estado de carga.
///
/// Es útil para mostrar un indicador de carga global mientras se obtiene
/// la información inicial del catálogo.
final loadingBooksProvider = Provider<bool>((ref) {
  final booksCatalog = ref.watch(previewBooksProvider);
  return booksCatalog.sections.every((section) => section.isLoading);
});