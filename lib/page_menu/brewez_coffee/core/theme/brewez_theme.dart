import 'package:flutter/material.dart';

class BrewezTheme {
  // Brand Colors
  static const Color primary = Color(0xFFC67C4E);
  static const Color primaryDark = Color(0xFF9E592E);
  static const Color primaryLight = Color(0xFFEDCBB1);
  static const Color espresso = Color(0xFF311B0E);
  static const Color darkCoffee = Color(0xFF4B2E1E);
  static const Color milkFoam = Color(0xFFFFF3E0);
  static const Color caramel = Color(0xFFD49B55);
  static const Color icedBlue = Color(0xFF5AC8FA);
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color textMuted = Color(0xFF8D8D8D);
  static const Color accentWarm = Color(0xFFEFE8E3);

  // Gradients
  static const LinearGradient warmCoffeeGradient = LinearGradient(
    colors: [Color(0xFFC67C4E), Color(0xFF8E4E28)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liquidEspressoGradient = LinearGradient(
    colors: [Color(0xFF633A1F), Color(0xFF381E10)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient icedGradient = LinearGradient(
    colors: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.35),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}
