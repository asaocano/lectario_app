import 'package:flutter/material.dart';
import 'package:lectario_app/presentation/views/views.dart';
import 'package:lectario_app/presentation/shared/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  final int viewIndex;
  static const name = 'home-screen';

  const HomeScreen({super.key, required this.viewIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    DiscoverView(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    //TODO: Crear listen general para errores
    return Scaffold(
      body: IndexedStack(index: viewIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: viewIndex),
    );
  }
}
