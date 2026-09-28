import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/domain/entities/book_preview.dart';
import 'package:lectario_app/presentation/providers/authors/author_provider.dart';
import 'package:lectario_app/presentation/providers/books/book_details_provider.dart';

class BookDetailsSection extends ConsumerStatefulWidget {
  final BookPreview preview;
  const BookDetailsSection({super.key, required this.preview});

  @override
  ConsumerState<BookDetailsSection> createState() => _BookDetailsSectionState();
}

class _BookDetailsSectionState extends ConsumerState<BookDetailsSection> {
  bool _isSynopsisExpanded = false;

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
  Widget build(BuildContext context) {
    final detailsState = ref.watch(bookDetailsProvider);
    final authorState = ref.watch(authorsProvider);

    // Margen global interno para evitar que cualquier widget toque los bordes laterales
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================================
          // 1. SINOPSIS CON TARJETA ELEGANTE Y COLAPSIBLE
          // ====================================================================
          if (detailsState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (detailsState.book?.description != null &&
              detailsState.book!.description!.isNotEmpty) ...[
            const _SectionTitle(title: 'Sinopsis'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withAlpha(18), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      detailsState.book!.description!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                    secondChild: Text(
                      detailsState.book!.description!,
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                    crossFadeState: _isSynopsisExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                  if (detailsState.book!.description!.length > 200) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSynopsisExpanded = !_isSynopsisExpanded;
                        });
                      },
                      child: Text(
                        _isSynopsisExpanded ? 'Mostrar menos' : 'Leer más...',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],

          // ====================================================================
          // 2. FICHA TÉCNICA Y TEMAS (CHIPS SUTILMENTE ESTILIZADOS)
          // ====================================================================
          if (detailsState.book != null) ...[
            _TechnicalSheet(book: detailsState.book!),
            const SizedBox(height: 28),
          ],

          // ====================================================================
          // 3. TARJETA PERFIL DEL AUTOR
          // ====================================================================
          if (authorState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (authorState.author != null) ...[
            const _SectionTitle(title: 'Sobre el autor'),
            const SizedBox(height: 10),
            _AuthorCardSection(author: authorState.author!),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

// ====================================================================
// WIDGETS AUXILIARES CON DISEÑO MEJORADO
// ====================================================================

/// Título estandarizado de sección
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// Ficha Técnica estilizada como tarjeta de datos
class _TechnicalSheet extends StatelessWidget {
  final dynamic book;
  const _TechnicalSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Ficha Técnica'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withAlpha(20)),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                Icons.calendar_today_rounded,
                'Año de publicación',
                "${book.preview.publishYear}",
              ),
              const Divider(height: 1, indent: 32),
              _buildDetailRow(
                Icons.language_rounded,
                'Idioma original',
                'Inglés',
              ),
              const Divider(height: 1, indent: 32),
              _buildDetailRow(
                Icons.menu_book_rounded,
                'Ediciones registradas',
                book.preview.editions > 1000
                    ? '1000+'
                    : "${book.preview.editions}",
              ),
            ],
          ),
        ),
        if (book.subjects != null && book.subjects.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Temas Principales',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: (book.subjects as List)
                .take(6)
                .map(
                  (subject) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withAlpha(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_outline_rounded,
                          size: 13,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          subject.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Tarjeta del Autor con elevación suave y mejor alineación
class _AuthorCard extends StatelessWidget {
  final AuthorState authorState;
  const _AuthorCard({required this.authorState});

  @override
  Widget build(BuildContext context) {
    final author = authorState.author!;
    final textStyles = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FadeInImage(
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      author.photoId != 0
                          ? "https://covers.openlibrary.org/a/id/${author.photoId}-L.jpg"
                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                    ),
                    placeholder: const AssetImage('assets/loaders/book.gif'),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.name,
                      style: textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (author.personalName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        author.personalName,
                        style: textStyles.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (author.birthDate.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            author.birthDate,
                            style: textStyles.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    if (author.deathDate.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.church_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            author.deathDate,
                            style: textStyles.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (author.biography.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            Text(
              author.biography,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: textStyles.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper privado para filas de métricas en la Ficha Técnica
Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13.5)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
        ),
      ],
    ),
  );
}

/// Tarjeta del Autor con biografía expansible ("Leer más...")
class _AuthorCardSection extends StatefulWidget {
  final dynamic
  author; // Pasa el objeto author correspondiente de tu provider/entidad

  const _AuthorCardSection({required this.author});

  @override
  State<_AuthorCardSection> createState() => _AuthorCardSectionState();
}

class _AuthorCardSectionState extends State<_AuthorCardSection> {
  bool _isBioExpanded = false;

  @override
  Widget build(BuildContext context) {
    final author = widget.author;
    final textStyles = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FadeInImage(
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      author.photoId != 0
                          ? "https://covers.openlibrary.org/a/id/${author.photoId}-L.jpg"
                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1920px-No-Image-Placeholder.svg.png',
                    ),
                    placeholder: const AssetImage('assets/loaders/book.gif'),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.name,
                      style: textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (author.personalName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        author.personalName,
                        style: textStyles.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (author.birthDate.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            author.birthDate,
                            style: textStyles.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    if (author.deathDate.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.church_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            author.deathDate,
                            style: textStyles.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (author.biography.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            AnimatedCrossFade(
              firstChild: Text(
                author.biography,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: textStyles.bodyMedium?.copyWith(
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
              secondChild: Text(
                author.biography,
                style: textStyles.bodyMedium?.copyWith(
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
              crossFadeState: _isBioExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
            if (author.biography.length > 180) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    _isBioExpanded = !_isBioExpanded;
                  });
                },
                child: Text(
                  _isBioExpanded ? 'Mostrar menos' : 'Leer más...',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
