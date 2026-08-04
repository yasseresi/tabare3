import 'dart:io';

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

  static Failure handle(dynamic error) {
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
    return ServerFailure(-7, ErrorMessages.getMessage(AppStrings.defaultError));
  }
}
