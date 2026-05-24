import 'package:flutter/material.dart';

class GlossyTheme {
  // Brand Colors
  static const Color darkCanvas = Color(0xFF0C0714);
  static const Color lightCanvas = Color(0xFFF5F3F8); // Premium warm off-white/ivory
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentPurple = Color(0xFF651FFF);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentOrange = Color(0xFFFF7043);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color neonMagenta = Color(0xFFE040FB);

  // Theme Getters
  static Color getBackgroundColor(bool isDark) => isDark ? darkCanvas : lightCanvas;

  static Color getTextColor(bool isDark) => isDark ? Colors.white : const Color(0xFF1B132B);

  static Color getSubtextColor(bool isDark) => isDark ? Colors.white.withOpacity(0.55) : const Color(0xFF6B5E80);

  static Color getCardColor(bool isDark) => isDark ? Colors.transparent : Colors.white.withOpacity(0.25);

  static Gradient getCardGradient(bool isDark) {
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.03),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.58),
          Colors.white.withOpacity(0.32),
        ],
      );
    }
  }

  static Border getCardBorder(bool isDark) {
    if (isDark) {
      return Border.all(
        color: Colors.white.withOpacity(0.13),
        width: 1.2,
      );
    } else {
      return Border.all(
        color: Colors.white.withOpacity(0.45),
        width: 1.2,
      );
    }
  }

  static List<BoxShadow> getCardShadow(bool isDark) {
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: const Color(0xFF6B5E80).withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
    }
  }

  // Gradient Presets (Vibrant accents remain glowing in both themes)
  static const Gradient primaryAiGradient = LinearGradient(
    colors: [accentPink, accentPurple, accentCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleBlueGradient = LinearGradient(
    colors: [neonMagenta, Color(0xFF3F51B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient orangeRedGradient = LinearGradient(
    colors: [accentOrange, accentRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient checkoutGradient = LinearGradient(
    colors: [accentOrange, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Custom shadows
  static List<BoxShadow> premiumGlowShadow(Color color, {double radius = 12.0}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.35),
        blurRadius: radius,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
