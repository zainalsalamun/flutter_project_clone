import 'package:flutter/material.dart';

/// Centralized Color System for the Device Diagnostics Module.
/// Eliminates hardcoded Color() instances across diagnostics pages and widgets.
class DiagnosticsColors {
  DiagnosticsColors._();

  // --- Brand & Primary Accents (Sky Blue) ---
  static const Color primary = Color(0xFF0284C7);
  static const Color primaryDark = Color(0xFF0369A1);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryBg = Color(0xFFF0F9FF);
  static const Color primaryBorder = Color(0xFFBAE6FD);
  static const Color primarySubtle = Color(0xFFE0F2FE);

  // --- Danger / Threat / Overheat / Alert (Red) ---
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDark = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFF87171);
  static const Color dangerBorder = Color(0xFFFCA5A5);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color dangerSubtle = Color(0xFFFEE2E2);

  // --- Warning / Notice / Caution / Warm (Amber) ---
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningSubtle = Color(0xFFFEF3C7);

  // --- Success / Good / Online / Healthy (Emerald & Green) ---
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF16A34A);
  static const Color successLight = Color(0xFF34D399);
  static const Color successBorder = Color(0xFF86EFAC);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color successSubtle = Color(0xFFDCFCE7);

  // --- Info / Telemetry Secondary (Indigo) ---
  static const Color info = Color(0xFF6366F1);
  static const Color infoDark = Color(0xFF4F46E5);
  static const Color infoLight = Color(0xFF818CF8);
  static const Color infoBorder = Color(0xFFC7D2FE);
  static const Color infoBg = Color(0xFFEEF2FF);
  static const Color infoSubtle = Color(0xFFE0E7FF);

  // --- Purple / Accent Violet ---
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleDark = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFA78BFA);
  static const Color purpleBorder = Color(0xFFDDD6FE);
  static const Color purpleBg = Color(0xFFF5F3FF);

  // --- Pink / Storage Accent ---
  static const Color pink = Color(0xFFEC4899);
  static const Color pinkDark = Color(0xFFDB2777);
  static const Color pinkLight = Color(0xFFF472B6);
  static const Color pinkBorder = Color(0xFFFBCFE8);
  static const Color pinkBg = Color(0xFFFDF2F8);

  // --- Teal / Cyan Accent ---
  static const Color teal = Color(0xFF0D9488);
  static const Color tealDark = Color(0xFF0F766E);
  static const Color tealLight = Color(0xFF2DD4BF);
  static const Color tealBorder = Color(0xFF99F6E4);
  static const Color tealBg = Color(0xFFF0FDFA);

  // --- Neutral & Slate Palette ---
  static const Color white = Colors.white;
  static const Color pageBg = Color(0xFFF8FAFC);
  static const Color cardBg = Colors.white;
  static const Color surface = Color(0xFFF1F5F9);
  static const Color surfaceSubtle = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFF1F5F9);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textSubtle = Color(0xFF64748B);
  static const Color textDark = Color(0xFF1E293B);

  // --- Dark Mode / Console Surfaces ---
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color deepNavy = Color(0xFF0B1329);
  static const Color terminalBg = Color(0xFF0B1120);

  // --- Pre-packaged Status Pairs ---
  static const DiagnosticsStatusPair statusDanger = DiagnosticsStatusPair.danger;
  static const DiagnosticsStatusPair statusWarning = DiagnosticsStatusPair.warning;
  static const DiagnosticsStatusPair statusSuccess = DiagnosticsStatusPair.success;
  static const DiagnosticsStatusPair statusInfo = DiagnosticsStatusPair.info;
  static const DiagnosticsStatusPair statusPrimary = DiagnosticsStatusPair.primary;
  static const DiagnosticsStatusPair statusPurple = DiagnosticsStatusPair.purple;
  static const DiagnosticsStatusPair statusPink = DiagnosticsStatusPair.pink;
  static const DiagnosticsStatusPair statusTeal = DiagnosticsStatusPair.teal;
}

/// A structured model for paired status badges, notices, and indicators.
class DiagnosticsStatusPair {
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const DiagnosticsStatusPair({
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });

  /// Danger / Overheat / Alert (Red pairing)
  static const DiagnosticsStatusPair danger = DiagnosticsStatusPair(
    color: DiagnosticsColors.danger,
    bgColor: DiagnosticsColors.dangerBg,
    borderColor: DiagnosticsColors.dangerBorder,
    textColor: DiagnosticsColors.dangerDark,
  );

  /// Warning / Caution / Warm (Amber pairing)
  static const DiagnosticsStatusPair warning = DiagnosticsStatusPair(
    color: DiagnosticsColors.warning,
    bgColor: DiagnosticsColors.warningBg,
    borderColor: DiagnosticsColors.warningBorder,
    textColor: DiagnosticsColors.warningDark,
  );

  /// Success / Healthy / Active (Green pairing)
  static const DiagnosticsStatusPair success = DiagnosticsStatusPair(
    color: DiagnosticsColors.success,
    bgColor: DiagnosticsColors.successBg,
    borderColor: DiagnosticsColors.successBorder,
    textColor: DiagnosticsColors.successDark,
  );

  /// Info / Telemetry (Indigo pairing)
  static const DiagnosticsStatusPair info = DiagnosticsStatusPair(
    color: DiagnosticsColors.info,
    bgColor: DiagnosticsColors.infoBg,
    borderColor: DiagnosticsColors.infoBorder,
    textColor: DiagnosticsColors.infoDark,
  );

  /// Primary / Brand (Sky Blue pairing)
  static const DiagnosticsStatusPair primary = DiagnosticsStatusPair(
    color: DiagnosticsColors.primary,
    bgColor: DiagnosticsColors.primaryBg,
    borderColor: DiagnosticsColors.primaryBorder,
    textColor: DiagnosticsColors.primaryDark,
  );

  /// Purple / AI / Security (Violet pairing)
  static const DiagnosticsStatusPair purple = DiagnosticsStatusPair(
    color: DiagnosticsColors.purple,
    bgColor: DiagnosticsColors.purpleBg,
    borderColor: DiagnosticsColors.purpleBorder,
    textColor: DiagnosticsColors.purpleDark,
  );

  /// Pink / Storage (Pink pairing)
  static const DiagnosticsStatusPair pink = DiagnosticsStatusPair(
    color: DiagnosticsColors.pink,
    bgColor: DiagnosticsColors.pinkBg,
    borderColor: DiagnosticsColors.pinkBorder,
    textColor: DiagnosticsColors.pinkDark,
  );

  /// Teal / Sensors (Teal pairing)
  static const DiagnosticsStatusPair teal = DiagnosticsStatusPair(
    color: DiagnosticsColors.teal,
    bgColor: DiagnosticsColors.tealBg,
    borderColor: DiagnosticsColors.tealBorder,
    textColor: DiagnosticsColors.tealDark,
  );
}
