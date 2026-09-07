import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/config/database/database.dart';
import 'package:lectario_app/config/router/app_router.dart';
import 'package:lectario_app/config/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load();
  final deleteQuery = db.delete(db.bookshelf);
  await deleteQuery.go();
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
