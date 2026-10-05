import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/presentation/providers/books/loading_books_provider.dart';
import 'package:lectario_app/presentation/providers/books/preview_books_provider.dart';
import 'package:lectario_app/presentation/shared/custom_appbar.dart';
import 'package:lectario_app/presentation/widgets/book_horizontal_listview.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(previewBooksProvider);
    final areCatalogsReady = ref.watch(loadingBooksProvider);
    final theme = Theme.of(context);

    if (!areCatalogsReady) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2.5,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              "Cargando catálogo...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          floating: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final activeSections = booksState.sections
                  .where((section) => section.books.isNotEmpty)
                  .toList();

              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: activeSections.map((section) {
                    return BookHorizontalListview(
                      title: section.category.title,
                      books: section.books,
                      loadCategory: () {
                        if (!section.isLoading) {
                          ref
                              .read(previewBooksProvider.notifier)
                              .loadCategory(category: section.category);
                        }
                      },
                    );
                  }).toList(),
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}