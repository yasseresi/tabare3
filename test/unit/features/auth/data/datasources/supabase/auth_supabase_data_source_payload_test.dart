import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/auth/data/datasources/supabase/auth_supabase_data_source.dart';

void main() {
  test(
    'role payload keeps transition flags and canonical active mode aligned',
    () {
      expect(buildRoleUpdatePayload(isDonor: true, isRecipient: false), {
        'is_donor': true,
        'is_recipient': false,
        'active_mode': 'donor',
      });

      expect(buildRoleUpdatePayload(isDonor: false, isRecipient: true), {
        'is_donor': false,
        'is_recipient': true,
        'active_mode': 'recipient',
      });
    },
  );
}
