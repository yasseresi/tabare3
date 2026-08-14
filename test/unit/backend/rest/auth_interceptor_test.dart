import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/auth_interceptor.dart';
import 'package:tabare3/backend/rest/constants/rest_paths.dart';
import 'package:tabare3/backend/rest/token_store.dart';

/// In-memory [TokenStore] so tests don't touch the platform keystore.
class FakeTokenStore implements TokenStore {
  FakeTokenStore({this.access, this.refresh});
  String? access;
  String? refresh;
  bool cleared = false;

  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<String?> readAccess() async => access;

  @override
  Future<String?> readRefresh() async => refresh;

  @override
  Future<void> clear() async {
    cleared = true;
    access = null;
    refresh = null;
  }
}

/// Adapter that returns a queued response per matching predicate.
class RoutingAdapter implements HttpClientAdapter {
  final List<_Route> _routes = [];

  void on(bool Function(RequestOptions) match, int status, Map<String, dynamic> body) {
    _routes.add(_Route(match, status, body));
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    for (final r in _routes) {
      if (r.match(options)) {
        return ResponseBody.fromString(
          jsonEncode(r.body),
          r.status,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }
    }
    return ResponseBody.fromString('{}', 404);
  }

  @override
  void close({bool force = false}) {}
}

class _Route {
  _Route(this.match, this.status, this.body);
  final bool Function(RequestOptions) match;
  final int status;
  final Map<String, dynamic> body;
}

void main() {
  Dio buildProtected(RoutingAdapter adapter, AuthInterceptor interceptor) {
    final dio = Dio(BaseOptions(baseUrl: 'https://x/api/v1'))
      ..httpClientAdapter = adapter
      ..interceptors.add(interceptor);
    return dio;
  }

  test('refreshes on 401 then retries the original request', () async {
    final store = FakeTokenStore(access: 'expired', refresh: 'r1');

    final refreshAdapter = RoutingAdapter()
      ..on((o) => o.path == RestPaths.refresh, 200, {'access': 'a2'})
      ..on((o) => o.path == RestPaths.profile, 200, {'ok': true});
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://x/api/v1'))
      ..httpClientAdapter = refreshAdapter;

    final protectedAdapter = RoutingAdapter()
      ..on((o) => o.path == RestPaths.profile, 401, {'detail': 'expired'});
    final interceptor = AuthInterceptor(
      tokenStore: store,
      refreshClient: refreshClient,
    );
    final dio = buildProtected(protectedAdapter, interceptor);

    final res = await dio.get<dynamic>(RestPaths.profile);

    expect(res.statusCode, 200);
    expect((res.data as Map)['ok'], true);
    expect(store.access, 'a2'); // new token persisted
  });

  test('clears tokens and signals expiry when refresh fails', () async {
    final store = FakeTokenStore(access: 'expired', refresh: 'r1');
    var expired = false;

    final refreshAdapter = RoutingAdapter()
      ..on((o) => o.path == RestPaths.refresh, 401, {'detail': 'invalid'});
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://x/api/v1'))
      ..httpClientAdapter = refreshAdapter;

    final protectedAdapter = RoutingAdapter()
      ..on((o) => o.path == RestPaths.profile, 401, {'detail': 'expired'});
    final interceptor = AuthInterceptor(
      tokenStore: store,
      refreshClient: refreshClient,
      onAuthExpired: () => expired = true,
    );
    final dio = buildProtected(protectedAdapter, interceptor);

    await expectLater(
      dio.get<dynamic>(RestPaths.profile),
      throwsA(isA<DioException>()),
    );
    expect(store.cleared, isTrue);
    expect(expired, isTrue);
  });
}
