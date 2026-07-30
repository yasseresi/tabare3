import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/donor_home/data/datasources/donor_feed_remote_data_source.dart';

void main() {
  test(
    'availability and request select columns keep server-managed fields visible',
    () {
      expect(
        donorAvailabilitySelectColumns,
        contains('is_available_for_donation'),
      );
      expect(
        requestSelectColumns,
        contains('hospital:hospitals!blood_requests_hospital_id_fkey'),
      );
      expect(campaignSelectColumns, contains('blood_types_needed'));
      expect(
        appointmentSelectColumns,
        contains('blood_request:blood_requests'),
      );
    },
  );

  test('compatibility and eligibility are delegated to one backend RPC', () {
    expect(compatibleRequestsRpcName, 'compatible_requests_for_donor');
  });
}
