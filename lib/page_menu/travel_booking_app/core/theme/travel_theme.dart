import 'package:flutter/material.dart';

class TravelTheme {
  TravelTheme._();

  // Primary brand colors
  static const Color primary = Color(0xFF0F4C81); // Classic Deep Ocean Navy
  static const Color primaryLight = Color(0xFF1E88E5); // Sky Blue
  static const Color accent = Color(0xFFFF6F59); // Sunset Coral
  static const Color accentGold = Color(0xFFFFB300); // Golden Sun
  static const Color emerald = Color(0xFF10B981); // Emerald Success

  // Neutrals
  static const Color dark = Color(0xFF141E28);
  static const Color darkMuted = Color(0xFF4A5568);
  static const Color muted = Color(0xFF7E8B9B);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF6F8FA);
  static const Color border = Color(0xFFE2E8F0);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x90000000),
      Color(0xE6141E28),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F4C81),
      Color(0xFF1E88E5),
    ],
  );

  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6F59),
      Color(0xFFFF9472),
    ],
  );

  static const LinearGradient ticketGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B2A4A),
      Color(0xFF2C3E6B),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: surface,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: dark),
        titleTextStyle: TextStyle(
          color: dark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
