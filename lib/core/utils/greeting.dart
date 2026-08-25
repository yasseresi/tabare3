import 'package:easy_localization/easy_localization.dart';

import '../session/session_manager.dart';
import '../../injection_container.dart';
import 'string_manager.dart';

/// Full name of the signed-in user, or an empty string when unknown.
///
/// Guards against the service locator not having a [SessionManager] registered
/// (e.g. in widget tests that skip DI setup) so callers always get a value.
String currentUserFullName() {
  if (!sl.isRegistered<SessionManager>()) return '';
  return sl<SessionManager>().currentUser?.fullName.trim() ?? '';
}

/// Blood type of the signed-in user, or an empty string when unknown.
///
/// Guards against the service locator not having a [SessionManager] registered
/// (e.g. in widget tests that skip DI setup) so callers always get a value.
String currentUserBloodType() {
  if (!sl.isRegistered<SessionManager>()) return '';
  return sl<SessionManager>().currentUser?.bloodType.trim() ?? '';
}

/// 1-based Algerian wilaya id of the signed-in user, or null when unknown.
///
/// Guards against the service locator not having a [SessionManager] registered
/// (e.g. in widget tests that skip DI setup) so callers always get a value.
int? currentUserWilayaId() {
  if (!sl.isRegistered<SessionManager>()) return null;
  return sl<SessionManager>().currentUser?.wilayaId;
}

/// Localized header greeting for the signed-in user, e.g. `مرحباً، أحمد`.
///
/// Falls back to a plain welcome when no user name is available (e.g. before a
/// session is restored) so the header never renders a placeholder name.
String welcomeTitle() {
  final fullName = currentUserFullName();
  if (fullName.isEmpty) return AppStrings.welcome.tr();
  final firstName = fullName.split(RegExp(r'\s+')).first;
  return AppStrings.welcomeUser.tr(namedArgs: {'name': firstName});
}
