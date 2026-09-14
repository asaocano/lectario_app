import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/screens/barcode_scanner_screen.dart';

typedef SearchBooksCallback = Future<List<BookPreview>> Function(String query);

class SearchBookDelegate extends SearchDelegate<BookPreview?> {
  String _lastSavedQuery = '';
  final SearchBooksCallback searchBooks;
  List<BookPreview> initialBooks;
  StreamController<List<BookPreview>> debouncedBooks =
      StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchBookDelegate({required this.searchBooks, required this.initialBooks});

  /// Cierra cualquier timer que no se haya terminado aún
  void _clearStreams() {
    _debounceTimer?.cancel();
    debouncedBooks.close();
    isLoadingStream.close();
  }

  /// Función que controlará los cambios de la query (texto) que ingrese el usuario
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final books = await searchBooks(query);
      if (debouncedBooks.isClosed || isLoadingStream.isClosed) {
        return;
      }
      debouncedBooks.add(books);
      initialBooks = books;
      isLoadingStream.add(false);
    });
  }

  @override
  void close(BuildContext context, BookPreview? result) {
    // Si la búsqueda no estaba vacía al momento de cerrar,
    // guardamos el texto actual para que se mantenga la próxima vez.
    if (query.isNotEmpty) {
      _lastSavedQuery = query;
    }
    super.close(context, result);
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialBooks,
      stream: debouncedBooks.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(), //TODO: Agregar mejor animación de cargando
                SizedBox(height: 12),
                Text('Buscando libros...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Ocurrió un error al buscar', //TODO: Agregar animación para 
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final books = snapshot.data ?? [];

        if (books.isEmpty &&
            query.isNotEmpty &&
            snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Text("No se encontraron libros relacionados :("),
          );
        }

        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];

            return _Book(
              preview: book,
              onBookSelected: (context, book) {
                _clearStreams();
                close(context, book);
              },
            );
          },
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => "Escanear ISBN o buscar";

  /// Muestra acciones que tendrá la pantalla de búsqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          final isLoading = snapshot.data ?? false;

          if (isLoading) {
            return SpinPerfect(
              infinite: true,
              spins: 20,
              duration: const Duration(seconds: 5),
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Botón de la Cámara: SIEMPRE VISIBLE
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  // 1. Abrir la pantalla del escáner y esperar el resultado
                  final String? scannedIsbn = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerScreen(),
                    ),
                  );

                  // 2. Si se escaneó un ISBN válido, se asigna al 'query' de la búsqueda
                  if (scannedIsbn != null && scannedIsbn.isNotEmpty) {
                    query =
                        scannedIsbn; // Al reasignar query, 'buildSuggestions' disparará el debounce automáticamente
                  }
                },
              ),

              // 2. Botón para Limpiar Texto: Solo visible si hay texto en el input
              if (query.isNotEmpty)
                FadeIn(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: () {
                      query = ''; // Limpia el texto en pantalla
                      _lastSavedQuery =
                          ''; // Resetea también la búsqueda guardada
                      showSuggestions(
                        context,
                      ); // Fuerza a la UI a refrescarse como limpia
                    },
                    icon: const Icon(Icons.clear_rounded),
                  ),
                ),
            ],
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        _clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _lastSavedQuery = query; // Actualizamos el último texto buscado
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty && _lastSavedQuery.isNotEmpty) {
      query = _lastSavedQuery;
    }
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _Book extends StatelessWidget {
  final BookPreview preview;
  final Function onBookSelected;
  final String cover =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png";

  const _Book({required this.preview, required this.onBookSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onBookSelected(context, preview);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  height: 120,
                  fadeOutDuration: const Duration(milliseconds: 100),
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: const AssetImage('assets/loaders/book.gif'),
                  image: NetworkImage(preview.coverUrl ?? cover),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(preview.title, style: textStyles.titleMedium)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
