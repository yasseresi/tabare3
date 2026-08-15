import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/datasources/notification_rest_data_source.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _res(String path, Map<String, dynamic> body) =>
    Response(requestOptions: RequestOptions(path: path), statusCode: 200, data: body);

Map<String, dynamic> _notif({int id = 795, bool read = false}) => {
  'id': id,
  'title': 'شكرًا لتبرعك!',
  'body': 'تم تسجيل تبرعك',
  'notification_type': 'donation',
  'entity_type': 'donation',
  'entity_id': 73,
  'is_read': read,
  'read_at': null,
  'created_at': '2026-08-14T23:04:31Z',
};

void main() {
  late MockDio dio;
  late NotificationRestDataSource source;

  setUp(() {
    dio = MockDio();
    when(() => dio.options).thenReturn(BaseOptions(baseUrl: 'https://x/api/v1'));
    source = NotificationRestDataSource(dio);
  });

  test('listNotifications maps the paginated recipient rows', () async {
    when(() => dio.get<Map<String, dynamic>>(RestPaths.notifications)).thenAnswer(
      (_) async => _res(RestPaths.notifications, {'next': null, 'results': [_notif()]}),
    );

    final list = await source.listNotifications();
    final n = list.single;
    expect(n.id, '795');
    expect(n.type, 'donation'); // notification_type
    expect(n.refId, '73'); // entity_id
    expect(n.refType, 'donation'); // entity_type
    expect(n.isRead, isFalse);
  });

  test('markAsRead POSTs to mark-read and maps the result', () async {
    when(() => dio.post<Map<String, dynamic>>(RestPaths.notificationMarkRead('795')))
        .thenAnswer((_) async => _res(RestPaths.notificationMarkRead('795'), _notif(read: true)));

    final n = await source.markAsRead('795');
    expect(n.isRead, isTrue);
    verify(() => dio.post<Map<String, dynamic>>(RestPaths.notificationMarkRead('795'))).called(1);
  });

  test('watchNotifications emits immediately, polls, and stops on cancel', () {
    var calls = 0;
    when(() => dio.get<Map<String, dynamic>>(RestPaths.notifications)).thenAnswer((_) async {
      calls++;
      return _res(RestPaths.notifications, {'next': null, 'results': [_notif()]});
    });

    fakeAsync((async) {
      final emitted = <int>[];
      final sub = source.watchNotifications().listen((list) => emitted.add(list.length));

      async.flushMicrotasks(); // immediate first fetch
      expect(calls, 1);
      expect(emitted, [1]);

      async.elapse(const Duration(seconds: 30));
      expect(calls, 2); // one poll

      async.elapse(const Duration(seconds: 30));
      expect(calls, 3);

      sub.cancel();
      async.elapse(const Duration(seconds: 120));
      expect(calls, 3); // polling stopped after cancel
    });
  });
}
