import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/logging_interceptor.dart';

/// Captures debugPrint output for the duration of [body].
List<String> _capture(void Function() body) {
  final lines = <String>[];
  final original = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) lines.add(message);
  };
  try {
    body();
  } finally {
    debugPrint = original;
  }
  return lines;
}

void main() {
  const interceptor = RedactingLogInterceptor();

  RequestOptions req(Object? data) =>
      RequestOptions(path: '/auth/login', method: 'POST', data: data);

  test('masks passwords and tokens in a request body', () {
    final lines = _capture(() {
      interceptor.onRequest(
        req({'email': 'a@b.dz', 'password': 'hunter2', 'password_confirm': 'hunter2'}),
        RequestInterceptorHandler(),
      );
    });

    final out = lines.join('\n');
    expect(out, contains('a@b.dz')); // non-secret survives
    expect(out, isNot(contains('hunter2'))); // password masked
    expect(out, contains('***'));
  });

  test('masks nested and JSON-string token bodies in a response', () {
    final response = Response<dynamic>(
      requestOptions: RequestOptions(path: '/auth/login'),
      statusCode: 200,
      // raw JSON string body (pre-decode) with nested secret
      data: jsonEncode({
        'access': 'JWT_ACCESS',
        'refresh': 'JWT_REFRESH',
        'user': {'id': 1, 'token': 'inner'},
      }),
    );

    final lines = _capture(() {
      interceptor.onResponse(response, ResponseInterceptorHandler());
    });

    final out = lines.join('\n');
    expect(out, isNot(contains('JWT_ACCESS')));
    expect(out, isNot(contains('JWT_REFRESH')));
    expect(out, isNot(contains('inner')));
    expect(out, contains('***'));
  });
}
