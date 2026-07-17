import '../utils/error_messages.dart';

bool isUsernameValid(String? username) =>
    username != null && username.trim().length >= 3;

bool isFullNameValid(String? fullName) =>
    fullName != null && fullName.trim().isNotEmpty;

bool isPhoneValid(String? phone) =>
    phone != null && RegExp(r'^0\d{9}$').hasMatch(phone.replaceAll(RegExp(r'\s+'), ''));

bool isPasswordValid(String? password) =>
    password != null && password.length >= 8;

bool isDateValid(String? date) =>
    date != null && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date.trim());

bool isGenderValid(String? gender) =>
    gender != null &&
    (gender.trim() == 'ذكر' || gender.trim() == 'أنثى');

bool isNumeric(String? value) =>
    value != null && RegExp(r'^\d+$').hasMatch(value.trim());

bool isFloat(String? value) =>
    value != null && RegExp(r'^\d+(\.\d+)?$').hasMatch(value.trim());

bool isRequired(String? value) =>
    value != null && value.trim().isNotEmpty;

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
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordConfirmRequired);
  }
  if (value != originalPassword) {
    return ErrorMessages.getValidationMessage(ValidationKeys.passwordConfirmMismatch);
  }
  return null;
}

String? validateCity(String? value) {
  if (!isRequired(value)) {
    return ErrorMessages.getValidationMessage(ValidationKeys.cityRequired);
  }
  return null;
}
