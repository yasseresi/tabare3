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
  /// [source] is an optional call-site label (e.g. `'donorFeed.getAvailability'`)
  /// that is attached to parse-failure logs to point at the offending query.
  static Failure handle(
    dynamic error, {
    String? source,
    StackTrace? stackTrace,
  }) {
    if (error is Object) {
      final mapped = _backendMapper?.map(error);
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
    // A `required` model field fed a null column, or a column changed type:
    // json_serializable raises a TypeError from the cast, and hand-rolled
    // parsing raises FormatException. Both are our bug, not the server's, so
    // give them a distinct failure and leave a log breadcrumb — otherwise
    // every one of them renders as the same undiagnosable default error.
    if (error is TypeError || error is FormatException) {
      developer.log(
        'Failed to parse a backend payload${source == null ? '' : ' from $source'}'
        ' — a model field is likely `required` while the column or embed is '
        'nullable.',
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
