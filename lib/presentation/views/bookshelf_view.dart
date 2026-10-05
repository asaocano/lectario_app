import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/providers/localDatabase/local_database_provider.dart';

class BookshelfView extends ConsumerWidget {
  const BookshelfView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(bookshelfProvider);

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(bookshelfProvider.notifier).loadInitialCatalogs();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            // Sección 1: Favoritos (Status 2)
            _BookshelfSection(
              title: 'Favoritos',
              icon: Icons.favorite,
              iconColor: Colors.red,
              books: booksState.favorites,
              isLastPage: booksState.favoritesLastPage,
              onLoadMore: () {
                ref.read(bookshelfProvider.notifier).loadNextPage(2);
              },
            ),
            const SizedBox(height: 28),

            // Sección 2: Quiero Leer (Status 1)
            _BookshelfSection(
              title: 'Quiero Leer',
              icon: Icons.bookmark_add_rounded,
              iconColor: Colors.orange,
              books: booksState.wantToRead,
              isLastPage: booksState.wantToReadLastPage,
              onLoadMore: () {
                ref.read(bookshelfProvider.notifier).loadNextPage(1);
              },
            ),
            const SizedBox(height: 28),

            // Sección 3: Leídos (Status 3)
            _BookshelfSection(
              title: 'Leídos',
              icon: Icons.bookmark_added,
              iconColor: Colors.green,
              books: booksState.read,
              isLastPage: booksState.readLastPage,
              onLoadMore: () {
                ref.read(bookshelfProvider.notifier).loadNextPage(3);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _BookshelfSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<BookPreview> books;
  final bool isLastPage;
  final VoidCallback onLoadMore;

  const _BookshelfSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.books,
    required this.isLastPage,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${books.length} libros',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (books.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No hay libros en esta sección',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
          )
        else
          _BooksGrid(
            books: books,
            isLastPage: isLastPage,
            onLoadMore: onLoadMore,
          ),
      ],
    );
  }
}

class _BooksGrid extends StatelessWidget {
  final List<BookPreview> books;
  final bool isLastPage;
  final VoidCallback onLoadMore;

  const _BooksGrid({
    required this.books,
    required this.isLastPage,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = books.length + (isLastPage ? 0 : 1);
    final rowCount = (totalItems / 3).ceil();
    final rowSizes = List.generate(rowCount, (_) => auto);

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr],
      rowSizes: rowSizes,
      rowGap: 16,
      columnGap: 12,
      children: [
        for (int i = 0; i < books.length; i++) _BookCard(preview: books[i]),

        if (!isLastPage) _LoadMoreCard(onTap: onLoadMore),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final BookPreview preview;

  const _BookCard({required this.preview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/home/0/book/', extra: preview),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                image: DecorationImage(
                  image: NetworkImage(
                    preview.coverUrl ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          Text(
            preview.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            preview.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.labelSmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadMoreCard extends StatelessWidget {
  final VoidCallback onTap;

  const _LoadMoreCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cargar\nmás',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
