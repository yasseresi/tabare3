import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/reference/reference_models.dart';
import 'package:tabare3/backend/rest/reference/reference_remote_data_source.dart';
import 'package:tabare3/backend/rest/reference/reference_resolver.dart';

/// Counts calls so the caching contract can be asserted.
class FakeReferenceDataSource implements ReferenceRemoteDataSource {
  int wilayaCalls = 0;
  int bloodTypeCalls = 0;

  @override
  Future<List<WilayaRef>> listWilayas() async {
    wilayaCalls++;
    return const [
      WilayaRef(id: 1, code: '01', nameAr: 'أدرار', nameFr: 'Adrar', nameEn: 'Adrar'),
      WilayaRef(id: 16, code: '16', nameAr: 'الجزائر', nameFr: 'Alger', nameEn: 'Algiers'),
    ];
  }

  @override
  Future<List<BloodTypeRef>> listBloodTypes() async {
    bloodTypeCalls++;
    return const [
      BloodTypeRef(id: 7, label: 'O+'),
      BloodTypeRef(id: 8, label: 'O-'),
    ];
  }
}

void main() {
  late FakeReferenceDataSource source;
  late ReferenceResolver resolver;

  setUp(() {
    source = FakeReferenceDataSource();
    resolver = ReferenceResolver(source);
  });

  test('resolves a wilaya Arabic name to its backend id', () async {
    expect(await resolver.wilayaIdForName('الجزائر'), 16);
  });

  test('resolves a blood-type label to its (non-sequential) backend id', () async {
    expect(await resolver.bloodTypeIdForLabel('O+'), 7);
  });

  test('trims and ignores case/whitespace differences', () async {
    expect(await resolver.wilayaIdForName('  الجزائر '), 16);
    expect(await resolver.bloodTypeIdForLabel(' o+ '), 7);
  });

  test('returns null for an unknown value', () async {
    expect(await resolver.wilayaIdForName('غير موجود'), isNull);
    expect(await resolver.bloodTypeIdForLabel('Z+'), isNull);
  });

  test('caches each list after the first fetch', () async {
    await resolver.wilayaIdForName('أدرار');
    await resolver.wilayaIdForName('الجزائر');
    await resolver.bloodTypeIdForLabel('O+');
    await resolver.bloodTypeIdForLabel('O-');

    expect(source.wilayaCalls, 1);
    expect(source.bloodTypeCalls, 1);
  });
}
