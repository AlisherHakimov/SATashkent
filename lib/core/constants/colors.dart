import 'package:flutter/material.dart';

/// Color palette for SATashkent app.
/// Brand identity comes from the website (https://1600.satashkent.uz).
/// Primary: a slightly brighter variant of the website's crimson #AA233B —
/// using #C42847 gives the same hue but feels lighter and more vibrant on screen.
/// Gradients go red → purple (beautiful contrast, not as heavy as red → dark navy).
class AppColors {
  AppColors._();

  /// #C42847 — vibrant crimson, brand-accurate but lighter than raw #AA233B
  static const Color primary = Color(0xFFC42847);

  /// #8B1A2F — deep crimson for pressed / dark accents
  static const Color primaryDark = Color(0xFF8B1A2F);

  /// Soft rose — used as chip/badge background (~8% opacity on white)
  static const Color primaryLight = Color(0xFFFDEDF0);

  static const Color primaryBlue = primary;
  static const Color primaryBlueDark = primaryDark;
  static const Color primaryBlueLight = primaryLight;

  /// #7C3AED — purple, used for English section & variety accents
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFF5F0FF);

  /// #10B981 — vibrant emerald green
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);

  /// #F59E0B — standard amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFF3CD);

  /// #EF4444 — bright red (distinct from primary crimson)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  /// #F59E0B used as gold for medals (same as warning amber for unity)
  static const Color gold = Color(0xFFEFBF04);

  /// Near-black — easier on eyes than pure #000000
  static const Color textPrimary = Color(0xFF111827);

  /// Medium gray — readable secondary labels
  static const Color textSecondary = Color(0xFF6B7280);

  /// Light gray-blue — for hints, placeholders, inactive elements
  static const Color textTertiary = Color(0xFF9CA3AF);

  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textLink = primary;

  // Dark theme text
  static const Color textDarkPrimary = Color(0xFFF9FAFB);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);

  static const Color bgPrimary = Color(0xFFFFFFFF); // Pure white — cards
  static const Color bgSecondary = Color(0xFFF9FAFB); // Very light gray — scaffold
  static const Color bgTertiary = Color(0xFFF3F4F6); // Chip / tag background

  static const Color bgDarkPrimary = Color(0xFF1F2937);
  static const Color bgDarkSecondary = Color(0xFF111827);
  static const Color bgDarkTertiary = Color(0xFF374151);

  static const Color borderLight = Color(0xFFE5E7EB); // Card borders
  static const Color borderMedium = Color(0xFFD1D5DB); // Input borders
  static const Color borderDark = Color(0xFF9CA3AF); // Strong dividers

  /// Active nav — authentic website brand red (#AA233B)
  static const Color navActive = Color(0xFFAA233B);

  /// Inactive nav — soft gray
  static const Color navInactive = Color(0xFF9CA3AF);

  /// Banner gradient: crimson → deep crimson (monochromatic red, matches brand)
  static const Color gradientStart = primary; // #C42847
  static const Color gradientEnd = primaryDark; // #8B1A2F

  /// Roadmap / progress gradient: emerald → teal
  static const Color gradientSuccessStart = success; // #10B981
  static const Color gradientSuccessEnd = Color(0xFF059669); // Forest green
}
