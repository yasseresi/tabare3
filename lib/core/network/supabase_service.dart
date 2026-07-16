import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/env_constants.dart';

class SupabaseService {
  SupabaseService._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConstants.supabaseUrl,
      publishableKey: EnvConstants.supabasePublishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
