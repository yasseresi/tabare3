import '../constants/algerian_wilayas.dart';
import '../utils/error_messages.dart';

bool isUsernameValid(String? username) =>
    username != null && username.trim().length >= 3;

bool isFullNameValid(String? fullName) =>
    fullName != null && fullName.trim().isNotEmpty;

bool isPhoneValid(String? phone) =>
    phone != null &&
    RegExp(r'^0\d{9}$').hasMatch(phone.replaceAll(RegExp(r'\s+'), ''));

bool isPasswordValid(String? password) =>
    password != null && password.length >= 8;

/// A strong password for new accounts: at least 12 characters spanning an
/// uppercase letter, a lowercase letter, a digit, and a special character.
bool isStrongPassword(String? password) =>
    password != null &&
    password.length >= 12 &&
    RegExp(r'[A-Z]').hasMatch(password) &&
    RegExp(r'[a-z]').hasMatch(password) &&
    RegExp(r'\d').hasMatch(password) &&
    RegExp(r'[^A-Za-z0-9]').hasMatch(password);

/// The Algerian national identification number is exactly 18 digits.
bool isNationalIdValid(String? id) =>
    id != null && RegExp(r'^\d{18}$').hasMatch(id.trim());

bool isDateValid(String? date) =>
    date != null && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date.trim());

bool isGenderValid(String? gender) =>
    gender != null && (gender.trim() == 'ذكر' || gender.trim() == 'أنثى');

bool isNumeric(String? value) =>
    value != null && RegExp(r'^\d+$').hasMatch(value.trim());

bool isFloat(String? value) =>
    value != null && RegExp(r'^\d+(\.\d+)?$').hasMatch(value.trim());

bool isRequired(String? value) => value != null && value.trim().isNotEmpty;

String? validateRequired(String? value, String fieldName) =>
    isRequired(value) ? null : fieldName;

String? validateUsername(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.usernameRequired);
  }
  if (!isUsernameValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.usernameInvalid);
  }
  return null;
}

String? validateFullName(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.fullNameRequired);
  }
  return null;
}

String? validatePhone(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.phoneRequired);
  }
  if (!isPhoneValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.phoneInvalid);
  }
  return null;
}

String? validatePassword(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordRequired);
  }
  if (!isPasswordValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordInvalid);
  }
  return null;
}

/// Strong-password check for account creation. Login keeps [validatePassword]
/// so existing accounts with legacy passwords are never blocked client-side.
String? validateStrongPassword(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordRequired);
  }
  if (!isStrongPassword(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordWeak);
  }
  return null;
}

String? validateNationalId(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.nationalIdRequired);
  }
  if (!isNationalIdValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.nationalIdInvalid);
  }
  return null;
}

/// National ID is optional on the donor/recipient profile: a blank value passes,
/// but any supplied value must be a well-formed 18-digit number.
String? validateNationalIdOptional(String? value) {
  if (!isRequired(value)) return null;
  if (!isNationalIdValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.nationalIdInvalid);
  }
  return null;
}

String? validateDate(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.dateRequired);
  }
  if (!isDateValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.dateInvalid);
  }
  return null;
}

String? validateGender(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.genderRequired);
  }
  if (!isGenderValid(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.genderInvalid);
  }
  return null;
}

String? validatePasswordConfirmation(String? value, String originalPassword) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(
      ValidationKeys.passwordConfirmRequired,
    );
  }
  if (value != originalPassword) {
    return ErrorMessages.getValidationMessage(
      ValidationKeys.passwordConfirmMismatch,
    );
  }
  return null;
}

/// Smallest / largest body weight (kg) accepted at registration. A generous
/// human range: below/above this is almost certainly a typo, so reject it
/// client-side with a clear message instead of waiting for the backend.
const double minWeightKg = 1;
const double maxWeightKg = 400;

/// Weight in kilograms. Required by the backend on registration; any supplied
/// value must be a number within [minWeightKg]..[maxWeightKg]. A comma decimal
/// separator (common on Arabic/French keyboards) is accepted as a dot.
String? validateWeight(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.weightRequired);
  }
  final parsed = double.tryParse(value!.trim().replaceAll(',', '.'));
  if (parsed == null || parsed < minWeightKg || parsed > maxWeightKg) {
    return ErrorMessages.getValidationMessage(ValidationKeys.weightInvalid);
  }
  return null;
}

String? validateCity(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.cityRequired);
  }
  if (!isValidWilaya(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.cityInvalid);
  }
  return null;
}
