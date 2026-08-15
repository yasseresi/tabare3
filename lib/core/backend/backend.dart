import 'package:get_it/get_it.dart';

import 'backend_error_mapper.dart';

/// Contract for the remote backend the app talks to.
///
/// The rest of the app depends on this abstraction only. A backend SDK
/// (Supabase, a custom REST client, ...) may be imported **only** inside
/// `lib/backend/<name>/` and the data sources it registers.
///
/// Migrating to another backend means:
///   1. adding `lib/backend/<name>/` with a [Backend] implementation,
///   2. implementing each feature's `*RemoteDataSource` contract there,
///   3. pointing `lib/backend/active_backend.dart` at the new [Backend].
abstract class Backend {
  /// Human-readable identifier, used for logs and diagnostics.
  String get name;

  /// Boots the backend SDK. Called once from `main()` before DI setup.
  Future<void> initialize();

  /// Maps backend exceptions to domain failures.
  BackendErrorMapper get errorMapper;

  /// Registers this backend's remote data source implementations against the
  /// abstract contracts declared by each feature.
  Future<void> registerDataSources(GetIt sl);
}
