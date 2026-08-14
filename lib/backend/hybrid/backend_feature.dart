/// A feature whose remote data source can be served by REST instead of Supabase.
///
/// The migration flips one of these at a time (see `HybridBackend`): a feature
/// in the enabled set is bound to its REST implementation, every other feature
/// keeps its Supabase implementation. This is how Supabase and the REST API
/// coexist in one build during the cutover.
enum BackendFeature {
  auth,
  profile,
  requests,
  notifications,
  donorCard,
  donorFeed,
}
