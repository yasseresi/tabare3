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

  group('validateWeight', () {
    test('returns required error for empty value', () {
      expect(validateWeight(null), isNotNull);
      expect(validateWeight(''), isNotNull);
      expect(validateWeight('   '), isNotNull);
    });

    test('returns null for a plain numeric weight', () {
      expect(validateWeight('70'), isNull);
      expect(validateWeight('70.5'), isNull);
    });

    test('accepts a comma decimal separator', () {
      expect(validateWeight('70,5'), isNull);
    });

    test('rejects non-numeric input', () {
      expect(validateWeight('abc'), isNotNull);
      expect(validateWeight('7o'), isNotNull);
    });

    test('rejects values outside the human range', () {
      expect(validateWeight('0'), isNotNull);
      expect(validateWeight('-5'), isNotNull);
      expect(validateWeight('401'), isNotNull);
    });

    test('accepts the range boundaries', () {
      expect(validateWeight('1'), isNull);
      expect(validateWeight('400'), isNull);
    });
  });

  group('validateStrongPassword', () {
    test('returns required error for empty value', () {
      expect(validateStrongPassword(null), isNotNull);
      expect(validateStrongPassword(''), isNotNull);
    });

    test('rejects passwords shorter than 12 characters', () {
      expect(validateStrongPassword('Ab1!aaaa'), isNotNull);
    });

    test('rejects when a character class is missing', () {
      expect(validateStrongPassword('alllowercase1!'), isNotNull); // no upper
      expect(validateStrongPassword('ALLUPPERCASE1!'), isNotNull); // no lower
      expect(validateStrongPassword('NoDigitsHere!!'), isNotNull); // no digit
      expect(validateStrongPassword('NoSpecials1234'), isNotNull); // no symbol
    });

    test('accepts a long password spanning every class', () {
      expect(validateStrongPassword('Str0ng!Passw0rd'), isNull);
    });

    test('does not weaken login validatePassword (legacy 8-char stays valid)', () {
      expect(validatePassword('12345678'), isNull);
    });
  });

  group('national ID (18 digits)', () {
    test('isNationalIdValid accepts exactly 18 digits', () {
      expect(isNationalIdValid('123456789012345678'), isTrue);
      expect(isNationalIdValid('  123456789012345678  '), isTrue);
    });

    test('isNationalIdValid rejects wrong length or non-digits', () {
      expect(isNationalIdValid('12345678901234567'), isFalse); // 17
      expect(isNationalIdValid('1234567890123456789'), isFalse); // 19
      expect(isNationalIdValid('12345678901234567a'), isFalse);
    });

    test('validateNationalId requires a value and 18 digits', () {
      expect(validateNationalId(null), isNotNull);
      expect(validateNationalId('123'), isNotNull);
      expect(validateNationalId('123456789012345678'), isNull);
    });

    test('validateNationalIdOptional passes when blank but checks format', () {
      expect(validateNationalIdOptional(null), isNull);
      expect(validateNationalIdOptional(''), isNull);
      expect(validateNationalIdOptional('123'), isNotNull);
      expect(validateNationalIdOptional('123456789012345678'), isNull);
    });
  });
}
