import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _BookDetails(preview),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final String defaultCover;
  final BookPreview preview;
  const _CustomSliverAppBar({
    required this.preview,
    required this.defaultCover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final gradient = ref.watch(
      coverGRadientProvider(preview.coverUrl ?? defaultCover),
    );

    return SliverAppBar(
      expandedHeight: size.height * 0.4,
      foregroundColor: Colors.white,
      actions: [],
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: AlignmentDirectional.center,
              children: [
                gradient.when(
                  data: (colors) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: colors,
                      ),
                    ),
                  ),
                  loading: () => const ColoredBox(color: Colors.black),
                  error: (_, __) => const ColoredBox(color: Colors.black),
                ),
                Center(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.7,
                    child: Image.network(
                      preview.coverUrl ?? '',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          return SizedBox();
                        } else {
                          return FadeIn(child: child);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        // end: AlignmentGeometry.bottomLeft,
                        stops: [0.0, 0.3],
                        colors: [Colors.black87, Colors.transparent],
                      ),
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
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(bookDetailsProvider);

    //TODO: Cambiar diseño de la pantalla

    return SizedBox(
      height: 300,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(widget.preview.title, style: TextStyle(fontSize: 25)),
            const SizedBox(height: 15),
            Text(
              widget.preview.author,
              style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.leckerliOne.toString(),
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.preview.publishYear != null)
              Text("${widget.preview.publishYear}"),
  
            const SizedBox(height: 15,),

            if (detailsState.isLoading)
              CircularProgressIndicator(strokeWidth: 2),

            Text(detailsState.book?.description ?? '') 
          ],
        ),
      ),
    );
  }
}
