import '../core/backend/backend.dart';
import 'rest/rest_backend.dart';

/// The backend the app runs against.
///
/// **Full cutover:** the app now runs entirely on the Django REST API. Every
/// feature data source is served by [RestBackend]; Supabase is no longer booted
/// or called at runtime.
///
/// `HybridBackend` (with a `BackendFeature` set) remains in the tree as a
/// per-feature rollback path until the Supabase data sources are deleted in the
/// follow-up. To fall back, swap this line for a `HybridBackend(restFeatures:…)`.
final Backend activeBackend = RestBackend();
