import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/donor_feed_models.dart';
import '../donor_feed_remote_data_source.dart';

const donorAvailabilitySelectColumns =
    'id,is_active,is_available_for_donation,is_donor,blood_type,wilaya_id,'
    'cooldown_until,last_donation_date,total_donations_count';

const compatibleRequestsRpcName = 'compatible_requests_for_donor';

const requestSelectColumns =
    'id,requested_by,blood_type,urgency,units_needed,units_fulfilled,status,'
    'needed_by,expires_at,notes,created_at,'
    'hospital:hospitals!blood_requests_hospital_id_fkey('
    'id,wilaya_id,name_ar,name_fr,address,is_active)';

const campaignSelectColumns =
    'id,created_by,organizer_name,title,description,venue_name,city,'
    'wilaya_id,hospital_id,blood_types_needed,status,starts_at,ends_at,'
    'published_at,created_at';

const appointmentSelectColumns =
    'id,donor_id,scheduled_at,status,completed_at,cancelled_at,cancel_reason,'
    'created_at,'
    'blood_request:blood_requests!appointments_blood_request_id_fkey('
    'id,blood_type,urgency,needed_by,'
    'hospital:hospitals!blood_requests_hospital_id_fkey('
    'id,wilaya_id,name_ar,name_fr,address,is_active)),'
    'campaign:campaigns!appointments_campaign_id_fkey('
    'id,title,organizer_name,starts_at,ends_at)';

const donationRecordSelectColumns =
    'id,donor_id,source,request_id,campaign_id,appointment_id,hospital_id,'
    'donated_at,units,'
    'blood_request:blood_requests!donation_records_request_id_fkey('
    'id,recipient:users!blood_requests_requested_by_fkey(full_name),'
    'hospital:hospitals!blood_requests_hospital_id_fkey('
    'id,wilaya_id,name_ar,name_fr,address,is_active)),'
    'campaign:campaigns!donation_records_campaign_id_fkey('
    'id,title,venue_name,city)';

class DonorFeedSupabaseDataSource implements DonorFeedRemoteDataSource {
  final SupabaseClient client;

  DonorFeedSupabaseDataSource({required this.client});

  String get _userId => client.auth.currentUser!.id;

  @override
  Future<DonorAvailabilityModel> getAvailability() async {
    final row = await client
        .from('users')
        .select(donorAvailabilitySelectColumns)
        .eq('id', _userId)
        .single();

    return DonorAvailabilityModel.fromJson(row);
  }

  @override
  Future<DonorAvailabilityModel> setAvailability(bool isAvailable) async {
    final row = await client
        .from('users')
        .update({'is_available_for_donation': isAvailable})
        .eq('id', _userId)
        .select(donorAvailabilitySelectColumns)
        .single();

    return DonorAvailabilityModel.fromJson(row);
  }

  @override
  Future<List<DonorBloodRequestModel>> listCompatibleRequests() async {
    final response = await client.rpc(compatibleRequestsRpcName);
    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(DonorBloodRequestModel.fromJson)
        .toList();
  }

  @override
  Future<List<DonorCampaignModel>> listAvailableCampaigns() async {
    final availability = await getAvailability();
    if (!availability.isDonor) return const [];

    // Campaigns are matched by wilaya; a donor without one has nothing to match.
    final wilayaId = availability.wilayaId;
    if (wilayaId == null) return const [];

    final rows = await client
        .from('campaigns')
        .select(campaignSelectColumns)
        .eq('wilaya_id', wilayaId)
        .not('published_at', 'is', null)
        .inFilter('status', const ['upcoming', 'active'])
        .order('starts_at');

    final now = DateTime.now().toUtc();
    return rows
        .map(DonorCampaignModel.fromJson)
        .where(
          (campaign) =>
              campaign.publishedAt != null &&
              campaign.endsAt.isAfter(now) &&
              (campaign.bloodTypesNeeded == null ||
                  campaign.bloodTypesNeeded!.contains(availability.bloodType)),
        )
        .toList();
  }

  @override
  Future<List<DonorAppointmentModel>> listAppointments() async {
    final rows = await client
        .from('appointments')
        .select(appointmentSelectColumns)
        .eq('donor_id', _userId)
        .order('scheduled_at', ascending: false);

    return rows.map(DonorAppointmentModel.fromJson).toList();
  }

  @override
  Future<List<DonationRecordModel>> listDonationRecords() async {
    final rows = await client
        .from('donation_records')
        .select(donationRecordSelectColumns)
        .eq('donor_id', _userId)
        .order('donated_at', ascending: false);

    return rows.map(DonationRecordModel.fromJson).toList();
  }

  @override
  Future<DonorAppointmentModel> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  }) async {
    final response = await client.rpc(
      'accept_blood_request',
      params: buildAcceptBloodRequestRpcPayload(
        requestId: requestId,
        scheduledAt: scheduledAt,
      ),
    );

    return _getAppointment(_extractId(response));
  }

  @override
  Future<DonorAppointmentModel> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    final response = await client.rpc(
      'cancel_appointment',
      params: buildCancelAppointmentRpcPayload(
        appointmentId: appointmentId,
        reason: reason,
      ),
    );

    return _getAppointment(_extractId(response));
  }

  @override
  Future<DonationRecordModel> redeemRequestQr(String token) async {
    final response = await client.rpc(
      'redeem_request_qr',
      params: buildRedeemDonationQrRpcPayload(token),
    );
    return DonationRecordModel.fromJson(_extractRow(response));
  }

  @override
  Future<DonationRecordModel> redeemCampaignQr(String token) async {
    final response = await client.rpc(
      'redeem_campaign_qr',
      params: buildRedeemDonationQrRpcPayload(token),
    );
    return DonationRecordModel.fromJson(_extractRow(response));
  }

  Future<DonorAppointmentModel> _getAppointment(String appointmentId) async {
    final row = await client
        .from('appointments')
        .select(appointmentSelectColumns)
        .eq('id', appointmentId)
        .eq('donor_id', _userId)
        .single();

    return DonorAppointmentModel.fromJson(row);
  }
}

String _extractId(dynamic response) => _extractRow(response)['id'] as String;

Map<String, dynamic> _extractRow(dynamic response) {
  if (response is Map<String, dynamic>) {
    return response;
  }
  if (response is List && response.isNotEmpty) {
    return response.first as Map<String, dynamic>;
  }
  throw const FormatException('Supabase RPC returned no row');
}
