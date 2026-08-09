import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tabare3/core/error/error_handler.dart';
import 'package:tabare3/core/error/failures.dart';
import 'package:tabare3/core/utils/error_messages.dart';
import 'package:tabare3/core/utils/string_manager.dart';

void main() {
  setUp(ErrorHandler.reset);
  tearDown(ErrorHandler.reset);

  group('ErrorHandler transport errors', () {
    test('maps http ClientException to a network failure', () {
      // Intermittent connectivity: package:http (used by postgrest/gotrue)
      // throws ClientException, NOT SocketException. Regression guard for the
      // generic "unexpected error" shown on the home feed.
      final failure = ErrorHandler.handle(
        http.ClientException('Failed host lookup: example.supabase.co'),
      );

      expect(failure, isA<NetworkFailure>());
      expect(
        failure.message,
        ErrorMessages.getMessage(AppStrings.connectionError),
      );
    });

    test('maps TimeoutException to a timeout failure', () {
      final failure = ErrorHandler.handle(
        TimeoutException('request timed out'),
      );

      expect(failure, isA<NetworkFailure>());
      expect(
        failure.message,
        ErrorMessages.getMessage(AppStrings.timeoutError),
      );
    });

    test('maps SocketException to a network failure', () {
      final failure = ErrorHandler.handle(
        const SocketException('No route to host'),
      );

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, ErrorMessages.getMessage(AppStrings.networkError));
    });

    test('falls back to a server failure for unknown errors', () {
      final failure = ErrorHandler.handle(StateError('boom'));

      expect(failure, isA<ServerFailure>());
      expect(failure.message, ErrorMessages.getMessage(AppStrings.defaultError));
    });
  });
}
