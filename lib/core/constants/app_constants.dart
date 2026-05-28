class AppConstants {
  AppConstants._();

  static const String appName = 'SATashkent';
  static const String baseUrl = 'https://api.satashkent.uz';

  // Version
  static const int buildNumber = 1;
  static const String version = '1.0.0';
}


enum Language {
  uzbekLatin('uz', "O'zbek", '🇺🇿'),
  english('en', 'English', '🇬🇧');

  final String code;
  final String displayName;
  final String flag;

  const Language(this.code, this.displayName, this.flag);

  static Language fromCode(String code) {
    return Language.values.firstWhere(
      (l) => l.code == code,
      orElse: () => Language.uzbekLatin,
    );
  }
}
