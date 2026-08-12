import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../backend/backend_error_mapper.dart';
import 'failures.dart';
import '../utils/string_manager.dart';
import '../utils/error_messages.dart';

/// Backend-agnostic entry point for turning thrown errors into [Failure]s.
///
/// Backend-specific translation lives in a [BackendErrorMapper] installed at
/// startup via [configure], so this file never imports a backend SDK.
class ErrorHandler {
  ErrorHandler._();

  static BackendErrorMapper? _backendMapper;

  /// Installs the mapper of the active backend. Called once during DI setup.
  static void configure(BackendErrorMapper mapper) {
    _backendMapper = mapper;
  }

  /// Clears the installed mapper. Intended for tests.
  static void reset() {
    _backendMapper = null;
  }

  /// Maps [error] to a [Failure].
  ///
  /// Pass [stackTrace] from the catch clause (`catch (error, stackTrace)`)
  /// whenever it is available — for parse failures it is the only thing that
  /// names the model and field that failed to deserialize.
  ///
  /// Pass [operation] whenever the caller sits on a path with its own
  /// disclosure rules — the sign-in path above all, where every backend error
  /// has to collapse into a single generic message.
  static Failure handle(
    dynamic error, {
    StackTrace? stackTrace,
    BackendOperation operation = BackendOperation.generic,
  }) {
    if (error is Object) {
      final mapped = _backendMapper?.map(error, operation: operation);
      if (mapped != null) return mapped;
    }
    if (error is SocketException) {
      return NetworkFailure(
        -6,
        ErrorMessages.getMessage(AppStrings.networkError),
      );
    }
    if (error is TimeoutException) {
      return NetworkFailure(
        -6,
        ErrorMessages.getMessage(AppStrings.timeoutError),
      );
    }
    // The Supabase/REST stack calls package:http, which raises a
    // ClientException (not a SocketException) on intermittent connectivity —
    // e.g. a dropped connection while the home feed loads. Without this branch
    // it collapses into the opaque default error.
    if (error is http.ClientException) {
      return NetworkFailure(
        -6,
        ErrorMessages.getMessage(AppStrings.connectionError),
      );
    }
    // The backend payload did not match the model: json_serializable raises a
    // TypeError from the cast when a `required` field is fed a null column, and
    // hand-rolled parsing raises FormatException. Both are our bug, not the
    // server's, so give them a distinct failure and leave a log breadcrumb —
    // otherwise every one renders as the same undiagnosable default error.
    if (error is TypeError || error is FormatException) {
      developer.log(
        'Failed to parse a backend payload. A model field is likely `required` '
        'while the column or embed is nullable — the stack trace names the '
        'model that failed.',
        name: 'ErrorHandler.parse',
        error: error,
        stackTrace: stackTrace ?? StackTrace.current,
      );
      return ParseFailure(
        -12,
        ErrorMessages.getMessage(AppStrings.defaultError),
      );
    }
    return ServerFailure(-7, ErrorMessages.getMessage(AppStrings.defaultError));
  }
}
