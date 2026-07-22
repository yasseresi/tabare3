import 'string_manager.dart';

class ValidationKeys {
  ValidationKeys._();

  static const String usernameRequired = AppStrings.usernameRequired;
  static const String usernameInvalid = AppStrings.usernameInvalid;
  static const String fullNameRequired = AppStrings.fullNameRequired;
  static const String phoneRequired = AppStrings.phoneRequired;
  static const String phoneInvalid = AppStrings.phoneInvalid;
  static const String passwordRequired = AppStrings.passwordRequired;
  static const String passwordInvalid = AppStrings.passwordInvalid;
  static const String dateRequired = AppStrings.dateRequired;
  static const String dateInvalid = AppStrings.dateInvalid;
  static const String genderRequired = AppStrings.genderRequired;
  static const String genderInvalid = AppStrings.genderInvalid;
  static const String cityRequired = AppStrings.cityRequired;
  static const String cityInvalid = AppStrings.cityInvalid;
  static const String bloodTypeRequired = AppStrings.bloodTypeRequired;
  static const String termsRequired = AppStrings.termsRequired;
  static const String passwordConfirmRequired =
      AppStrings.passwordConfirmRequired;
  static const String passwordConfirmMismatch =
      AppStrings.passwordConfirmMismatch;
}

class ErrorMessages {
  ErrorMessages._();

  static String getMessage(String key) {
    return _arabicMessages[key] ?? AppStrings.defaultError;
  }

  static String getValidationMessage(String key) {
    return _validationMessages[key] ?? _arabicMessages[key] ?? '';
  }

  static const Map<String, String> _validationMessages = {
    ValidationKeys.usernameRequired: 'يرجى إدخال اسم المستخدم',
    ValidationKeys.usernameInvalid: 'يجب أن يكون اسم المستخدم 3 أحرف على الأقل',
    ValidationKeys.fullNameRequired: 'يرجى إدخال الاسم الكامل',
    ValidationKeys.phoneRequired: 'يرجى إدخال رقم الجوال',
    ValidationKeys.phoneInvalid: 'صيغة رقم الجوال غير صحيحة (0XXXXXXXXX)',
    ValidationKeys.passwordRequired: 'يرجى إدخال كلمة المرور',
    ValidationKeys.passwordInvalid: 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
    ValidationKeys.dateRequired: 'يرجى إدخال تاريخ الميلاد',
    ValidationKeys.dateInvalid: 'صيغة التاريخ غير صحيحة (YYYY-MM-DD)',
    ValidationKeys.genderRequired: 'يرجى اختيار الجنس',
    ValidationKeys.genderInvalid: 'يجب أن يكون الجنس ذكر أو أنثى',
    ValidationKeys.cityRequired: 'يرجى إدخال الولاية',
    ValidationKeys.cityInvalid: 'يرجى اختيار ولاية صحيحة',
    ValidationKeys.bloodTypeRequired: 'يرجى اختيار فصيلة الدم',
    ValidationKeys.termsRequired: 'يجب الموافقة على الشروط والأحكام',
    ValidationKeys.passwordConfirmRequired: 'يرجى تأكيد كلمة المرور',
    ValidationKeys.passwordConfirmMismatch: 'كلمة المرور غير متطابقة',
  };

  static const Map<String, String> _arabicMessages = {
    // Auth errors
    AppStrings.authError: 'خطأ في المصادقة',
    AppStrings.invalidLoginCredentials: 'اسم المستخدم أو كلمة المرور غير صحيحة',
    AppStrings.userAlreadyRegistered:
        'اسم المستخدم موجود بالفعل، يرجى اختيار اسم آخر',
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
