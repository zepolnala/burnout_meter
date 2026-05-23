import 'package:flutter/material.dart';

class AppTheme {
  // Premium Curated Color Palette (Wellness HSL-equivalent Hex Codes)
  static const Color darkSlate = Color(0xFF0F172A); // Background primary dark
  static const Color cardSlate = Color(0xFF1E293B); // Card backgrounds dark
  static const Color activeGreen = Color(0xFF10B981); // Emerald (Healthy/Consented)
  static const Color activeOrange = Color(0xFFF59E0B); // Amber (Warning)
  static const Color activeRed = Color(0xFFEF4444); // Rose (High Burnout Risk)
  static const Color accentTeal = Color(0xFF06B6D4); // Cyan (Actions/UI Accent)
  static const Color softText = Color(0xFF94A3B8); // Muted slate text
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: darkSlate,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkSlate, letterSpacing: -1),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkSlate, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkSlate),
        bodyLarge: TextStyle(fontSize: 16, color: darkSlate),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF475569)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkSlate,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: darkSlate,
      cardTheme: const CardThemeData(
        color: cardSlate,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF334155)),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: softText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: darkSlate,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Utility to get status color based on 0-100 Burnout score
  static Color getScoreColor(double score) {
    if (score < 40) return activeGreen;   // Rested / Healthy
    if (score < 75) return activeOrange;  // Moderate Stress
    return activeRed;                    // Burnout Alert!
  }
}
