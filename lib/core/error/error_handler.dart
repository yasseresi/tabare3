import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is PostgrestException) {
      return DatabaseFailure(
        int.tryParse(error.code ?? '') ?? -8,
        error.message,
      );
    }
    if (error is AuthException) {
      return AuthFailure(
        int.tryParse(error.statusCode ?? '') ?? -9,
        error.message,
      );
    }
    if (error is StorageException) {
      return StorageFailure(
        int.tryParse(error.statusCode ?? '') ?? -10,
        error.message,
      );
    }
    if (error is SocketException) {
      return const NetworkFailure();
    }
    return ServerFailure(-7, error?.toString() ?? 'Unknown error');
  }
}
