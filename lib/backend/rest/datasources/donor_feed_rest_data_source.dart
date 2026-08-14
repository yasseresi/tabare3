import 'package:dio/dio.dart';

import '../../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../../features/donor_home/data/models/donor_feed_models.dart';
import '../constants/rest_paths.dart';

/// REST implementation of [DonorFeedRemoteDataSource] against the Django backend.
///
/// The full donor surface is implemented: availability, compatible requests,
/// campaigns, appointments (list/accept/cancel), donation history, and QR
/// redemption (request + campaign). Status vocabularies are translated to the
/// app's enums; fields Django does not expose (campaign published/created dates,
/// blood-types-needed) use documented fallbacks.
class DonorFeedRestDataSource implements DonorFeedRemoteDataSource {
  DonorFeedRestDataSource(this.dio);

  final Dio dio;

  @override
  Future<DonorAvailabilityModel> getAvailability() async {
    final response = await dio.get<Map<String, dynamic>>(RestPaths.profile);
    return _mapAvailability(response.data ?? const {});
  }

  @override
  Future<DonorAvailabilityModel> setAvailability(bool isAvailable) async {
    // Django exposes a *toggle*, not a setter: flip only when the current state
    // differs from the desired one, so repeat calls are idempotent.
    final current = await getAvailability();
    if (current.isAvailableForDonation != isAvailable) {
      await dio.post<Map<String, dynamic>>(RestPaths.toggleStatus);
    }
    return getAvailability();
  }

  @override
  Future<List<DonorBloodRequestModel>> listCompatibleRequests() async {
    // /feed/requests/ returns a plain array (already filtered to the donor).
    final response = await dio.get<List<dynamic>>(RestPaths.feedRequests);
    final rows = response.data ?? const [];
    return rows
        .whereType<Map<String, dynamic>>()
        .map(_mapDonorRequest)
        .toList(growable: false);
  }

  // --- later tasks ---

  @override
  Future<List<DonorCampaignModel>> listAvailableCampaigns() async {
    // /feed/campaigns/ returns a plain array (published campaigns for the donor).
    final response = await dio.get<List<dynamic>>(RestPaths.feedCampaigns);
    final rows = response.data ?? const [];
    return rows
        .whereType<Map<String, dynamic>>()
        .map(_mapCampaign)
        .toList(growable: false);
  }

  @override
  Future<List<DonorAppointmentModel>> listAppointments() async {
    // Paginated viewset, scoped server-side to the donor's own appointments.
    final rows = await _fetchAllPages(RestPaths.appointments);
    return rows.map(_mapAppointment).toList(growable: false);
  }

  @override
  Future<List<DonationRecordModel>> listDonationRecords() async {
    final rows = await _fetchAllPages(RestPaths.donations);
    return rows.map(_mapDonation).toList(growable: false);
  }

