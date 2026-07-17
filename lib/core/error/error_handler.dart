import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failures.dart';
import '../utils/string_manager.dart';
import '../utils/error_messages.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handle(dynamic error) {
    if (error is PostgrestException) {
      return _handleDatabaseError(error);
    }
    if (error is AuthException) {
      return _handleAuthError(error);
    }
    if (error is StorageException) {
      return StorageFailure(
        int.tryParse(error.statusCode ?? '') ?? -10,
        _getStorageErrorMessage(error),
      );
    }
    if (error is SocketException) {
      return NetworkFailure(
        -6,
        ErrorMessages.getMessage(AppStrings.networkError),
      );
    }
    return ServerFailure(-7, ErrorMessages.getMessage(AppStrings.defaultError));
  }

  static Failure _handleAuthError(AuthException error) {
    final message = error.message.toLowerCase();
    final statusCode = int.tryParse(error.statusCode ?? '') ?? -9;

    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.invalidLoginCredentials),
      );
    }
    if (message.contains('user already registered') ||
        message.contains('already been registered')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.userAlreadyRegistered),
      );
    }
    if (message.contains('email not confirmed') ||
        message.contains('email_confirmed_at')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.emailNotConfirmed),
      );
    }
    if (message.contains('password should be at least')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.weakPassword),
      );
    }
    if (message.contains('invalid email')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.invalidEmail),
      );
    }
    if (message.contains('rate limit')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.tooManyRequests),
      );
    }
    if (message.contains('user not found')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.userNotFound),
      );
    }
    if (message.contains('signup is disabled')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.signupDisabled),
      );
    }
    if (message.contains('missing required metadata')) {
      return AuthFailure(
        statusCode,
        ErrorMessages.getMessage(AppStrings.missingRequiredFields),
      );
    }

    return AuthFailure(
      statusCode,
      ErrorMessages.getMessage(AppStrings.authError),
    );
  }

  static Failure _handleDatabaseError(PostgrestException error) {
    final message = error.message.toLowerCase();
    final code = int.tryParse(error.code ?? '') ?? -8;

    if (message.contains('duplicate key') ||
        message.contains('unique constraint') ||
        message.contains('already exists')) {
      return DatabaseFailure(
        code,
        ErrorMessages.getMessage(AppStrings.duplicateEntry),
      );
    }
    if (message.contains('foreign key') ||
        message.contains('violates foreign key')) {
      return DatabaseFailure(
        code,
        ErrorMessages.getMessage(AppStrings.referenceError),
      );
    }
    if (message.contains('not found') || error.code == 'PGRST116') {
      return DatabaseFailure(
        code,
        ErrorMessages.getMessage(AppStrings.notFoundError),
      );
    }
    if (message.contains('permission denied') ||
        message.contains('insufficient privilege')) {
      return DatabaseFailure(
        code,
        ErrorMessages.getMessage(AppStrings.permissionDenied),
      );
    }

    return DatabaseFailure(
      code,
      ErrorMessages.getMessage(AppStrings.databaseError),
    );
  }

  static String _getStorageErrorMessage(StorageException error) {
    final message = error.message.toLowerCase();

    if (message.contains('not found')) {
      return ErrorMessages.getMessage(AppStrings.notFoundError);
    }
    if (message.contains('already exists')) {
      return ErrorMessages.getMessage(AppStrings.duplicateEntry);
    }
    if (message.contains('too large') || message.contains('size')) {
      return ErrorMessages.getMessage(AppStrings.fileTooLarge);
    }

    return ErrorMessages.getMessage(AppStrings.storageError);
  }
}
