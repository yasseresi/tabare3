import 'dart:ui';

enum LanguageType { ENGLISH, ARABIC }

const String assetPathLocalisations = 'assets/translations';
const String arabic = 'ar';
const String english = 'en';
const Locale arabicLocale = Locale('ar');
const Locale englishLocale = Locale('en');

extension LanguageTypeExtension on LanguageType {
  String getValue() => this == LanguageType.ENGLISH ? english : arabic;
}
