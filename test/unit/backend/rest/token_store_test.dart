import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/token_store.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;
  late SecureTokenStore store;

  setUp(() {
    storage = MockSecureStorage();
    store = SecureTokenStore(storage: storage);
  });

  test('save writes both tokens under stable keys', () async {
    when(
      () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});

    await store.save(access: 'a1', refresh: 'r1');

    verify(
      () => storage.write(key: SecureTokenStore.accessKey, value: 'a1'),
    ).called(1);
    verify(
      () => storage.write(key: SecureTokenStore.refreshKey, value: 'r1'),
    ).called(1);
  });

  test('readAccess / readRefresh return the stored values', () async {
    when(
      () => storage.read(key: SecureTokenStore.accessKey),
    ).thenAnswer((_) async => 'a1');
    when(
      () => storage.read(key: SecureTokenStore.refreshKey),
    ).thenAnswer((_) async => 'r1');

    expect(await store.readAccess(), 'a1');
    expect(await store.readRefresh(), 'r1');
  });

  test('clear deletes both tokens', () async {
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

    await store.clear();

    verify(() => storage.delete(key: SecureTokenStore.accessKey)).called(1);
    verify(() => storage.delete(key: SecureTokenStore.refreshKey)).called(1);
  });
}
