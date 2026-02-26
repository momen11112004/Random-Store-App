import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {
  static const _primarySeedColor = Color(0xFF4F46E5);

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primarySeedColor,
        brightness: Brightness.light,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primarySeedColor,
        brightness: Brightness.dark,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}