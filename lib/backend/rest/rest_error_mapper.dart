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
        return _mapResponse(error.response, operation);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return ServerFailure(
          -7,
          ErrorMessages.getMessage(AppStrings.defaultError),
        );
    }
  }

  Failure _mapResponse(Response<dynamic>? response, BackendOperation operation) {
    final status = response?.statusCode;

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
      case 422:
        // DRF returns per-field errors ({field: [msg], ...}) or {detail: msg}.
        // Surface those verbatim so the user learns the real problem (phone
        // already used, name too short, …) instead of a blanket "fill the
        // required fields", and carry the field keys so the UI can route to the
        // step that owns the offending field.
        final parsed = _parseFieldErrors(response?.data);
        if (parsed != null) {
          return ValidationFailure(status ?? 400, parsed.message, parsed.fields);
        }
        return ValidationFailure(
          status ?? 400,
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

  /// Flattens a DRF error body into a single message plus the field keys that
  /// failed. Handles the two shapes the backend emits:
  ///   `{"phone": ["…"], "first_name": ["…"]}`  → per-field errors
  ///   `{"detail": "…"}` / `{"non_field_errors": ["…"]}` → form-level errors
  /// Returns null when nothing usable can be extracted (so the caller falls
  /// back to the generic message).
  ({String message, List<String> fields})? _parseFieldErrors(Object? data) {
    if (data is! Map) return null;

    final messages = <String>[];
    final fields = <String>[];

    void collect(Object? value) {
      if (value is String) {
        if (value.trim().isNotEmpty) messages.add(value.trim());
      } else if (value is List) {
        for (final item in value) {
          collect(item);
        }
      } else if (value is Map) {
        for (final item in value.values) {
          collect(item);
        }
      }
    }

    data.forEach((key, value) {
      final keyStr = key.toString();
      if (keyStr != 'detail' && keyStr != 'non_field_errors') {
        fields.add(keyStr);
      }
      collect(value);
    });

    if (messages.isEmpty) return null;
    return (message: messages.join('\n'), fields: fields);
  }
}
