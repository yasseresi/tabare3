import 'package:flutter_test/flutter_test.dart';
import 'package:tabare3/features/donor_home/data/models/donor_feed_models.dart';
import 'package:tabare3/features/donor_home/domain/entities/donor_feed_entity.dart';

void main() {
  const hospitalJson = {
    'id': 'hospital-1',
    'wilaya_id': 16,
    'name_ar': 'مستشفى مصطفى باشا',
    'name_fr': 'Mustapha Pacha',
    'address': 'الجزائر',
    'is_active': true,
  };

  test('availability model maps server-managed eligibility fields', () {
    final model = DonorAvailabilityModel.fromJson({
      'id': 'donor-1',
      'is_active': true,
      'is_available_for_donation': false,
      'is_donor': true,
      'blood_type': 'O+',
      'wilaya_id': 16,
      'cooldown_until': '2030-01-12',
      'last_donation_date': '2030-01-01',
      'total_donations_count': 7,
    });

    final entity = model.toEntity();
    expect(entity.isAvailableForDonation, false);
    expect(entity.cooldownUntil, DateTime.parse('2030-01-12'));
    expect(entity.totalDonationsCount, 7);
  });

  test('blood request model maps nested hospital and canonical priority', () {
    final model = DonorBloodRequestModel.fromJson({
      'id': 'request-1',
      'requested_by': 'recipient-1',
      'hospital': hospitalJson,
      'blood_type': 'A+',
      'urgency': 'semi_urgent',
      'units_needed': 3,
      'units_fulfilled': 1,
      'status': 'open',
      'needed_by': '2030-01-12T00:00:00.000Z',
      'expires_at': '2030-01-13T00:00:00.000Z',
      'notes': 'ملاحظة',
      'created_at': '2030-01-10T00:00:00.000Z',
    });

    final entity = model.toEntity();
    expect(entity.priority, DonorRequestPriority.semiUrgent);
    expect(entity.remainingUnits, 2);
    expect(entity.hospital.nameAr, 'مستشفى مصطفى باشا');
  });

  test('campaign and appointment models map backend rows', () {
    final campaign = DonorCampaignModel.fromJson({
      'id': 'campaign-1',
      'created_by': 'admin-1',
      'organizer_name': 'جمعية تبرع',
      'title': 'حملة شتوية',
      'description': 'وصف',
      'venue_name': 'قاعة',
      'city': 'الجزائر',
      'wilaya_id': 16,
      'hospital_id': 'hospital-1',
      'blood_types_needed': ['O+', 'A+'],
      'status': 'active',
      'starts_at': '2030-01-10T08:00:00.000Z',
      'ends_at': '2030-01-10T18:00:00.000Z',
      'published_at': '2030-01-09T00:00:00.000Z',
      'created_at': '2030-01-08T00:00:00.000Z',
    });
    final appointment = DonorAppointmentModel.fromJson({
      'id': 'appointment-1',
      'donor_id': 'donor-1',
      'scheduled_at': '2030-01-11T10:00:00.000Z',
      'status': 'confirmed',
      'completed_at': null,
      'cancelled_at': null,
      'cancel_reason': null,
      'created_at': '2030-01-10T00:00:00.000Z',
      'blood_request': {
        'id': 'request-1',
        'hospital': hospitalJson,
        'blood_type': 'O+',
        'urgency': 'urgent',
        'needed_by': '2030-01-12T00:00:00.000Z',
      },
      'campaign': null,
    });

    expect(campaign.toEntity().status, DonorCampaignStatus.active);
    expect(
      appointment.toEntity().bloodRequest?.priority,
      DonorRequestPriority.urgent,
    );
  });

  test('record model and RPC payloads preserve backend contracts', () {
    final record = DonationRecordModel.fromJson({
      'id': 'record-1',
      'donor_id': 'donor-1',
      'source': 'campaign',
      'request_id': null,
      'campaign_id': 'campaign-1',
      'appointment_id': null,
      'hospital_id': 'hospital-1',
      'donated_at': '2030-01-10T12:00:00.000Z',
      'units': 1,
    });

    expect(record.toEntity().source, DonationSource.campaign);
    expect(
      buildAcceptBloodRequestRpcPayload(
        requestId: 'request-1',
        scheduledAt: DateTime.utc(2030, 1, 12, 9),
      ),
      {
        'p_request_id': 'request-1',
        'p_scheduled_at': '2030-01-12T09:00:00.000Z',
      },
    );
    expect(
      buildCancelAppointmentRpcPayload(
        appointmentId: 'appointment-1',
        reason: 'ازدحام',
      ),
      {'p_appointment_id': 'appointment-1', 'p_reason': 'ازدحام'},
    );
    expect(buildRedeemDonationQrRpcPayload('opaque-token'), {
      'p_token': 'opaque-token',
    });
  });
}
