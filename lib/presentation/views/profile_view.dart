import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // TODO: Navegar a configuración
              },
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Avatar y Nombre de Usuario
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colors.primary.withAlpha(30),
                        child: Text(
                          'A',
                          style: textStyles.headlineLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '@asaocano',
                        style: textStyles.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Miembro desde 2023',
                        style: textStyles.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tarjetas de Métricas Rápidas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const _StatCard(
                            title: '78',
                            subtitle: 'Libros Leídos',
                          ),
                          const _StatCard(title: '15', subtitle: 'Favoritos'),
                          const _StatCard(title: '12', subtitle: 'Reseñas'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Barra de Progreso de Meta de Lectura Anual
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest.withAlpha(100),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meta: 100 libros',
                                  style: textStyles.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '78/100',
                                  style: textStyles.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: 0.78,
                                minHeight: 8,
                                backgroundColor: colors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '78% completado este año',
                              style: textStyles.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Pestañas (Tabs) fijas para Actividad y Reseñas
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: colors.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: colors.primary,
                    tabs: const [
                      Tab(text: 'Actividad'),
                      Tab(text: 'Reseñas'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [_UserActivityList(), _UserReviewsList()],
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para las tarjetas de estadísticas
class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colors.outline.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate implementado correctamente para fijar el TabBar bajo el NestedScrollView
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return _tabBar != oldDelegate._tabBar;
  }
}

// Contenido de ejemplo para la pestaña de Actividad
class _UserActivityList extends StatelessWidget {
  const _UserActivityList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            width: 45,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.book, size: 20),
          ),
          title: Text('Fahrenheit 451 (Edición #${index + 1})'),
          subtitle: const Text('Agregado a tus libros leídos • Hace 2 días'),
        );
      },
    );
  }
}

// Contenido de ejemplo para la pestaña de Reseñas
class _UserReviewsList extends StatelessWidget {
  const _UserReviewsList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fahrenheit 451',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (starIndex) =>
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Una novela distópica fascinante que te hace reflexionar sobre el valor de la lectura y el conocimiento en la sociedad actual...',
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(height: 24),
            ],
          ),
        );
      },
    );
  }
}
