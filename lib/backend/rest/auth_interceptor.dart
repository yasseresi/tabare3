import 'package:dio/dio.dart';

import 'constants/rest_paths.dart';
import 'token_store.dart';

const String authorizationHeader = 'authorization';

/// Signs every request with the stored access token and transparently refreshes
/// it once on a `401`.
///
/// Uses [QueuedInterceptor] so that a burst of requests hitting an expired token
/// triggers a single refresh, not one per request. The refresh and the retry go
/// through a **separate** [Dio] that carries no [AuthInterceptor], so a failing
/// refresh can never recurse into itself.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStore tokenStore,
    required Dio refreshClient,
    this.onAuthExpired,
  }) : _tokenStore = tokenStore,
       _refreshClient = refreshClient;

  final TokenStore _tokenStore;

  /// Bare client (no auth interceptor) used both to refresh and to replay the
  /// original request with the new token.
  final Dio _refreshClient;

  /// Called when the refresh itself fails — the session is over.
  final void Function()? onAuthExpired;

  static const String _retriedFlag = 'auth_retry';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final access = await _tokenStore.readAccess();
    if (access != null && access.isNotEmpty) {
      options.headers[authorizationHeader] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = request.path == RestPaths.refresh;
    final alreadyRetried = request.extra[_retriedFlag] == true;

    if (!isUnauthorized || isRefreshCall || alreadyRetried) {
      return handler.next(err);
    }

    final refresh = await _tokenStore.readRefresh();
    if (refresh == null || refresh.isEmpty) {
      await _expire();
      return handler.next(err);
    }

    try {
      final response = await _refreshClient.post<Map<String, dynamic>>(
        RestPaths.refresh,
        data: {'refresh': refresh},
      );
      final data = response.data ?? const {};
      final newAccess = data['access'] as String?;
      if (newAccess == null || newAccess.isEmpty) {
        await _expire();
        return handler.next(err);
      }
      // SimpleJWT rotation may return a fresh refresh token; keep the old one
      // when it does not.
      final newRefresh = data['refresh'] as String? ?? refresh;
      await _tokenStore.save(access: newAccess, refresh: newRefresh);

      final retried = await _replay(request, newAccess);
      return handler.resolve(retried);
    } on DioException {
      await _expire();
      return handler.next(err);
    }
  }

  Future<Response<dynamic>> _replay(
    RequestOptions request,
    String access,
  ) {
    final headers = Map<String, dynamic>.from(request.headers)
      ..[authorizationHeader] = 'Bearer $access';
    return _refreshClient.request<dynamic>(
      request.path,
      data: request.data,
      queryParameters: request.queryParameters,
      cancelToken: request.cancelToken,
      options: Options(
        method: request.method,
        headers: headers,
        responseType: request.responseType,
        contentType: request.contentType,
        extra: {...request.extra, _retriedFlag: true},
      ),
    );
  }

  Future<void> _expire() async {
    await _tokenStore.clear();
    onAuthExpired?.call();
  }
}
