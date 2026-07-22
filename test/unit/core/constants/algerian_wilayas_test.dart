import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/core/constants/algerian_wilayas.dart';

void main() {
  group('algerianWilayas', () {
    test('contains exactly 69 wilayas', () {
      expect(algerianWilayas.length, equals(69));
    });

    test('contains major known wilayas', () {
      expect(algerianWilayas, contains('الجزائر'));
      expect(algerianWilayas, contains('وهران'));
      expect(algerianWilayas, contains('قسنطينة'));
      expect(algerianWilayas, contains('آفلو'));
      expect(algerianWilayas, contains('مسعد'));
    });

    test('has no duplicate entries', () {
      expect(algerianWilayas.toSet().length, equals(algerianWilayas.length));
    });
  });

  group('filterWilayas', () {
    test('returns all wilayas when query is empty', () {
      expect(filterWilayas('').length, equals(69));
    });

    test('filters by prefix including ال', () {
      final results = filterWilayas('الجزا');
      expect(results, contains('الجزائر'));
      expect(results, isNot(contains('وهران')));
    });

    test('filters when user omits ال prefix', () {
      final results = filterWilayas('جزائر');
      expect(results, contains('الجزائر'));
    });

    test('returns empty list when no match', () {
      expect(filterWilayas('xyz'), isEmpty);
    });

    test('is case and whitespace tolerant for empty query', () {
      expect(filterWilayas('   ').length, equals(69));
    });
  });

  group('isValidWilaya', () {
    test('accepts a wilaya from the list', () {
      expect(isValidWilaya('الجزائر'), isTrue);
    });

    test('rejects unknown values', () {
      expect(isValidWilaya('Unknown'), isFalse);
      expect(isValidWilaya(null), isFalse);
      expect(isValidWilaya(''), isFalse);
    });
  });
}
