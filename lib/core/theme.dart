import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF673AB7);
  static const backgroundColor = Color(0xFF000000);
  static const cardColor = Color(0xFF1C1C1E);
  static const glassColor = Color(0x1AFFFFFF);
  static const accentBlue = Color(0xFF8EACCD);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: cardColor,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 36, letterSpacing: -1),
      headlineMedium: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
      bodyLarge: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
      bodyMedium: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 0,
    ),
  );
}
