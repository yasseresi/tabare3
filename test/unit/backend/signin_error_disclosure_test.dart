import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/backend/rest/rest_error_mapper.dart';
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
