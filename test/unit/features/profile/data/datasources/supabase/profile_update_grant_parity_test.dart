import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/auth/data/datasources/supabase/auth_supabase_data_source.dart';
import 'package:tabare3/features/profile/data/datasources/supabase/profile_supabase_data_source.dart';
import 'package:tabare3/features/profile/data/models/profile_model.dart';

/// `public.users` has no table-wide UPDATE grant for `authenticated` — the
/// hardening migration revoked it and re-granted an explicit column allow-list.
/// Postgres rejects the whole statement when the payload touches a column
/// outside that list ("permission denied for column ..."), and RLS never even
/// runs. So every key the app writes must appear in the granted columns, or
/// saving a profile fails at runtime for every user.
///
/// This test reads the migrations directly so a column added to the payload
/// without a matching grant (or a grant removed from under the payload) fails
/// here instead of in production.
void main() {
  const profile = ProfileModel(
    id: 'user-id',
    email: 'user@example.com',
    username: 'user',
    fullName: 'Immutable Name',
    phone: '0550000000',
    dateOfBirth: '2000-01-01',
    gender: 'male',
    nationalId: 'immutable-id',
    bloodType: 'O+',
    weight: 72,
    city: 'الجزائر',
    chronicDiseases: null,
    avatarUrl: 'avatar.png',
    isDonor: true,
    isRecipient: false,
    isActive: false,
  );

  test('every profile update payload column is granted to authenticated', () {
    final granted = _grantedUpdateColumns();

    expect(
      granted,
      isNotEmpty,
      reason: 'no column-level UPDATE grants parsed from the migrations — the '
          'parser is out of sync with the migration SQL',
    );

    final payloadColumns = buildProfileUpdatePayload(profile).keys.toSet();
    final ungranted = payloadColumns.difference(granted);

    expect(
      ungranted,
      isEmpty,
      reason: 'buildProfileUpdatePayload writes $ungranted, which authenticated '
          'may not update. Add a migration granting these columns on '
          'public.users, or drop them from the payload.',
    );
  });

  test('role change only writes columns granted to authenticated', () {
    final granted = _grantedUpdateColumns();
    final roleColumns = buildRoleUpdatePayload(
      isDonor: true,
      isRecipient: false,
    ).keys.toSet();

    expect(roleColumns.difference(granted), isEmpty);
  });

  test('donor availability toggle writes a granted column', () {
    // DonorFeedSupabaseDataSource.setAvailability updates this column inline.
    expect(_grantedUpdateColumns(), contains('is_available_for_donation'));
  });
}

/// Columns `authenticated` may UPDATE on `public.users`, replayed from the
/// migration files in filename (chronological) order.
Set<String> _grantedUpdateColumns() {
  final grant = RegExp(
    r'grant\s+update\s*\(([^)]*)\)\s*on\s+(?:table\s+)?public\.users\s+to\s+[^;]*authenticated',
    caseSensitive: false,
    dotAll: true,
  );
  // A table-wide revoke wipes any column grants issued before it.
  final revoke = RegExp(
    r'revoke\s+[^;]*update[^;]*\s+on\s+(?:table\s+)?public\.users\s+from\s+[^;]*authenticated',
    caseSensitive: false,
    dotAll: true,
  );

  final files =
      Directory('supabase/migrations')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.sql'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final granted = <String>{};
  for (final file in files) {
    // Statements are applied in order within a file too, so walk the
    // grant/revoke sites by position rather than one pattern at a time.
    final sql = file.readAsStringSync();
    final events = <MapEntry<int, String?>>[
      for (final m in revoke.allMatches(sql)) MapEntry(m.start, null),
      for (final m in grant.allMatches(sql)) MapEntry(m.start, m.group(1)),
    ]..sort((a, b) => a.key.compareTo(b.key));

    for (final event in events) {
      if (event.value == null) {
        granted.clear();
        continue;
      }
      granted.addAll(
        event.value!
            .split(',')
            .map((c) => c.trim())
            .where((c) => c.isNotEmpty),
      );
    }
  }
  return granted;
}
