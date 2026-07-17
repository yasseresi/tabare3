import 'string_manager.dart';

class ErrorMessages {
  ErrorMessages._();

  static String getMessage(String key) {
    return _arabicMessages[key] ?? AppStrings.defaultError;
  }

  static const Map<String, String> _arabicMessages = {
    // Auth errors
    AppStrings.authError: 'خطأ في المصادقة',
    AppStrings.invalidLoginCredentials: 'اسم المستخدم أو كلمة المرور غير صحيحة',
    AppStrings.userAlreadyRegistered: 'اسم المستخدم موجود بالفعل، يرجى اختيار اسم آخر',
    AppStrings.emailNotConfirmed: 'يرجى تأكيد البريد الإلكتروني أولاً',
    AppStrings.weakPassword: 'كلمة المرور ضعيفة، يجب أن تكون 6 أحرف على الأقل',
    AppStrings.invalidEmail: 'البريد الإلكتروني غير صالح',
    AppStrings.tooManyRequests: 'تم تجاوز عدد المحاولات، يرجى الانتظار قليلاً',
    AppStrings.userNotFound: 'المستخدم غير موجود',
    AppStrings.signupDisabled: 'التسجيل غير متاح حالياً',
    AppStrings.missingRequiredFields: 'يرجى ملء جميع الحقول المطلوبة',
    AppStrings.sessionExpired: 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى',

    // Network errors
    AppStrings.networkError: 'لا يوجد اتصال بالإنترنت',
    AppStrings.timeoutError: 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى',
    AppStrings.connectionError: 'فشل الاتصال بالخادم',

    // Database errors
    AppStrings.databaseError: 'خطأ في قاعدة البيانات',
    AppStrings.duplicateEntry: 'البيانات موجودة بالفعل',
    AppStrings.referenceError: 'خطأ في البيانات المرتبطة',
    AppStrings.notFoundError: 'البيانات غير موجودة',
    AppStrings.permissionDenied: 'ليس لديك صلاحية للوصول',

    // Storage errors
    AppStrings.storageError: 'خطأ في تخزين الملفات',
    AppStrings.fileTooLarge: 'حجم الملف كبير جداً',

    // Server errors
    AppStrings.serverError: 'خطأ في الخادم، يرجى المحاولة لاحقاً',
    AppStrings.defaultError: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',

    // Success messages
    AppStrings.success: 'تمت العملية بنجاح',
    AppStrings.loginSuccess: 'لقد سجلت الدخول بنجاح إلى تطبيق',
    AppStrings.signupSuccess: 'لقد تم إنشاء حساب بنجاح',
  };
}
