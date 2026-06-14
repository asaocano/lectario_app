import 'package:go_router/go_router.dart';
import 'package:lectario_app/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:view',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['view'] ?? '0');
        return HomeScreen(viewIndex: pageIndex);
      },
    ),


    GoRoute(path: '/', redirect: (context, state) => '/home/0',)
  ],
);
