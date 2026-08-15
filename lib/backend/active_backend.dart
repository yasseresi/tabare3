import '../core/backend/backend.dart';
import 'hybrid/backend_feature.dart';
import 'hybrid/hybrid_backend.dart';

/// The backend the app runs against.
///
/// During the Supabase → REST migration this is a [HybridBackend]: features
/// listed in [_restFeatures] are served by the REST API, everything else stays
/// on Supabase. Flip a feature by adding its [BackendFeature] here once its REST
/// data source is implemented and verified live.
///
/// Empty set == fully on Supabase (behaviour identical to the old
/// `SupabaseBackend`).
const Set<BackendFeature> _restFeatures = {
  BackendFeature.auth,
  BackendFeature.profile,
  BackendFeature.requests,
  BackendFeature.donorFeed,
  BackendFeature.donorCard,
  BackendFeature.notifications,
};

final Backend activeBackend = HybridBackend(restFeatures: _restFeatures);
