import 'package:flutter/material.dart';

class AiDashboardTheme {
  // Dark futuristic theme colors
  static const Color background = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1F2937);
  static const Color surfaceCard = Color(0xFF161E2E);
  static const Color border = Color(0xFF374151);
  static const Color borderLight = Color(0xFF2D3748);

  // Accents
  static const Color primary = Color(0xFF6366F1); // Indigo AI
  static const Color primaryGlow = Color(0xFF818CF8);
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Rose Red

  // Text colors
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardBorderGradient = LinearGradient(
    colors: [Color(0xFF4B5563), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration cardDecoration({Color? customBg, Border? customBorder}) {
    return BoxDecoration(
      color: customBg ?? surfaceCard,
      borderRadius: BorderRadius.circular(16),
      border: customBorder ?? Border.all(color: borderLight.withOpacity(0.6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
