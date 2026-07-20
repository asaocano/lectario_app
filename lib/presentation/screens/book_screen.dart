import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/providers/authors/author_provider.dart';
import 'package:lectario_app/presentation/providers/books/book_details_provider.dart';
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
          SliverFillRemaining(
            hasScrollBody: true,
            child: _BookDetails(preview),
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
                // CAPA 3: BOTÓN DE REGRESO FIJO EN LA POSICIÓN SUPERIOR IZQUIERDA
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

                // ====================================================================
                // CAPA 4: PORTADA CENTRAL EN RELIEVE TRIDIMENSIONAL
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
                // CAPA 5: DEGRADADO DE FUSIÓN INFERIOR CON EL FONDO DE LA APP
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
                // CAPA 6: COMPOSICIÓN DE TEXTOS DE DATOS (TÍTULO Y AUTOR)
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
              ],
            );
          },
        ),
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

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        top: true,
        bottom: false,
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
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 15,
                    ),
                    child: Text(detailsState.book?.description ?? ''),
                  ),

                  Column(
                    // children: [
                    //   ...detailsState.book!.subjects.map(
                    //     (subject) => Container(
                    //       margin: const EdgeInsets.only(right: 10),
                    //       child: Chip(
                    //         label: Text(subject),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ],
                  ),

                  Center(child: Text(authorState.author?.name ?? '')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
