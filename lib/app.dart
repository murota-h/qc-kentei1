import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chapter_screen.dart';
import 'screens/bookmark_screen.dart';
import 'theme/app_theme.dart';

class QcKenteiApp extends StatelessWidget {
  const QcKenteiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QC検定1級対策',
      theme: AppTheme.theme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );
          case '/chapter':
            final number = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ChapterScreen(chapterNumber: number),
            );
          case '/bookmarks':
            return MaterialPageRoute(
              builder: (_) => const BookmarkScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );
        }
      },
    );
  }
}
