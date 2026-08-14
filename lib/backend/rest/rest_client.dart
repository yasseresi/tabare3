import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/env_constants.dart';
import 'auth_interceptor.dart';
import 'token_store.dart';

const String contentTypeHeader = 'content-type';
const String acceptHeader = 'accept';
const String applicationJson = 'application/json';

const Duration restTimeout = Duration(seconds: 120);

/// Builds the configured [Dio] instance for the custom REST backend.
///
/// Token handling (attach + refresh) lives in [AuthInterceptor], so no data
/// source ever deals with headers or the `401` refresh dance.
class RestClientFactory {
  RestClientFactory({
    String? baseUrl,
    TokenStore? tokenStore,
    Dio? dio,
    void Function()? onAuthExpired,
  }) : _baseUrl = baseUrl ?? EnvConstants.apiBaseUrl,
       _tokenStore = tokenStore ?? SecureTokenStore(),
       _dio = dio ?? Dio(),
       _onAuthExpired = onAuthExpired;

  final String _baseUrl;
  final TokenStore _tokenStore;
  final Dio _dio;
  final void Function()? _onAuthExpired;

  TokenStore get tokenStore => _tokenStore;

  Dio build() {
    final options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        contentTypeHeader: applicationJson,
        acceptHeader: applicationJson,
      },
      connectTimeout: restTimeout,
      sendTimeout: restTimeout,
      receiveTimeout: restTimeout,
    );
    _dio.options = options;

    // Bare client for refresh + replay — no AuthInterceptor, so a failing
    // refresh cannot recurse.
    final refreshClient = Dio(options);

    _dio.interceptors.add(
      AuthInterceptor(
        tokenStore: _tokenStore,
        refreshClient: refreshClient,
        onAuthExpired: _onAuthExpired,
      ),
    );

    if (!kReleaseMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return _dio;
  }
}
