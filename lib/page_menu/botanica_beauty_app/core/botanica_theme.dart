import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotanicaTheme {
  // Brand Palette
  static const Color primary = Color(0xFF0F3E33);         // Deep Botanical Emerald
  static const Color primaryLight = Color(0xFF1B5E4F);    // Lighter Emerald
  static const Color primaryTint = Color(0xFFE6F3EF);     // Very Soft Mint
  
  static const Color secondary = Color(0xFF8B5CF6);       // Soft Lavender
  static const Color secondaryLight = Color(0xFFEDE9FE);  // Light Lavender Background
  
  static const Color accentRose = Color(0xFFF43F5E);      // Rose Pink (Wishlist active)
  static const Color accentAmber = Color(0xFFF59E0B);     // Rating Star Yellow
  
  static const Color discountTagBg = Color(0xFFFFE4E6);   // Discount Pill Fill
  static const Color discountTagText = Color(0xFFBE123C); // Discount Pill Text
  
  static const Color surface = Color(0xFFFAFAFC);         // Clean Canvas
  static const Color surfaceCard = Color(0xFFFFFFFF);     // White Card
  static const Color cardBorder = Color(0xFFE5E7EB);      // Subtle Border
  static const Color cardBorderLight = Color(0xFFF3F4F6);
  
  static const Color textPrimary = Color(0xFF111827);     // Slate 900
  static const Color textSecondary = Color(0xFF4B5563);   // Slate 600
  static const Color textTertiary = Color(0xFF9CA3AF);    // Slate 400
  static const Color textMuted = Color(0xFFD1D5DB);       // Slate 300

  // Soft Card Shadows
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> modalShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.12),
      blurRadius: 28,
      offset: const Offset(0, -6),
    ),
  ];

  // Typography Scale with Plus Jakarta Sans
  static TextStyle font({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: surface,
        primary: primary,
        secondary: secondary,
        error: accentRose,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
