import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/backend/backend_error_mapper.dart';
import '../../core/error/failures.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/string_manager.dart';

/// Maps Supabase SDK exceptions (Postgrest / GoTrue / Storage) to [Failure]s.
class SupabaseErrorMapper implements BackendErrorMapper {
  const SupabaseErrorMapper();

  @override
  Failure? map(Object error) {
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
    return null;
  }

  Failure _handleAuthError(AuthException error) {
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

  /// Domain errors the redeem RPCs raise verbatim via `P0001`. They arrive as
  /// the raw `PostgrestException.message`, so map them before the generic
  /// substring checks — otherwise every one collapses into `databaseError`.
  static const Map<String, String> _redeemErrorMessages = {
    'qr_already_used': AppStrings.qrAlreadyUsed,
    'qr_expired': AppStrings.qrExpired,
    'appointment_required': AppStrings.appointmentRequired,
    'qr_invalid': AppStrings.qrInvalid,
  };

  Failure _handleDatabaseError(PostgrestException error) {
    final message = error.message.toLowerCase();
    final code = int.tryParse(error.code ?? '') ?? -8;

    final redeemKey = _redeemErrorMessages[error.message];
    if (redeemKey != null) {
      return DatabaseFailure(code, ErrorMessages.getMessage(redeemKey));
    }

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

  String _getStorageErrorMessage(StorageException error) {
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
