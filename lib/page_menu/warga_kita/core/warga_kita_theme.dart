import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WargaKitaTheme {
  // Brand & Palette Colors (from design specification)
  static const Color primary = Color(0xFF005D42);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF047857);
  static const Color onPrimaryContainer = Color(0xFF9FFDD3);
  static const Color inversePrimary = Color(0xFF7BD8B1);

  static const Color secondary = Color(0xFF006C49);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color onSecondaryContainer = Color(0xFF00714D);

  static const Color tertiary = Color(0xFFA60418); // Emergency Crimson
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFC9282D);
  static const Color onTertiaryContainer = Color(0xFFFFE4E1);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);

  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF3E4943);
  static const Color inverseSurface = Color(0xFF283044);
  static const Color inverseOnSurface = Color(0xFFEEF0FF);

  static const Color outline = Color(0xFF6E7A73);
  static const Color outlineVariant = Color(0xFFBDC9C1);

  // Civic Semantic Accents
  static const Color mintTint = Color(0xFFECFDF5);
  static const Color mintBorder = Color(0xFFA7F3D0);
  static const Color mintText = Color(0xFF047857);

  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color emeraldDark = Color(0xFF065F46);

  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFFB45309);

  static const Color infoBlue = Color(0xFF0284C7);
  static const Color infoBlueBg = Color(0xFFE0F2FE);
  static const Color infoBlueText = Color(0xFF0369A1);

  static const Color purpleAccent = Color(0xFF7C3AED);
  static const Color purpleBg = Color(0xFFEDE9FE);

  static const Color sosCardBg = Color(0xFFFFEBEB);
  static const Color sosCardBorder = Color(0xFFFFCDD2);
  static const Color sosButtonBg = Color(0xFF991B1B);
  static const Color crimsonSos = Color(0xFF991B1B);
  static const Color mintContainer = Color(0xFF6CF8BB);

  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF94A3B8);

  // Shadows
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  static final List<BoxShadow> modalShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> sosShadow = [
    BoxShadow(
      color: const Color(0xFFEF4444).withValues(alpha: 0.25),
      blurRadius: 28,
      offset: const Offset(0, 12),
      spreadRadius: 2,
    ),
  ];

  static final List<BoxShadow> kasCardShadow = [
    BoxShadow(
      color: const Color(0xFF047857).withValues(alpha: 0.28),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Typography Helper using Plus Jakarta Sans
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

  // Common Text Styles
  static TextStyle get headlineXL => font(fontSize: 28, fontWeight: FontWeight.w800, height: 1.25, letterSpacing: -0.5);
  static TextStyle get headlineLG => font(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3, letterSpacing: -0.4);
  static TextStyle get headlineMD => font(fontSize: 20, fontWeight: FontWeight.w700, height: 1.35, letterSpacing: -0.3);
  static TextStyle get headlineSM => font(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get bodyLG => font(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMD => font(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);
  static TextStyle get bodySM => font(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get labelLG => font(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get labelMD => font(fontSize: 12, fontWeight: FontWeight.w600, height: 1.25);
  static TextStyle get labelSM => font(fontSize: 10, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 0.3);
}
