import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabare3/backend/rest/rest_error_mapper.dart';
import 'package:tabare3/backend/supabase/supabase_error_mapper.dart';
import 'package:tabare3/core/backend/backend_error_mapper.dart';
import 'package:tabare3/core/utils/error_messages.dart';
import 'package:tabare3/core/utils/string_manager.dart';

/// Every sign-in failure has to read the same, whatever the backend said.
/// A message that names the factor — "user not found", "wrong password" —
/// turns a two-factor guess into a one-factor one.
final genericMessage = ErrorMessages.getMessage(
  AppStrings.invalidLoginCredentials,
);

DioException _dioStatus(int status) => DioException(
  requestOptions: RequestOptions(path: '/auth/login'),
  type: DioExceptionType.badResponse,
  response: Response<void>(
    requestOptions: RequestOptions(path: '/auth/login'),
    statusCode: status,
  ),
);

void main() {
  group('SupabaseErrorMapper on the sign-in path', () {
    const mapper = SupabaseErrorMapper();

    // Every one of these is a GoTrue answer that would otherwise tell the user
    // — or whoever is guessing — which of the two factors was wrong.
    const leakyMessages = [
      'Invalid login credentials',
      'User not found',
      'Invalid email',
      'Password should be at least 6 characters',
      'Email not confirmed',
      'User already registered',
      'Something GoTrue has not said before',
    ];

    for (final message in leakyMessages) {
      test('collapses "$message" into the generic message', () {
        final failure = mapper.map(
          AuthException(message, statusCode: '400'),
          operation: BackendOperation.signIn,
        );

        expect(failure?.message, genericMessage);
      });
    }

    test('still reports throttling, which names no factor', () {
      final failure = mapper.map(
        AuthException('Email rate limit exceeded', statusCode: '429'),
        operation: BackendOperation.signIn,
      );

      expect(
        failure?.message,
        ErrorMessages.getMessage(AppStrings.tooManyRequests),
      );
    });

    test('leaves sign-up messages specific so the user can fix the field', () {
      expect(
        mapper
            .map(
              AuthException('User already registered', statusCode: '400'),
              operation: BackendOperation.signUp,
            )
            ?.message,
        ErrorMessages.getMessage(AppStrings.userAlreadyRegistered),
      );
      expect(
        mapper
            .map(
              AuthException('Password should be at least 6 characters'),
              operation: BackendOperation.signUp,
            )
            ?.message,
        ErrorMessages.getMessage(AppStrings.weakPassword),
      );
    });

    test('defaults to the unrestricted mapping when no operation is given', () {
      expect(
        mapper.map(AuthException('User not found'))?.message,
        ErrorMessages.getMessage(AppStrings.userNotFound),
      );
    });
  });

  group('RestErrorMapper on the sign-in path', () {
    const mapper = RestErrorMapper();

    for (final status in [400, 401, 403, 404, 409, 422]) {
      test('collapses HTTP $status into the generic message', () {
        expect(
          mapper
              .map(_dioStatus(status), operation: BackendOperation.signIn)
              ?.message,
          genericMessage,
        );
      });
    }

    test('leaves throttling and server faults alone', () {
      expect(
        mapper.map(_dioStatus(429), operation: BackendOperation.signIn)?.message,
        ErrorMessages.getMessage(AppStrings.tooManyRequests),
      );
      expect(
        mapper.map(_dioStatus(500), operation: BackendOperation.signIn)?.message,
        ErrorMessages.getMessage(AppStrings.serverError),
      );
    });

    test('keeps 404 specific off the sign-in path', () {
      expect(
        mapper.map(_dioStatus(404))?.message,
        ErrorMessages.getMessage(AppStrings.notFoundError),
      );
    });
  });
}
