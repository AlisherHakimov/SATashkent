import 'package:flutter/material.dart';


class AppHelpers {
  AppHelpers._();

  /// Snackbar ko'rsatish
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade700 : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Keyboard ni yopish
  static void hideKeyboard(BuildContext context) =>
      FocusScope.of(context).unfocus();

  /// SAT score bo'yicha daraja
  static String scoreLevel(int total) {
    if (total >= 1500) return 'Excellent 🏆';
    if (total >= 1300) return 'Great 🎯';
    if (total >= 1100) return 'Good 📈';
    if (total >= 900) return 'Average 📚';
    return 'Keep going 💪';
  }

  /// "Alisher Hakimov" → "AH"
  static String initials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
