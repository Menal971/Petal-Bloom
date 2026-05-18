import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Petal Pink Color Palette ──────────────────────────────────────────────
  static const Color rosePetal = Color(0xFFFF6B9D); // vibrant pink accent
  static const Color blushLight = Color(0xFFFFF0F5); // soft background
  static const Color blushMid = Color(0xFFFFD6E7); // card tint
  static const Color blushDeep = Color(0xFFFFB3D1); // dividers / chips
  static const Color roseDeep = Color(0xFFE91E8C); // dark accent
  static const Color petal50 = Color(0xFFFCE4EC);
  static const Color inkDark = Color(0xFF2D1B29); // primary text
  static const Color inkMid = Color(0xFF7B4F6A); // secondary text
  static const Color white = Color(0xFFFFFFFF);

  // Card accent colors (rotating per card)
  static const List<Color> cardAccents = [
    Color(0xFFFFB3D1),
    Color(0xFFFFCCE5),
    Color(0xFFFFD9EC),
    Color(0xFFFFC2DC),
    Color(0xFFFFBDD8),
  ];

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rosePetal,
        brightness: Brightness.light,
        primary: rosePetal,
        onPrimary: white,
        primaryContainer: blushMid,
        onPrimaryContainer: inkDark,
        secondary: roseDeep,
        onSecondary: white,
        secondaryContainer: petal50,
        onSecondaryContainer: inkDark,
        surface: blushLight,
        onSurface: inkDark,
        onSurfaceVariant: inkMid,
        error: Color(0xFFD32F2F),
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: blushLight,
      appBarTheme: AppBarTheme(
        backgroundColor: blushLight,
        foregroundColor: inkDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: inkDark,
        ),
        iconTheme: const IconThemeData(color: rosePetal),
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 32, fontWeight: FontWeight.w800, color: inkDark),
        headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 22, fontWeight: FontWeight.w700, color: inkDark),
        titleLarge: GoogleFonts.dmSans(
            fontSize: 17, fontWeight: FontWeight.w600, color: inkDark),
        bodyLarge: GoogleFonts.dmSans(fontSize: 15, color: inkMid, height: 1.6),
        bodyMedium: GoogleFonts.dmSans(fontSize: 13, color: inkMid),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: blushDeep),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: blushDeep, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: rosePetal, width: 2),
        ),
        labelStyle: GoogleFonts.dmSans(color: inkMid, fontSize: 14),
        hintStyle: GoogleFonts.dmSans(color: blushDeep, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: rosePetal,
        foregroundColor: white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: inkDark,
        contentTextStyle: GoogleFonts.dmSans(color: white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: blushMid,
        labelStyle: GoogleFonts.dmSans(
            color: inkDark, fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
