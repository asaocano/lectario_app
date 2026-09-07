import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/presentation/providers/localDatabase/local_database_provider.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(bookshelfProvider);

    return Center(
      child: Row(
        children: [
          Column(children: [
            ...booksState.favorites.map((book) => Text(book.title))
          ],),
          Column(children: [
            ...booksState.read.map((book) => Text(book.title))
          ],),
          Column(children: [
            ...booksState.wantToRead.map((book) => Text(book.title))
          ],)
        ],
      ),
    );
  }
}