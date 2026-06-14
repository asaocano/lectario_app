import 'package:flutter/material.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:animate_do/animate_do.dart';

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
  State<BookHorizontalListview> createState() => _BookHorizontalListviewState();
}

class _BookHorizontalListviewState extends State<BookHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 50) >=
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
      height: 400,
      child: Column(
        children: [
          _Title(widget.title),
          Expanded(
            child: ListView.builder(
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
    final textStyles = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Portada del libro
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: Image.network(
                book.coverUrl ??
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                fit: BoxFit.cover,
                height: 220,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2), //TODO: Cambiar a imagen de carga
                      ),
                    );
                  }

                  return FadeIn(child: child); //TODO: Arreglar animación
                },
              ),
            ),
          ),

          const SizedBox(height: 5),
          //Titulo del libro
          SizedBox(
            height: 40,
            width: 150,
            child: Text(book.title, maxLines: 2, style: textStyles.titleSmall),
          ),

          const SizedBox(height: 3),

          //Autor
          SizedBox(
            height: 40,
            width: 150,
            child: Text(book.author, maxLines: 2, style: textStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
        ],
      ),
    );
  }
}
