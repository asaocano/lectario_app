import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lectario_app/domain/entities/book.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/domain/enums/bookshelf_status.dart';
import 'package:lectario_app/presentation/providers/authors/author_provider.dart';
import 'package:lectario_app/presentation/providers/books/book_details_provider.dart';
import 'package:lectario_app/presentation/providers/localDatabase/local_database_provider.dart';
import 'package:lectario_app/presentation/providers/shared/cover_gradient_provider.dart';

class BookScreen extends StatelessWidget {
  static String name = "book-screen";
  static const String defaultCover =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png";
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = GoRouterState.of(context).extra as BookPreview;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(preview: preview, defaultCover: defaultCover),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BookActions(preview: preview),
                _BookDetails(preview),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Componente de UI que genera una cabecera colapsable y dinámica para la
/// pantalla de detalles de un libro en la aplicación "Lectario".
///
/// Reemplaza los degradados planos por un diseño envolvente (*Full-Bleed*)
/// que duplica la portada del libro: una versión en pantalla completa con
/// desenfoque gaussiano para el fondo y una versión nítida en el centro
/// que simula un libro físico con relieve tridimensional.
class _CustomSliverAppBar extends ConsumerWidget {
  /// URL de la imagen de respaldo en caso de que la API de Open Library
  /// no retorne ninguna portada válida para el libro actual.
  final String defaultCover;

  /// Modelo de datos que provee la información del libro,
  /// incluyendo el título, autor y la URL de la portada ([coverUrl]).
  final BookPreview preview;

