import '../../core/backend/backend_error_mapper.dart';
import '../../core/error/failures.dart';
import '../rest/rest_error_mapper.dart';
import '../supabase/supabase_error_mapper.dart';

/// Delegates to both backend mappers so a hybrid build maps errors from
/// whichever backend produced them.
///
/// Each mapper returns `null` for errors it does not recognise (the REST mapper
/// ignores Supabase SDK exceptions and vice-versa), so trying them in turn is
/// safe: at most one claims any given error.
class HybridErrorMapper implements BackendErrorMapper {
  const HybridErrorMapper();

  static const _rest = RestErrorMapper();
  static const _supabase = SupabaseErrorMapper();

  @override
  Failure? map(
    Object error, {
    BackendOperation operation = BackendOperation.generic,
  }) {
    return _rest.map(error, operation: operation) ??
        _supabase.map(error, operation: operation);
  }
}
