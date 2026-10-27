import 'package:flutter/material.dart';

/// CampusLoop visual design system.
///
/// Color palette:
/// - Primary: Deep Teal (#0D6E6E)
/// - Secondary: Dark Blue (#1A237E)
/// - Surface: Warm Cream (#FFF8F0)
/// - Accent Coral: (#FF6B6B)
/// - Accent Soft Blue: (#64B5F6)
/// - Accent Mint: (#69F0AE)
/// - Accent Lavender: (#B39DDB)
class CampusTheme {
  // ── Color Palette ──
  static const Color deepTeal = Color(0xFF0D6E6E);
  static const Color darkTeal = Color(0xFF094D4D);
  static const Color darkBlue = Color(0xFF1A237E);
  static const Color warmCream = Color(0xFFFFF8F0);
  static const Color offWhite = Color(0xFFFAF5EF);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color softBlue = Color(0xFF64B5F6);
  static const Color mint = Color(0xFF69F0AE);
  static const Color lavender = Color(0xFFB39DDB);
  static const Color darkSurface = Color(0xFF0F1923);
  static const Color darkCard = Color(0xFF1A2733);
  static const Color darkCardLight = Color(0xFF243442);
  static const Color textLight = Color(0xFFFAFAFA);
  static const Color textMuted = Color(0xFFB0BEC5);
  static const Color textDark = Color(0xFF263238);
  static const Color divider = Color(0xFF2C3E50);

  // ── Category Colors ──
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return softBlue;
      case 'workshop':
        return mint;
      case 'cultural':
        return lavender;
      case 'career':
        return coral;
      case 'academic':
        return const Color(0xFFFFD54F);
      case 'research':
        return const Color(0xFF4DD0E1);
      case 'creative':
        return const Color(0xFFFF8A65);
      case 'business':
        return const Color(0xFFA5D6A7);
      case 'facility':
        return const Color(0xFF90CAF9);
      case 'opportunity':
        return mint;
      case 'notice':
        return const Color(0xFFFFCC80);
      default:
        return softBlue;
    }
  }

  // ── Priority Colors ──
  static Color priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return coral;
      case 'normal':
        return softBlue;
      case 'low':
        return textMuted;
      default:
        return softBlue;
    }
  }

  // ── Dark Theme ──
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        primary: deepTeal,
        secondary: softBlue,
        tertiary: coral,
        surface: darkCard,
        error: coral,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textLight,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: divider.withValues(alpha: 0.3)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: divider.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: deepTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: coral),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.7)),
        labelStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: textLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepTeal,
          side: const BorderSide(color: deepTeal),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: softBlue,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCardLight,
        selectedColor: deepTeal,
        labelStyle: const TextStyle(fontSize: 13, color: textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: divider.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: deepTeal,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: coral,
        foregroundColor: textLight,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCardLight,
        contentTextStyle: const TextStyle(color: textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: divider.withValues(alpha: 0.3),
        thickness: 1,
      ),
    );
  }

  // ── Light Theme ──
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: warmCream,
      colorScheme: const ColorScheme.light(
        primary: deepTeal,
        secondary: softBlue,
        tertiary: coral,
        surface: Colors.white,
        error: coral,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
    );
  }
}
