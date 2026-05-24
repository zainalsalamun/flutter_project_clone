import 'package:flutter/material.dart';

class GlossyTheme {
  // Brand Colors
  static const Color darkCanvas = Color(0xFF0C0714);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentPurple = Color(0xFF651FFF);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentOrange = Color(0xFFFF7043);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color neonMagenta = Color(0xFFE040FB);

  // Gradient Presets
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
