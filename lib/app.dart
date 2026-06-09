import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/inspiration/inspiration_screen.dart';
import 'presentation/screens/import/import_media_screen.dart';
import 'presentation/screens/editor/video_editor_screen.dart';
import 'presentation/screens/preview/preview_screen.dart';
import 'presentation/screens/export/export_screen.dart';

class TattooCreatorApp extends StatelessWidget {
  const TattooCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TattooCreator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/inspiration',
      builder: (context, state) => const InspirationScreen(),
    ),
    GoRoute(
      path: '/import',
      builder: (context, state) => const ImportMediaScreen(),
    ),
    GoRoute(
      path: '/editor',
      builder: (context, state) => const VideoEditorScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) => const PreviewScreen(),
    ),
    GoRoute(
      path: '/export',
      builder: (context, state) => const ExportScreen(),
    ),
  ],
);