  const _CustomSliverAppBar({
    required this.preview,
    required this.defaultCover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. DIMENSIONES Y URL BASE
    // Se extrae el tamaño de la pantalla para realizar cálculos de altura proporcionales.
    final size = MediaQuery.of(context).size;
    // Se valida si existe una portada específica o se asigna la imagen por defecto.
    final coverUrl = preview.coverUrl ?? defaultCover;

    return SliverAppBar(
      // Establece que la cabecera ocupará el 45% del alto total de la pantalla al abrirse.
      expandedHeight: size.height * 0.45,
      // Define el color por defecto (blanco) para los elementos del sistema como la flecha de volver.
      // foregroundColor: Colors.white,
      // Hace transparente el fondo nativo del AppBar para que no tape las capas del Stack inferior.
      backgroundColor: Colors.transparent,
      // Remueve las sombras predeterminadas de la barra cuando está expandida o colapsada.
      elevation: 0,
      scrolledUnderElevation: 0,
      // Mantiene la barra fija en la parte superior como un contenedor compacto al hacer scroll vertical.
      pinned: true,
      //Desaparecen los botones de navegación y los tabs toman ese espacio disponible para que no se empalmen
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        // LayoutBuilder nos da acceso a 'constraints.maxHeight' para saber cuántos píxeles
        // mide la cabecera en tiempo real mientras el usuario hace scroll.
        background: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // ====================================================================
                // CAPA 1: PORTADA EN ESPACIO COMPLETO CON DESENFOQUE REAL (BLUR)
                // ====================================================================
                // ImageFiltered debe envolver directamente al Image.network para que
                // el motor gráfico aplique el desenfoque sobre los píxeles reales de la portada.
                Positioned.fill(
                  child: ImageFiltered(
                    // Aplica un desenfoque gaussiano homogéneo de 12.0 en los ejes X e Y.
                    imageFilter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: Image.network(
                      coverUrl,
                      // Estira, escala y corta la portada para rellenar el 100% del fondo.
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ====================================================================
                // CAPA 2: FILTRO OSCURO DE CONTRASTE Y ACCESIBILIDAD (SIN DEPRECATED)
                // ====================================================================
                // Se reemplaza '.withOpacity(0.25)' por un color ARGB entero directo.
                // El canal Alfa en 64 equivale al 25% de opacidad (255 * 0.25). Esto evita
                // ralentizaciones en la GPU y asegura que los textos/iconos blancos resalten.
                Positioned.fill(
                  child: Container(color: const Color.fromARGB(64, 0, 0, 0)),
                ),

                // ====================================================================
                // CAPA 3: PORTADA CENTRAL EN RELIEVE TRIDIMENSIONAL
                // ====================================================================
                // Posiciona la portada real flotando sobre el fondo difuminado.
                Positioned(
                  // Desplaza la miniatura hacia abajo un 12% de la altura total disponible.
                  top: constraints.maxHeight * 0.12,
                  child: Container(
                    // La altura de la miniatura escala dinámicamente al 50% del alto de la cabecera.
                    height: constraints.maxHeight * 0.50,
                    decoration: BoxDecoration(
                      // Borde perimetral blanco de 1.5px al 90% de opacidad (Alfa: 230).
                      // Emula el marco de luz de un libro físico y delimita la portada del fondo.
                      border: Border.all(
                        color: const Color.fromARGB(230, 255, 255, 255),
                        width: 1.5,
                      ),
                      // Sombra compacta al 35% de opacidad (Alfa: 89) empujada 5px hacia abajo.
                      // Genera un efecto óptico de elevación o profundidad en la interfaz.
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(89, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.network(
                      coverUrl,
                      // Fuerza a que la imagen se muestre completa sin recortes involuntarios.
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          return const SizedBox(); // Oculta contenedores rotos mientras descarga.
                        } else {
                          return child;
                        }
                      },
                    ),
                  ),
                ),

                // ====================================================================
                // CAPA 4: DEGRADADO DE FUSIÓN INFERIOR CON EL FONDO DE LA APP
                // ====================================================================
                // Aplica una transición degradada para unir el SliverAppBar con el cuerpo inferior.
                // Los 'stops [0.6, 0.95]' indican que el fondo es 100% transparente hasta el
                // primer 60% de altura, y se oscurece gradualmente hasta llegar al 95%.
                SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 0.95],
                        colors: [
                          Colors.transparent,
                          // Color oscuro base de tu app (ej. #090D16 con un Alfa de 242 para 95% opacidad).
                          const Color.fromARGB(242, 9, 13, 22),
                        ],
                      ),
                    ),
                  ),
                ),

                // ====================================================================
                // CAPA 5: COMPOSICIÓN DE TEXTOS DE DATOS (TÍTULO Y AUTOR)
                // ====================================================================
                // Fija la sección informativa al fondo de la cabecera dejando 20px de margen inferior
                // y márgenes simétricos a los lados para evitar que los textos toquen los bordes.
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Se encoge para ocupar solo el espacio del texto.
                    children: [
                      // TEXTO DEL TÍTULO PRINCIPAL
                      Text(
                        preview.title ?? 'Sin título',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily:
                              'serif', // Le otorga el estilo tipográfico clásico/literario.
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        // CONTROL DE OVERFLOW: Si el título es muy largo, se restringe a 2 líneas
                        // y el excedente se corta inyectando tres puntos suspensivos (...) automáticamente.
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 6,
                      ), // Separación controlada entre el título y el autor.
                      // TEXTO DEL NOMBRE DEL AUTOR
                      Text(
                        preview.author ?? 'Autor desconocido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // Se aplica .withAlpha(204) que equivale a 80% de opacidad para jerarquía visual.
                          color: Colors.white.withAlpha(204),
                          letterSpacing: 0.3,
                        ),
                        // CONTROL DE OVERFLOW: El autor se limita estrictamente a una sola línea.
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ====================================================================
                // CAPA 6: BOTÓN DE REGRESO FIJO EN LA POSICIÓN SUPERIOR IZQUIERDA
                // ====================================================================
                //Como se quitó de forma automática, hay que volverlo a agregar de forma estática
                //para que aparezca cuando la portada vuelva a estar disponible
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookActions extends ConsumerWidget {
  final BookPreview preview;
  const _BookActions({required this.preview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookshelf = ref.read(bookshelfProvider.notifier);
    final bookshelfState = ref.watch(bookshelfProvider);
    final isInWant = bookshelfState.wantToRead.any(
      (book) => book.id == preview.id,
    );
    final isFavorite = bookshelfState.favorites.any(
      (book) => book.id == preview.id,
    );
    final isRead = bookshelfState.read.any((book) => book.id == preview.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20), // Fondo suave
          borderRadius: BorderRadius.circular(16), // Bordes curvos tipo píldora
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildActionItem(
                icon: isInWant
                    ? Icons.bookmark_add_rounded
                    : Icons.bookmark_add_outlined,
                label: "Quiero leer",
                color: Colors.orange,
                onTap: () => bookshelf.toogleBook(
                  preview,
                  BookshelfStatus.wantToRead.value,
                ),
              ),
            ),
            // Línea divisoria sutil entre botones
            Container(height: 35, width: 2, color: Colors.grey.withAlpha(20)),
            Expanded(
              child: _buildActionItem(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                label: "Favorito",
                color: Colors.red,
                onTap: () => bookshelf.toogleBook(
                  preview,
                  BookshelfStatus.favorite.value,
                ),
              ),
            ),
            Container(height: 35, width: 2, color: Colors.grey.withAlpha(20)),
            Expanded(
              child: _buildActionItem(
                icon: isRead
                    ? Icons.bookmark_added
                    : Icons.bookmark_added_outlined,
                label: "Leído",
                color: Colors.green,
                onTap: () =>
                    bookshelf.toogleBook(preview, BookshelfStatus.read.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _BookDetails extends ConsumerStatefulWidget {
  final BookPreview preview;
  const _BookDetails(this.preview);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends ConsumerState<_BookDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(bookDetailsProvider.notifier)
          .loadDetails(preview: widget.preview);

      ref.read(authorsProvider.notifier).loadAuthor(widget.preview.authorId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(bookDetailsProvider);
    final authorState = ref.watch(authorsProvider);
    final textStyles = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize
                .tab, //El tamaño de la barra del tab será del tamaño del mismo tab
            // indicatorColor: const Color(0xFFE27363), //Color de la barra cuando está seleccionado el tab
            indicatorWeight: 3, //Se hace más grueso el indicador del tab
            unselectedLabelColor:
                Colors.grey, //Color del tab cuando no está seleccionado
            // labelColor: const Color(0xFFE27363), //Color del tab cuando está seleccionado
            tabs: const [
              Tab(icon: Icon(Icons.import_contacts), text: "Sinopsis"),
              Tab(icon: Icon(Icons.info), text: "Detalles"),
              Tab(icon: Icon(Icons.person), text: "Autor"),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                //Sinopsis
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 15,
                    ),
                    child: Text(detailsState.book?.description ?? ''),
                  ),
                ),

                //Detalles y categorías
                (!detailsState.isLoading && detailsState.book != null)
                    ?
                      /// Vista de la pestaña "Detalles" que organiza la información técnica del libro
                      /// en dos secciones principales: Ficha Técnica (metadatos) y Temas Principales (etiquetas).
                      SingleChildScrollView(
                        // Aplica un margen interno homogéneo de 20px alrededor de todo el contenido,
                        // separando los textos e islas de información de los bordes físicos de la pantalla.
                        padding: const EdgeInsets.all(20.0),

                        child: Column(
                          // Alinea todos los elementos hijos (encabezados, contenedores, etiquetas)
                          // hacia el margen izquierdo de la vista.
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ====================================================================
                            // SECCIÓN 1: ENCABEZADO Y CONTENEDOR DE LA FICHA TÉCNICA
                            // ====================================================================
                            const Text(
                              'Ficha Técnica',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ), // Separación vertical hacia la tarjeta
                            // Tarjeta/Isla de metadatos con fondo tenue y bordes redondeados
                            Container(
                              padding: const EdgeInsets.all(
                                16,
                              ), // Espaciado interno de la tarjeta
                              decoration: BoxDecoration(
                                // Canal Alfa en 20 (~8% de opacidad) para un fondo sutil que resalta sobre el tema oscuro/claro
                                color: Colors.grey.withAlpha(20),
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Curvatura estilizada de las esquinas
                              ),
                              child: Column(
                                children: [
                                  // Fila de Año de Publicación
                                  _buildDetailRow(
                                    Icons.calendar_today_outlined,
                                    'Año de publicación',
                                    "${detailsState.book!.preview.publishYear}",
                                  ),
                                  const Divider(
                                    height: 1,
                                  ), // Línea divisoria sutil entre filas
                                  // Fila de Idioma Original
                                  _buildDetailRow(
                                    Icons.language_outlined,
                                    'Idioma original',
                                    'Inglés',
                                  ),
                                  const Divider(height: 1),

                                  // Fila de Ediciones
                                  _buildDetailRow(
                                    Icons.menu_book_outlined,
                                    'Ediciones registradas',
                                    detailsState.book!.preview.editions > 1000
                                        ? '1000+'
                                        : "${detailsState.book!.preview.editions}",
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 24,
                            ), // Separación amplia entre bloques temáticos
                            // ====================================================================
                            // SECCIÓN 2: TEMAS Y GÉNEROS (CHIPS Y WRAP)
                            // ====================================================================
                            const Text(
                              'Temas Principales',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ), // Separación hacia las etiquetas
                            // Reemplaza a 'Column' o 'Row' para evitar errores de desbordamiento (Overflow).
                            // Coloca las etiquetas de forma horizontal y salta automáticamente a la siguiente
                            // línea cuando la etiqueta actual sobrepasa el ancho de la pantalla.
                            Wrap(
                              spacing:
                                  8.0, // Distancia horizontal entre cada Chip
                              runSpacing:
                                  8.0, // Distancia vertical entre las filas creadas
                              children: detailsState.book!.subjects
                                  // 1. CONTROL DE RECURSOS: Se filtran y toman únicamente las primeras 6 categorías
                                  //    de Open Library para no saturar la vista con temas secundarios.
                                  .take(6)
                                  // 2. TRANSFORMACIÓN: Convierte cada cadena de texto en un widget 'Chip' estilizado.
                                  .map(
                                    (subject) => Chip(
                                      // Icono decorativo al inicio del chip
                                      avatar: const Icon(
                                        Icons.bookmark,
                                        size: 14,
                                        // color: Color(
                                        //   0xFFE27363,
                                        // ), // Color acento coral unificado de la app
                                      ),
                                      label: Text(
                                        subject,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Fondo con el color acento coral al ~10% de opacidad (withAlpha: 25)
                                      // backgroundColor: const Color(
                                      //   0xFFE27363,
                                      // ).withAlpha(25),
                                      // Otorga la forma de píldora (ovalada) y elimina el borde gris nativo
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                  )
                                  .toList(), // Convierte la iteración de mapas nuevamente en una lista de Widgets
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                //Información del autor
                //TODO: Agregar componente de respaldo si no hay un autor
                (authorState.isLoading || authorState.author == null)
                    ? const SizedBox()
                    : _AuthorInfo(
                        authorState: authorState,
                        textStyles: textStyles,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  const _AuthorInfo({required this.authorState, required this.textStyles});

  final AuthorState authorState;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          height: 220,
                          fadeOutDuration: const Duration(milliseconds: 100),
                          fadeInDuration: const Duration(milliseconds: 200),
                          image: NetworkImage(
                            authorState.author != null
                                ? "https://covers.openlibrary.org/a/id/${authorState.author!.photoId}-L.jpg"
                                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                          ),
                          placeholder: const AssetImage(
                            'assets/loaders/book.gif',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorState.author!.name,
                        style: textStyles.titleLarge,
                      ),
                      Text(
                        "(${authorState.author!.personalName})",
                        style: textStyles.labelSmall,
                      ),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(Icons.cake_rounded, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            authorState.author!.birthDate,
                            style: textStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      authorState.author!.deathDate.isNotEmpty
                          ? Row(
                              children: [
                                const Icon(Icons.church, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  authorState.author!.deathDate,
                                  style: textStyles.bodySmall,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(authorState.author!.biography),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para las métricas/datos rápidos
Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    ),
  );
}
