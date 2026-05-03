import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const ch1 = Color(0xFF1565C0);
  static const ch2 = Color(0xFF283593);
  static const ch3 = Color(0xFF1B5E20);
  static const ch4 = Color(0xFF4A148C);
  static const ch5 = Color(0xFFB71C1C);
  static const ch6 = Color(0xFFE65100);
  static const ch7 = Color(0xFF006064);
  static const ch8 = Color(0xFF37474F);
  static const ch9 = Color(0xFF4E342E);

  static const surface = Color(0xFFF5F5F5);
  static const cardBg = Colors.white;

  static const chapterColors = {
    1: ch1,
    2: ch2,
    3: ch3,
    4: ch4,
    5: ch5,
    6: ch6,
    7: ch7,
    8: ch8,
    9: ch9,
  };

  static Color chapterColor(int n) => chapterColors[n] ?? ch1;
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ch1,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
    );
    return base.copyWith(
      textTheme: GoogleFonts.notoSansJpTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ch1,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBg,
        elevation: 2,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
