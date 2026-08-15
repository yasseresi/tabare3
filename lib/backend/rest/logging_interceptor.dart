import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only request/response logger that never prints secrets.
///
/// The default dio [LogInterceptor] dumps raw headers and bodies — which for
/// this API means the `Authorization` bearer, login/register passwords, and the
/// `access`/`refresh` tokens in auth responses. This logger masks all of those
/// so shared debug output can't leak credentials. It is only added in debug
/// builds ([kReleaseMode] is false).
class RedactingLogInterceptor extends Interceptor {
  const RedactingLogInterceptor();

  static const _sensitiveKeys = {
    'password',
    'password_confirm',
    'access',
    'refresh',
    'token',
  };
  static const _mask = '***';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('→ ${options.method} ${options.uri}');
    final body = _redact(options.data);
    if (body != null) debugPrint('  body: $body');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint(
      '← ${response.statusCode} ${response.requestOptions.uri}',
    );
    final body = _redact(response.data);
    if (body != null) debugPrint('  body: $body');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '✗ ${err.response?.statusCode ?? err.type} ${err.requestOptions.uri}',
    );
    handler.next(err);
  }

  Object? _redact(Object? data) {
    if (data is Map) {
      return {
        for (final entry in data.entries)
          entry.key: _sensitiveKeys.contains(entry.key.toString().toLowerCase())
              ? _mask
              : _redact(entry.value),
      };
    }
    if (data is List) return data.map(_redact).toList();
    if (data is String) {
      // A raw JSON string body (not yet decoded) — redact after parsing.
      try {
        return _redact(jsonDecode(data));
      } catch (_) {
        return data;
      }
    }
    return data;
  }
}
