import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get _baseFont => GoogleFonts.inter(); // Using Inter as clean modern sans-serif

  // Display 32
  static TextStyle display = _baseFont.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Title 24
  static TextStyle title = _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Heading 20
  static TextStyle heading = _baseFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body 16
  static TextStyle body = _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Caption 14
  static TextStyle caption = _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
