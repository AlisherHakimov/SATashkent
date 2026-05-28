import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Display (Hero Titles)
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // Headings
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 16,
    height: 1.375,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Small Text
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle overline = GoogleFonts.inter(
    fontSize: 10,
    height: 1.4,
    fontWeight: FontWeight.w600,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  ).copyWith(
    textBaseline: TextBaseline.alphabetic,
  );

  // Button Text
  static TextStyle buttonLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textInverse,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textInverse,
  );

  // Special Styles
  static TextStyle pronunciation = GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlue,
    fontStyle: FontStyle.italic,
  );

  static TextStyle uzbekText = GoogleFonts.inter(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
  );

  static TextStyle exampleText = GoogleFonts.inter(
    fontSize: 14,
    height: 1.57,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontStyle: FontStyle.italic,
  );

  // Dark Theme Variants
  static TextStyle displayLargeDark = displayLarge.copyWith(
    color: AppColors.textDarkPrimary,
  );

  static TextStyle h1Dark = h1.copyWith(
    color: AppColors.textDarkPrimary,
  );

  static TextStyle h2Dark = h2.copyWith(
    color: AppColors.textDarkPrimary,
  );

  static TextStyle bodyDark = body.copyWith(
    color: AppColors.textDarkPrimary,
  );

  static TextStyle captionDark = caption.copyWith(
    color: AppColors.textDarkSecondary,
  );

  // Helper method to get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Private constructor
  AppTextStyles._();
}
