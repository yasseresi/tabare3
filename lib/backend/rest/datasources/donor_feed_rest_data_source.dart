import 'package:dio/dio.dart';

import '../../../features/donor_home/data/datasources/donor_feed_remote_data_source.dart';
import '../../../features/donor_home/data/models/donor_feed_models.dart';
import '../constants/rest_paths.dart';

/// REST implementation of [DonorFeedRemoteDataSource] against the Django backend.
///
/// Feed core is live (availability, compatible requests); appointments,
/// campaigns, donation history and QR redemption land in later tasks and still
/// throw. The `donor_feed` flag stays on Supabase until the whole surface is done.
class DonorFeedRestDataSource implements DonorFeedRemoteDataSource {
  DonorFeedRestDataSource(this.dio);

  final Dio dio;

  Never _todo(String endpoint) =>
      throw UnimplementedError('REST backend: $endpoint not implemented yet');

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
  Future<List<DonorCampaignModel>> listAvailableCampaigns() async =>
      _todo('GET /feed/campaigns/');

  @override
  Future<List<DonorAppointmentModel>> listAppointments() async {
    // Paginated viewset, scoped server-side to the donor's own appointments.
    final rows = await _fetchAllPages(RestPaths.appointments);
    return rows.map(_mapAppointment).toList(growable: false);
  }

  @override
  Future<List<DonationRecordModel>> listDonationRecords() async =>
      _todo('GET /donations/');

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
  Future<DonationRecordModel> redeemQr(String token) async =>
      _todo('POST donation scan');

  @override
  Future<DonationRecordModel> redeemRequestQr(String token) async =>
      _todo('POST /donations/scan/{token}/');

  @override
  Future<DonationRecordModel> redeemCampaignQr(String token) async =>
      _todo('POST /campaigns/scan/{token}/');

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
