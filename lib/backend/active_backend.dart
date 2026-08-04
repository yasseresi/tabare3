import '../core/backend/backend.dart';
import 'supabase/supabase_backend.dart';

/// The backend the app runs against.
///
/// Single switch point for a backend migration: implement [Backend] under
/// `lib/backend/<name>/` and change this one line.
const Backend activeBackend = SupabaseBackend();
