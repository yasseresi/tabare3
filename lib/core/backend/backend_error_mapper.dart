import '../error/failures.dart';

/// Translates backend-SDK-specific exceptions into domain [Failure]s.
///
/// Every backend implementation ships its own mapper so that `lib/core` and the
/// repositories never reference a vendor exception type.
abstract class BackendErrorMapper {
  /// Returns `null` when [error] is not a backend-specific error, letting the
  /// generic handler deal with it.
  Failure? map(Object error);
}
