import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/providers/books/preview_books_provider.dart';
import 'package:lectario_app/presentation/shared/custom_appbar.dart';
import 'package:lectario_app/presentation/widgets/book_horizontal_listview.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(previewBooksProvider);

    //TODO: Agregar indicador de carga global

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(title: CustomAppbar()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: booksState.sections
                  .where((section) => section.books.isNotEmpty)
                  .map(
                    (section) => BookHorizontalListview(
                      title: section.category.title,
                      books: section.books,
                      loadCategory: () {
                        // Evita ejecutar múltiples veces: comprobamos el estado global
                        if (!booksState.isLoading) {
                          ref
                              .read(previewBooksProvider.notifier)
                              .loadCategory(category: section.category);
                        }
                      },
                    ),
                  )
                  .toList(),
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
