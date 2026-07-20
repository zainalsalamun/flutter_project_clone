import 'package:flutter/material.dart';

class GlossyMusicTheme {
  // Brand Colors
  static const Color darkCanvas = Color(0xFF080410);
  static const Color lightCanvas = Color(0xFFEBF0FA); // Frosted iceberg background
  
  // Neon accents
  static const Color neonPink = Color(0xFFFF2E93);
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonPurple = Color(0xFF9D00FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonOrange = Color(0xFFFF5E00);

  // Theme Helpers
  static Color getBackgroundColor(bool isDark) => isDark ? darkCanvas : lightCanvas;
  static Color getTextColor(bool isDark) => isDark ? Colors.white : const Color(0xFF140D26);
  static Color getSubtextColor(bool isDark) => isDark ? Colors.white.withOpacity(0.55) : const Color(0xFF5A4D78);
  static Color getCardColor(bool isDark) => isDark ? Colors.transparent : Colors.white.withOpacity(0.25);

  // Dynamic Card Styling
  static Gradient getCardGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.02),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.65),
          Colors.white.withOpacity(0.35),
        ],
      );
    }
  }

  static Border getCardBorder(bool isDark) {
    if (isDark) {
      return Border.all(
        color: Colors.white.withOpacity(0.12),
        width: 1.2,
      );
    } else {
      return Border.all(
        color: Colors.white.withOpacity(0.50),
        width: 1.2,
      );
    }
  }

  static List<BoxShadow> getCardShadow(bool isDark) {
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: const Color(0xFF5A4D78).withOpacity(0.07),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
    }
  }

  // Premium Neon Gradients
  static const Gradient cyberDawnGradient = LinearGradient(
    colors: [neonPink, neonPurple, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient electricOceanGradient = LinearGradient(
    colors: [Color(0xFF0052D4), Color(0xFF4364F7), neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient soundscapeRain = LinearGradient(
    colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient soundscapeWaves = LinearGradient(
    colors: [Color(0xFF02AAB0), Color(0xFF00CDAC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient soundscapeWind = LinearGradient(
    colors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient soundscapeSynth = LinearGradient(
    colors: [neonPink, Color(0xFF833ab4), neonOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Ambient Glow Effect
  static List<BoxShadow> premiumGlow(Color color, {double radius = 15.0, double opacity = 0.35}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: radius,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
