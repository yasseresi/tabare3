class AppConstants {
  static const int splashDelay = 2;
  static const int splashDelayUnauthenticated = 3;
  static const int sliderAnimationTime = 300;
  static const int toastDuration = 3;
  static const int toggleAnimationMs = 150;
  static const int paginationLimit = 10;

  /// Highest exact number shown on the notification bell badge; above this the
  /// badge renders [AppStrings.badgeOverflow] (e.g. `9+`).
  static const int badgeMaxCount = 9;
  static const int profileHadithMaxLines = 3;
  static const int statusTagMaxLines = 1;
  static const int minPasswordLength = 8;
  static const int minDonorAge = 18;
  static const int maxDonorAge = 65;
  static const int minDonorWeight = 50;
  static const double defaultWeightKg = 70;
  static const double minWeightKg = 30;
  static const double maxWeightKg = 250;
  static const int donationIntervalDaysMale = 90;
  static const int donationIntervalDaysFemale = 120;
  // Gamification point rules, shown on the donor-card guide.
  static const int pointsNormalDonation = 8;
  static const int pointsUrgentDonation = 10;
  static const int pointsKeptAppointment = 2;
  static const int pointsCancellation = -5;
  static const int pointsInactiveThreeMonths = -3;

  static const int requestCalendarStartOffsetDays = 1;
  static const int requestCalendarRangeDays = 365;
  static const String requestDateFormat = 'dd MMM yyyy';
  static const String requestPatientDateFormat = 'yyyy-MM-dd';
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String requestTimeFormat = 'HH:mm';
  static const String notificationDateTimeFormat = 'yyyy/MM/dd - HH:mm';
  static const String appVersion = '1.0';
  static const String developerPhone = '0676 24 41 89';
  static const String developerEmail = 'louciftamer3@gmail.com';
}

class LocalizationArgs {
  static const String count = 'count';
  static const String total = 'total';
  static const String provided = 'provided';
  static const String time = 'time';
}
