import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aura_colors.dart';

class AuraTypography {
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AuraColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AuraColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AuraColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AuraColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AuraColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AuraColors.textMuted,
  );

  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AuraColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AuraColors.textMuted,
    letterSpacing: 0.2,
  );
}
