import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

typedef SearchBooksCallback = Future<List<BookPreview>> Function(String query);

class SearchBookDelegate extends SearchDelegate<BookPreview?> {
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
    isLoadingStream.add(
      true,
    ); //* Se agrega un nuevo estado de "cargando" (el estado se cambia a true) para mostrar el widget que gira
    //* Si el usuario sigue escribiendo antes de que se cumplan los 500ms, se cancela el timer anterior para evitar lanzar una búsqueda innecesaria.
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final books = await searchBooks(
        query,
      ); //* Ejecuta el callback que obtiene los libros (normalmente desde una API)
      debouncedBooks.add(
        books,
      ); //* Agrega los libros al stream para que se muestren en la lista
      initialBooks =
          books; //* Actualiza los libros iniciales para que el StreamBuilder tenga el último resultado como base si se reconstruye.
      isLoadingStream.add(
        false,
      ); //* Se termina la petición para que se quite el widget girando y se muestre el de borrar
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialBooks,
      stream: debouncedBooks.stream,
      builder: (context, snapshot) {
        final books = snapshot.data ?? [];

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

  /// Label que tendrá el buscador
  @override
  String? get searchFieldLabel => "Buscar libro";

  /// Muestra acciones que tendrá la pantalla de búsqueda (¿Qué botones o widgets tendrá?)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        //* Reconstruye la UI cada vez que el stream emite un nuevo valor.
        initialData: false, //* Valor inicial
        stream: isLoadingStream
            .stream, //* Se suscribe al stream (Los cambios a los que estará pendiente)
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            //* Último valor emitido (Si no hay un valor se usa uno por defecto)
            //* Si está cargando, muestra un widget girando indicando que se está "procesando" su búsqueda
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

          //* Si no está cargando, se muestra botón para limpiar búsqueda
          return Row(
            children: [
              FadeIn(
                animate: query.isNotEmpty,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ),
              FadeIn(
                animate: query.isNotEmpty,
                duration: const Duration(microseconds: 200),
                child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.clear_rounded),
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  /// ¿Qué widgets tendrá ANTES de la barra de búsqueda? (Generalmente es el botón para regresar)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        _clearStreams(); //* Cierra los streams a los que está suscrito
        close(
          context,
          null,
        ); //* Ejecuta la función para cerrar búsqueda o regresar (Se manda null para que la pantalla anterior no haga nada)
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  /// Indica qué se hará al FINALIZAR la búsqueda (Cuando el usuario presione el botón "Aceptar" o el que permita completar la búsqueda)
  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  /// Indica qué se hará MIENTRAS se realiza la búsqueda (Mientras el usuario escribe)
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(
      query,
    ); //* Reacciona al nuevo valor de la query (El texto de búsqueda) ejecutando el debounce
    return _buildResultsAndSuggestions(); //* Función que realiza la búsqueda
  }
}

class _Book extends StatelessWidget {
  final BookPreview preview;
  final Function onBookSelected;
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
            //Portada del libro
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  preview.coverUrl ??
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),
            const SizedBox(width: 10),

            //Título
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preview.title, style: textStyles.titleMedium),
                  //? TODO: ¿Agregar algo más? Tal vez el autor
                  // Row(children: [

                  // ],)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
