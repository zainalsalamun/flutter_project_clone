import 'package:flutter/material.dart';

class LuminaThemeColors {
  final bool isDark;
  final Color background;
  final Color cardBackground;
  final Color cardBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color navBarBackground;
  final Color navBarBorder;
  final Color inactiveIcon;
  final Color modalBackground;
  final Color pillBackground;
  final Color subtleBackground;

  const LuminaThemeColors({
    required this.isDark,
    required this.background,
    required this.cardBackground,
    required this.cardBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.navBarBackground,
    required this.navBarBorder,
    required this.inactiveIcon,
    required this.modalBackground,
    required this.pillBackground,
    required this.subtleBackground,
  });

  static const dark = LuminaThemeColors(
    isDark: true,
    background: Color(0xFF1E1F28),
    cardBackground: Color(0xFF2A2D3A),
    cardBorder: Color(0x1FFFFFFF),
    primaryText: Colors.white,
    secondaryText: Color(0x99FFFFFF),
    navBarBackground: Color(0xFF1E1F28),
    navBarBorder: Color(0x14FFFFFF),
    inactiveIcon: Color(0x99FFFFFF),
    modalBackground: Color(0xFF1E1F28),
    pillBackground: Color(0xFF2A2D3A),
    subtleBackground: Color(0x1FFFFFFF),
  );

  static const light = LuminaThemeColors(
    isDark: false,
    background: Color(0xFFF1F5F9), // Slate 100
    cardBackground: Colors.white,
    cardBorder: Color(0xFFE2E8F0), // Slate 200
    primaryText: Color(0xFF0F172A), // Slate 900
    secondaryText: Color(0xFF64748B), // Slate 500
    navBarBackground: Colors.white,
    navBarBorder: Color(0xFFE2E8F0),
    inactiveIcon: Color(0xFF94A3B8), // Slate 400
    modalBackground: Colors.white,
    pillBackground: Color(0xFFE2E8F0),
    subtleBackground: Color(0xFFF8FAFC),
  );
}

class LuminaThemeScope extends InheritedWidget {
  final LuminaThemeColors colors;
  final bool isDark;
  final VoidCallback onToggleTheme;

  const LuminaThemeScope({
    super.key,
    required this.colors,
    required this.isDark,
    required this.onToggleTheme,
    required super.child,
  });

  static LuminaThemeScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LuminaThemeScope>();
    assert(result != null, 'No LuminaThemeScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LuminaThemeScope oldWidget) {
    return isDark != oldWidget.isDark || colors != oldWidget.colors;
  }
}
