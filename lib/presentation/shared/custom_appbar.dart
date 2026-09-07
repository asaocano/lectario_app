import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/delegates/search_book_delegate.dart';
import 'package:lectario_app/presentation/providers/search/search_books_provider.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    //TODO: Cambiar diseño de appbar
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(10, 5, 10, 0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.book, color: colors.primary),
              const SizedBox(width: 5),
              Center(child: Text("Lectario", style: titleStyle)),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final searchedBooks = ref.read(searchedBooksProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  final book = await showSearch<BookPreview?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchBookDelegate(
                      searchBooks: ref
                          .read(searchedBooksProvider.notifier)
                          .searchBooksByQuery,
                      initialBooks: searchedBooks,
                    ),
                  );

                  if (book == null) {
                    return;
                  }

                  if (!context.mounted) {
                    return;
                  }
                  context.push('/home/0/book/', extra: book);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
