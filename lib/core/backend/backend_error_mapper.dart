import '../error/failures.dart';

/// What the app was doing when the backend raised the error.
///
/// The same backend error carries different meaning per operation: `user not
/// found` during sign-in must never reach the user (it confirms the username
/// exists and narrows the guess down to the password), while the same class of
/// error during sign-up is legitimate and actionable. Mappers are told the
/// operation rather than having to guess it from the message.
enum BackendOperation {
  /// No operation-specific disclosure rules apply.
  generic,

  /// Credential check. Every auth error collapses into one generic message so
  /// the UI can never say which of the two factors was wrong.
  signIn,

  /// Account creation. Messages stay specific so the user can fix the field.
  signUp,
}

/// Translates backend-SDK-specific exceptions into domain [Failure]s.
///
/// Every backend implementation ships its own mapper so that `lib/core` and the
/// repositories never reference a vendor exception type.
abstract class BackendErrorMapper {
  /// Returns `null` when [error] is not a backend-specific error, letting the
  /// generic handler deal with it.
  ///
  /// [operation] carries the per-operation disclosure rules — see
  /// [BackendOperation].
  Failure? map(
    Object error, {
    BackendOperation operation = BackendOperation.generic,
  });
}
