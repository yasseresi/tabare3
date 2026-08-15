import 'dart:ui';

enum LanguageType { english, arabic }

const String assetPathLocalisations = 'assets/translations';
const String arabic = 'ar';
const String english = 'en';
const Locale arabicLocale = Locale('ar');
const Locale englishLocale = Locale('en');

extension LanguageTypeExtension on LanguageType {
  String getValue() => this == LanguageType.english ? english : arabic;
}
