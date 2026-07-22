import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/validators/validators.dart';

void main() {
  group('validateCity', () {
    test('returns required error for empty value', () {
      expect(validateCity(null), isNotNull);
      expect(validateCity(''), isNotNull);
      expect(validateCity('   '), isNotNull);
    });

    test('returns invalid error for unknown city', () {
      expect(validateCity('Unknown City'), isNotNull);
      expect(validateCity('مدينة غير موجودة'), isNotNull);
    });

    test('returns null for a valid Algerian wilaya', () {
      expect(validateCity('الجزائر'), isNull);
      expect(validateCity('وهران'), isNull);
      expect(validateCity('قسنطينة'), isNull);
      expect(validateCity('آفلو'), isNull);
      expect(validateCity('مسعد'), isNull);
    });

    test('trims whitespace before validating', () {
      expect(validateCity('  الجزائر  '), isNull);
    });
  });
}
