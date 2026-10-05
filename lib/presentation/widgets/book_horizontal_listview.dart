import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';

class BookHorizontalListview extends StatefulWidget {
  final String title;
  final List<BookPreview> books;
  final VoidCallback loadCategory;

  const BookHorizontalListview({
    super.key,
    required this.title,
    required this.books,
    required this.loadCategory,
  });

  @override
  State<BookHorizontalListview> createState() =>
      _BookHorizontalListviewState();
}

class _BookHorizontalListviewState extends State<BookHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 100) >=
          scrollController.position.maxScrollExtent) {
        widget.loadCategory();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290, // Altura optimizada para la portada 2:3 + textos
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(widget.title),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: widget.books.length,
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _Slide(book: widget.books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final BookPreview book;
  const _Slide({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/home/0/book/', extra: book),
      child: Container(
        width: 130, // Ancho consistente para mantener la proporción 2:3
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: FadeInRight(
          duration: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada del libro con relación de aspecto 2:3 y bordes estandarizados
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      fadeOutDuration: const Duration(milliseconds: 100),
                      fadeInDuration: const Duration(milliseconds: 200),
                      image: NetworkImage(
                        book.coverUrl ??
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                      ),
                      placeholder: const AssetImage('assets/loaders/book.gif'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Título del libro
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              // Autor del libro
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.textTheme.labelSmall?.color?.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}