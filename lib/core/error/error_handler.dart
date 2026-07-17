import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failures.dart';

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
      return const NetworkFailure();
    }
    return ServerFailure(-7, AppStrings.defaultError);
  }

  static Failure _handleAuthError(AuthException error) {
    final message = error.message.toLowerCase();
    final statusCode = int.tryParse(error.statusCode ?? '') ?? -9;

    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return AuthFailure(statusCode, AppStrings.invalidLoginCredentials);
    }
    if (message.contains('user already registered') ||
        message.contains('already been registered')) {
      return AuthFailure(statusCode, AppStrings.userAlreadyRegistered);
    }
    if (message.contains('email not confirmed') ||
        message.contains('email_confirmed_at')) {
      return AuthFailure(statusCode, AppStrings.emailNotConfirmed);
    }
    if (message.contains('password should be at least')) {
      return AuthFailure(statusCode, AppStrings.weakPassword);
    }
    if (message.contains('invalid email')) {
      return AuthFailure(statusCode, AppStrings.invalidEmail);
    }
    if (message.contains('rate limit')) {
      return AuthFailure(statusCode, AppStrings.tooManyRequests);
    }
    if (message.contains('user not found')) {
      return AuthFailure(statusCode, AppStrings.userNotFound);
    }
    if (message.contains('signup is disabled')) {
      return AuthFailure(statusCode, AppStrings.signupDisabled);
    }
    if (message.contains('missing required metadata')) {
      return AuthFailure(statusCode, AppStrings.missingRequiredFields);
    }

    return AuthFailure(statusCode, AppStrings.authError);
  }

  static Failure _handleDatabaseError(PostgrestException error) {
    final message = error.message.toLowerCase();
    final code = int.tryParse(error.code ?? '') ?? -8;

    if (message.contains('duplicate key') ||
        message.contains('unique constraint') ||
        message.contains('already exists')) {
      return DatabaseFailure(code, AppStrings.duplicateEntry);
    }
    if (message.contains('foreign key') ||
        message.contains('violates foreign key')) {
      return DatabaseFailure(code, AppStrings.referenceError);
    }
    if (message.contains('not found') || error.code == 'PGRST116') {
      return DatabaseFailure(code, AppStrings.notFoundError);
    }
    if (message.contains('permission denied') ||
        message.contains('insufficient privilege')) {
      return DatabaseFailure(code, AppStrings.permissionDenied);
    }

    return DatabaseFailure(code, AppStrings.databaseError);
  }

  static String _getStorageErrorMessage(StorageException error) {
    final message = error.message.toLowerCase();

    if (message.contains('not found')) {
      return AppStrings.notFoundError;
    }
    if (message.contains('already exists')) {
      return AppStrings.duplicateEntry;
    }
    if (message.contains('too large') || message.contains('size')) {
      return AppStrings.fileTooLarge;
    }

    return AppStrings.storageError;
  }
}

class AppStrings {
  AppStrings._();

  // Success messages
  static const String success = 'تمت العملية بنجاح';
  static const String loginSuccess = 'لقد سجلت الدخول بنجاح إلى تطبيق';
  static const String signupSuccess = 'لقد تم إنشاء حساب بنجاح';
  static const String updateSuccess = 'تم التحديث بنجاح';

  // Auth error messages
  static const String authError = 'خطأ في المصادقة';
  static const String invalidLoginCredentials = 'اسم المستخدم أو كلمة المرور غير صحيحة';
  static const String userAlreadyRegistered = 'اسم المستخدم موجود بالفعل، يرجى اختيار اسم آخر';
  static const String emailNotConfirmed = 'يرجى تأكيد البريد الإلكتروني أولاً';
  static const String weakPassword = 'كلمة المرور ضعيفة، يجب أن تكون 6 أحرف على الأقل';
  static const String invalidEmail = 'البريد الإلكتروني غير صالح';
  static const String tooManyRequests = 'تم تجاوز عدد المحاولات، يرجى الانتظار قليلاً';
  static const String userNotFound = 'المستخدم غير موجود';
  static const String signupDisabled = 'التسجيل غير متاح حالياً';
  static const String missingRequiredFields = 'يرجى ملء جميع الحقول المطلوبة';
  static const String sessionExpired = 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';

  // Network error messages
  static const String networkError = 'لا يوجد اتصال بالإنترنت';
  static const String timeoutError = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
  static const String connectionError = 'فشل الاتصال بالخادم';

  // Database error messages
  static const String databaseError = 'خطأ في قاعدة البيانات';
  static const String duplicateEntry = 'البيانات موجودة بالفعل';
  static const String referenceError = 'خطأ في البيانات المرتبطة';
  static const String notFoundError = 'البيانات غير موجودة';
  static const String permissionDenied = 'ليس لديك صلاحية للوصول';

  // Storage error messages
  static const String storageError = 'خطأ في تخزين الملفات';
  static const String fileTooLarge = 'حجم الملف كبير جداً';

  // Server error messages
  static const String serverError = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
  static const String defaultError = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
}