  @override
  Future<DonorAppointmentModel> acceptBloodRequest({
    required String requestId,
    required DateTime scheduledAt,
  }) async {
    // Django sets the schedule itself; the accept endpoint takes no body.
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.requestAccept(requestId),
    );
    return _mapAppointment(response.data ?? const {});
  }

  @override
  Future<DonorAppointmentModel> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    // Django's donor-cancel takes no body (fixed −5 pts, reason recorded server-side).
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.appointmentCancel(appointmentId),
    );
    return _mapAppointment(response.data ?? const {});
  }

  @override
  Future<DonationRecordModel> redeemQr(String token) async {
    // No unified endpoint exists; the scanned URL discriminates request vs
    // campaign. Manual bare tokens default to the request scan.
    if (token.contains('campaign')) return redeemCampaignQr(token);
    return redeemRequestQr(token);
  }

  @override
  Future<DonationRecordModel> redeemRequestQr(String token) async {
    // Body variant tolerates a scanned URL or a bare token.
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.donationScan,
      data: {'token': token},
    );
    return _mapDonation(response.data ?? const {});
  }

  @override
  Future<DonationRecordModel> redeemCampaignQr(String token) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.campaignScan(_bareToken(token)),
    );
    return _mapDonation(response.data ?? const {});
  }

  /// A scanned campaign QR is a URL (`…/campaigns/scan/<token>/`); the campaign
  /// scan endpoint wants the bare token in the path.
  String _bareToken(String token) {
    if (!token.contains('/')) return token;
    final trimmed = token.replaceAll(RegExp(r'/+$'), '');
    return trimmed.split('/').last;
  }

  // --- mapping ---

  DonorAvailabilityModel _mapAvailability(Map<String, dynamic> json) {
    final active = json['status']?.toString() == 'active';
    final wilaya = json['wilaya'];
    return DonorAvailabilityModel(
      userId: json['id']?.toString() ?? '',
      isAccountActive: active,
      // Django models availability as the single business `status`.
      isAvailableForDonation: active,
      isDonor: json['mode']?.toString() == 'donor',
      bloodType: _label(json['blood_type']),
      wilayaId: wilaya is Map<String, dynamic> ? _asInt(wilaya['id']) : null,
      cooldownUntil: _asDate(json['cooldown_until']),
      lastDonationDate: _asDate(json['last_donation_at']),
      totalDonationsCount: _asInt(json['donations_count']) ?? 0,
    );
  }

  DonorBloodRequestModel _mapDonorRequest(Map<String, dynamic> json) =>
      DonorBloodRequestModel(
        id: json['id']?.toString() ?? '',
        requestedBy: json['recipient']?.toString() ?? '',
        patientName: json['display_patient_name']?.toString(),
        hospital: _mapHospital(json['hospital']),
        bloodType: _label(json['blood_type']),
        urgency: json['priority']?.toString() ?? 'normal',
        unitsNeeded: _asInt(json['bags_required']) ?? 0,
        unitsFulfilled: _asInt(json['bags_filled']) ?? 0,
        status: _mapRequestStatus(json['status']?.toString()),
        neededBy: _asDate(json['deadline']),
        expiresAt: _asDate(json['deadline']),
        notes: json['notes']?.toString(),
        createdAt: _asDate(json['created_at']) ?? DateTime.now(),
      );

  DonorAppointmentModel _mapAppointment(Map<String, dynamic> json) =>
      DonorAppointmentModel(
        id: json['id']?.toString() ?? '',
        donorId: json['donor']?.toString() ?? '',
        // The Appointment serializer has no scheduled_at; it is booked on create.
        scheduledAt: _asDate(json['created_at']) ?? DateTime.now(),
        status: _mapAppointmentStatus(json['status']?.toString()),
        completedAt: _asDate(json['completed_at']),
        cancelledAt: _asDate(json['cancelled_at']),
        cancelReason: json['cancel_reason']?.toString(),
        createdAt: _asDate(json['created_at']) ?? DateTime.now(),
        // The serializer exposes only request id + hospital_name (no urgency /
        // needed_by / hospital object), so the ref is minimal.
        bloodRequest: json['request'] == null
            ? null
            : DonorAppointmentRequestRefModel(
                id: json['request'].toString(),
                hospital: null,
                bloodType: _label(json['blood_type']),
                urgency: 'normal',
                neededBy: null,
              ),
        campaign: null,
      );

  /// Django appointment vocabulary → the app's `DonationAppointmentStatus`.
  /// Django splits cancellation three ways; the app has a single `cancelled`.
  String _mapAppointmentStatus(String? status) => switch (status) {
    'pending' => 'pending',
    'completed' => 'completed',
    'cancelled_by_donor' ||
    'cancelled_by_recipient' ||
    'auto_cancelled' ||
    'cancelled' => 'cancelled',
    _ => 'pending',
  };

  Future<List<Map<String, dynamic>>> _fetchAllPages(String path) async {
    final all = <Map<String, dynamic>>[];
    String? url = path;
    while (url != null) {
      final response = await dio.get<Map<String, dynamic>>(url);
      final data = response.data ?? const {};
      final results = data['results'];
      if (results is List) {
        all.addAll(results.whereType<Map<String, dynamic>>());
      }
      url = data['next'] as String?;
    }
    return all;
  }

  DonorCampaignModel _mapCampaign(Map<String, dynamic> json) {
    final wilaya = json['wilaya'];
    final startsAt = _asDate(json['starts_at']) ?? DateTime.now();
    return DonorCampaignModel(
      id: json['id']?.toString() ?? '',
      createdBy: null,
      organizerName: json['organizer_label']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      venueName: json['location_text']?.toString(),
      city: wilaya is Map<String, dynamic>
          ? (wilaya['name_ar']?.toString() ?? '')
          : '',
      wilayaId: wilaya is Map<String, dynamic> ? (_asInt(wilaya['id']) ?? 0) : 0,
      hospitalId: json['hospital']?.toString(),
      bloodTypesNeeded: null, // urgent cases accept every group; no field
      status: _mapCampaignStatus(json['status']?.toString()),
      startsAt: startsAt,
      endsAt: _asDate(json['ends_at']) ?? startsAt,
      publishedAt: null, // not exposed by the campaign serializer
      createdAt: startsAt, // no created_at field; the start is the best proxy
    );
  }

  /// Django `draft/published/ended` → the app's `upcoming/active/completed`.
  String _mapCampaignStatus(String? status) => switch (status) {
    'draft' => 'upcoming',
    'published' => 'active',
    'ended' => 'completed',
    _ => 'active',
  };

  DonationRecordModel _mapDonation(Map<String, dynamic> json) {
    final requestId = json['request']?.toString();
    final campaignId = json['campaign']?.toString();
    return DonationRecordModel(
      id: json['id']?.toString() ?? '',
      donorId: json['donor']?.toString() ?? '',
      source: json['source_type']?.toString() ?? 'request',
      requestId: requestId,
      campaignId: campaignId,
      appointmentId: json['appointment']?.toString(),
      hospitalId: json['hospital']?.toString(),
      donatedAt: _asDate(json['donated_at']) ?? DateTime.now(),
      units: _asInt(json['bags_deducted']) ?? 1,
      bloodRequest: requestId == null
          ? null
          : DonationRecordRequestRefModel(
              id: requestId,
              recipient: json['patient_name'] == null
                  ? null
                  : DonationRecordRecipientModel(
                      fullName: json['patient_name'].toString(),
                    ),
              hospital: null,
            ),
      campaign: campaignId == null
          ? null
          : DonationRecordCampaignRefModel(
              id: campaignId,
              title: json['campaign_title']?.toString() ?? '',
              venueName: json['place_label']?.toString(),
              city: json['wilaya_name']?.toString() ?? '',
            ),
    );
  }

  DonorHospitalModel _mapHospital(dynamic json) {
    final map = json is Map<String, dynamic> ? json : const <String, dynamic>{};
    return DonorHospitalModel(
      id: map['id']?.toString() ?? '',
      wilayaId: _asInt(map['wilaya']) ?? 0,
      nameAr: map['name']?.toString() ?? '',
      nameFr: map['name_fr']?.toString(),
      address: map['address']?.toString(),
      isActive: map['is_active'] != false,
    );
  }

  /// Django `active/completed/cancelled` → the donor app's
  /// `open/fulfilled/cancelled`.
  String _mapRequestStatus(String? status) => switch (status) {
    'active' => 'open',
    'completed' => 'fulfilled',
    'cancelled' => 'cancelled',
    _ => 'open',
  };

  String _label(dynamic v) => v is Map<String, dynamic>
      ? (v['label']?.toString() ?? '')
      : (v?.toString() ?? '');

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }
}
