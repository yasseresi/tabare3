import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/env_constants.dart';

const String contentTypeHeader = 'content-type';
const String acceptHeader = 'accept';
const String authorizationHeader = 'authorization';
const String applicationJson = 'application/json';

const Duration restTimeout = Duration(seconds: 120);

/// Builds the configured [Dio] instance for the custom REST backend.
///
/// Access-token handling lives here so no data source ever deals with headers.
class RestClientFactory {
  RestClientFactory({String? baseUrl, Dio? dio})
    : _baseUrl = baseUrl ?? EnvConstants.apiBaseUrl,
      _dio = dio ?? Dio();

  final String _baseUrl;
  final Dio _dio;

  String? _accessToken;

  /// Stores the token attached to every subsequent request.
  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Dio build() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {contentTypeHeader: applicationJson, acceptHeader: applicationJson},
      connectTimeout: restTimeout,
      sendTimeout: restTimeout,
      receiveTimeout: restTimeout,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers[authorizationHeader] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return _dio;
  }
}
