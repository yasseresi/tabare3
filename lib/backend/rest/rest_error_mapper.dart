import 'package:dio/dio.dart';

import '../../core/backend/backend_error_mapper.dart';
import '../../core/error/failures.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/string_manager.dart';

/// Raised client-side when a request can't be built because a value could not
/// be mapped to what the backend expects (e.g. an unknown wilaya/blood-type
/// that has no id). Surfaced as a [ValidationFailure] so the user gets a clear,
/// field-level message instead of an opaque server 400.
class RestValidationException implements Exception {
  const RestValidationException(this.message);
  final String message;
  @override
  String toString() => 'RestValidationException: $message';
}

/// Maps [DioException]s from the Django REST backend to domain [Failure]s, so
/// the rest of the app only ever sees vendor-neutral failure types.
class RestErrorMapper implements BackendErrorMapper {
  const RestErrorMapper();

  @override
  Failure? map(
    Object error, {
    BackendOperation operation = BackendOperation.generic,
  }) {
    if (error is RestValidationException) {
      // The exception message is diagnostic; the user sees the localized string.
      return ValidationFailure(
        422,
        ErrorMessages.getMessage(AppStrings.missingRequiredFields),
      );
    }
    if (error is! DioException) return null;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkFailure(
          -6,
          ErrorMessages.getMessage(AppStrings.timeoutError),
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          -6,
          ErrorMessages.getMessage(AppStrings.networkError),
        );
      case DioExceptionType.badResponse:
        return _mapStatus(error.response?.statusCode, operation);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ServerFailure(
          -7,
          ErrorMessages.getMessage(AppStrings.defaultError),
        );
    }
  }

  Failure _mapStatus(int? status, BackendOperation operation) {
    // Mirrors the Supabase mapper: on the sign-in path every rejection of the
    // credentials — malformed, unknown user, forbidden — reads the same, so the
    // response never says which factor was wrong. 429 and 5xx are about the
    // server, not the credentials, and keep their own message.
    if (operation == BackendOperation.signIn &&
        status != null &&
        status >= 400 &&
        status < 500 &&
        status != 429) {
      return AuthFailure(
        status,
        ErrorMessages.getMessage(AppStrings.invalidLoginCredentials),
      );
    }

    switch (status) {
      case 400:
        return ValidationFailure(
          400,
          ErrorMessages.getMessage(AppStrings.missingRequiredFields),
        );
      case 401:
        return AuthFailure(
          401,
          ErrorMessages.getMessage(AppStrings.invalidLoginCredentials),
        );
      case 403:
        return AuthFailure(
          403,
          ErrorMessages.getMessage(AppStrings.permissionDenied),
        );
      case 404:
        return ServerFailure(
          404,
          ErrorMessages.getMessage(AppStrings.notFoundError),
        );
      case 409:
        return DatabaseFailure(
          409,
          ErrorMessages.getMessage(AppStrings.duplicateEntry),
        );
      case 422:
        return ValidationFailure(
          422,
          ErrorMessages.getMessage(AppStrings.missingRequiredFields),
        );
      case 429:
        return ServerFailure(
          429,
          ErrorMessages.getMessage(AppStrings.tooManyRequests),
        );
      default:
        return ServerFailure(
          status ?? -7,
          ErrorMessages.getMessage(AppStrings.serverError),
        );
    }
  }
}
