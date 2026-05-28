import 'package:flutter/services.dart';

class UzPhoneFormatter extends TextInputFormatter {
  static const prefix = '+998 ';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String raw = newValue.text;
    if (!raw.startsWith(prefix)) raw = prefix;

    final digits = raw.substring(prefix.length).replaceAll(RegExp(r'[^\d]'), '');
    final d = digits.length > 9 ? digits.substring(0, 9) : digits;

    final buf = StringBuffer(prefix);
    for (int i = 0; i < d.length; i++) {
      if (i == 2) buf.write(' ');
      if (i == 5) buf.write('-');
      if (i == 7) buf.write('-');
      buf.write(d[i]);
    }

    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static String toApiFormat(String formatted) =>
      formatted.replaceAll(RegExp(r'[\s\-]'), '');

  static bool isComplete(String value) => value.length == 17;
}

class ScoreFormatter {
  /// 1200 → "1,200"
  static String format(int score) {
    return score.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  /// 0.784 → "78.4%"
  static String accuracy(double value) => '${(value * 100).toStringAsFixed(1)}%';

  /// 620/800 → "77.5%"
  static String sectionPercent(int score, {int max = 800}) =>
      '${(score / max * 100).toStringAsFixed(0)}%';
}

class TimeFormatter {
  /// 90 seconds → "1:30"
  static String mmss(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// 90 seconds → "1 min 30 sec"
  static String verbose(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    if (m == 0) return '$s sec';
    if (s == 0) return '$m min';
    return '$m min $s sec';
  }
}
