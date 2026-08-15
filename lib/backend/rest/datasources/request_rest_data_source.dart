import 'package:dio/dio.dart';

import '../../../features/requester_home/data/datasources/request_remote_data_source.dart';
import '../../../features/requester_home/data/models/request_models.dart';
import '../../../features/requester_home/domain/entities/blood_request_entity.dart';
import '../constants/rest_paths.dart';
import '../reference/reference_resolver.dart';
import '../rest_error_mapper.dart' show RestValidationException;
import '../rest_paginator.dart';

/// REST implementation of [RequestRemoteDataSource] against the Django backend.
///
/// The Django `Request` resource is shaped differently from the Supabase model
/// (`priority` vs `urgency`, `bags_required` vs `units_needed`, `request_for`
/// vs `beneficiary_type`, nested `blood_type`/`hospital` objects), and its
/// status vocabulary differs (`active/completed/cancelled` vs the app's
/// `open/fulfilled/cancelled/expired`), so responses are mapped field-by-field.
///
/// The full surface is implemented: read (list/detail/hospitals), write
/// (create/update/cancel), donor matching (`matching-donors`), accepted donors
/// (`/appointments/?request=`), invitations (`/invitations/`, invite), and the
/// request QR (`qr_token`, embedded in the request resource). Where Django
/// exposes no equivalent field (invitation expiry, donor cooldown, a
/// QR-specific expiry) a documented fallback is used.
class RequestRestDataSource implements RequestRemoteDataSource {
  RequestRestDataSource(this.dio, {required this.reference});

  final Dio dio;
  final ReferenceResolver reference;

  @override
  Future<List<BloodRequestModel>> listOwnRequests() async {
    final response = await dio.get<Map<String, dynamic>>(RestPaths.requests);
    final results = response.data?['results'];
    if (results is! List) return const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(_mapRequest)
        .toList(growable: false);
  }

  @override
  Future<BloodRequestModel> getRequest(String requestId) async {
    final response = await dio.get<Map<String, dynamic>>(
      RestPaths.request(requestId),
    );
    return _mapRequest(response.data ?? const {});
  }

  @override
  Future<List<HospitalModel>> listHospitals() async {
    final rows = await fetchAllPages(dio,RestPaths.refHospitals);
    return rows.map(_mapHospital).toList(growable: false);
  }

  @override
  Future<BloodRequestModel> createRequest(RequestDraft draft) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.requests,
      data: await _createBody(draft),
    );
    return _mapRequest(response.data ?? const {});
  }

  @override
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  }) async {
    // PATCH only accepts hospital/priority/bags_required/deadline/notes.
    final response = await dio.patch<Map<String, dynamic>>(
      RestPaths.request(requestId),
      data: {
        'hospital': int.tryParse(draft.hospitalId),
        'priority': draft.priority.databaseValue,
        'bags_required': draft.unitsNeeded,
        'deadline': _isoDate(draft.neededBy),
        'notes': draft.notes,
      },
    );
    return _mapRequest(response.data ?? const {});
  }

  @override
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      RestPaths.requestCancel(requestId),
      data: {'reason': reason},
    );
    return _mapRequest(response.data ?? const {});
  }

  Future<Map<String, dynamic>> _createBody(RequestDraft draft) async {
    final patient = draft.patient;
    final bloodTypeId = await reference.bloodTypeIdForLabel(draft.bloodType);
    if (bloodTypeId == null) {
      throw RestValidationException('Unknown blood type: ${draft.bloodType}');
    }
    return {
      'request_for': draft.beneficiaryType.databaseValue,
      'hospital': int.tryParse(draft.hospitalId),
      'blood_type': bloodTypeId,
      'priority': draft.priority.databaseValue,
      'bags_required': draft.unitsNeeded,
      'deadline': _isoDate(draft.neededBy),
      'notes': draft.notes,
      if (patient != null) ...{
        'patient_name': patient.fullName,
        'patient_gender': patient.gender,
        'patient_date_of_birth': patient.dateOfBirth,
        'patient_weight_kg': patient.weight.toString(),
      },
    };
  }

  String? _isoDate(DateTime? d) {
    if (d == null) return null;
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<List<RequestDonorModel>> listRequestDonors(String requestId) async {
    // Accepted donors are the appointments booked against this request.
    final rows = await fetchAllPages(dio,
      RestPaths.appointments,
      query: {'request': requestId},
    );
    return rows.map(_mapRequestDonor).toList(growable: false);
  }

  @override
  Future<List<CompatibleDonorModel>> listCompatibleDonors(
    String requestId,
  ) async {
    final rows = await fetchAllPages(dio,RestPaths.requestMatchingDonors(requestId));
    return Future.wait(rows.map(_mapCompatibleDonor));
  }

  @override
  Future<List<DirectInvitationModel>> listInvitations(String requestId) async {
    final rows = await fetchAllPages(dio,
      RestPaths.invitations,
      query: {'request': requestId},
    );
    return rows.map(_mapInvitation).toList(growable: false);
  }

  @override
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  }) async {
    await dio.post<Map<String, dynamic>>(
      RestPaths.requestInvite(requestId),
      data: {'donor_id': donorId},
    );
  }

  @override
  Future<IssuedRequestQrModel> issueRequestQr(String requestId) async {
    // The QR token is embedded in the request resource; no separate call.
    final response = await dio.get<Map<String, dynamic>>(
      RestPaths.request(requestId),
    );
    final json = response.data ?? const {};
    return IssuedRequestQrModel(
      token: json['qr_token']?.toString() ?? '',
      // Django exposes no QR-specific expiry; the request deadline bounds it.
      expiresAt: _asDate(json['deadline']) ?? DateTime.now(),
    );
  }

  // --- mapping ---

  RequestDonorModel _mapRequestDonor(Map<String, dynamic> json) =>
      RequestDonorModel(
        donorId: json['donor']?.toString() ?? '',
        fullName: json['donor_name']?.toString() ?? '',
        bloodType: _label(json['blood_type']),
        appointmentId: json['id']?.toString() ?? '',
        status: _mapAppointmentStatus(json['status']?.toString()),
        scheduledAt: _asDate(json['created_at']) ?? DateTime.now(),
        completedAt: _asDate(json['completed_at']),
      );

  /// Django appointment vocabulary → the app's `DonationAppointmentStatus`.
  /// Django splits cancellation three ways (`cancelled_by_donor`,
  /// `cancelled_by_recipient`, `auto_cancelled`); the app has a single
  /// `cancelled`. Anything unknown maps to `pending` so `toEntity()` never
  /// throws on an unrecognised status.
  String _mapAppointmentStatus(String? status) => switch (status) {
    'pending' => 'pending',
    'completed' => 'completed',
    'cancelled_by_donor' ||
    'cancelled_by_recipient' ||
    'auto_cancelled' ||
    'cancelled' => 'cancelled',
    _ => 'pending',
  };

  Future<CompatibleDonorModel> _mapCompatibleDonor(
    Map<String, dynamic> json,
  ) async => CompatibleDonorModel(
    donorId: json['id']?.toString() ?? '',
    fullName: json['full_name']?.toString() ?? '',
    bloodType: _label(json['blood_type']),
    // PublicDonor exposes the wilaya name, not its id — resolve it back.
    wilayaId: await reference.wilayaIdForName(
          json['wilaya_name']?.toString() ?? '',
        ) ??
        0,
    cooldownUntil: null, // not exposed by the matching endpoint
  );

  DirectInvitationModel _mapInvitation(Map<String, dynamic> json) {
    final sentAt = _asDate(json['sent_at']) ?? DateTime.now();
    return DirectInvitationModel(
      invitationId: json['id']?.toString() ?? '',
      donorId: json['donor']?.toString() ?? '',
      fullName: json['donor_name']?.toString() ?? '',
      bloodType: _label(json['blood_type']),
      status: json['status']?.toString() ?? '',
      appointmentId: json['appointment']?.toString(),
      // Django does not expose an invitation expiry; fall back to sent time.
      expiresAt: sentAt,
      respondedAt: _asDate(json['responded_at']),
      createdAt: sentAt,
    );
  }

  BloodRequestModel _mapRequest(Map<String, dynamic> json) {
    final hospital = json['hospital'];
    final bloodType = json['blood_type'];
    final isForOther = json['request_for']?.toString() == 'other' ||
        json['is_for_someone_else'] == true;
    return BloodRequestModel(
      id: json['id']?.toString() ?? '',
      requestedBy: json['recipient']?.toString() ?? '',
      hospital: hospital is Map<String, dynamic> ? _mapHospital(hospital) : null,
      beneficiaryType: isForOther ? 'other' : 'self',
      patient: isForOther ? _mapPatient(json) : null,
      bloodType: _label(bloodType),
      urgency: json['priority']?.toString() ?? 'normal',
      unitsNeeded: _asInt(json['bags_required']) ?? 0,
      unitsFulfilled: _asInt(json['bags_filled']) ?? 0,
      status: _mapStatus(json['status']?.toString()),
      neededBy: _asDate(json['deadline']),
      expiresAt: _asDate(json['deadline']),
      notes: json['notes']?.toString(),
      createdAt: _asDate(json['created_at']) ?? DateTime.now(),
    );
  }

  HospitalModel _mapHospital(Map<String, dynamic> json) => HospitalModel(
    id: json['id']?.toString() ?? '',
    wilayaId: _asInt(json['wilaya']) ?? 0,
    nameAr: json['name']?.toString() ?? '',
    nameFr: json['name_fr']?.toString(),
    address: json['address']?.toString(),
    isActive: json['is_active'] != false,
  );

  PatientModel _mapPatient(Map<String, dynamic> json) => PatientModel(
    fullName: json['patient_name']?.toString() ?? '',
    nationalId: json['patient_national_id']?.toString() ?? '',
    bloodType: _label(json['blood_type']),
    weight: _asDouble(json['patient_weight_kg']) ?? 0,
    chronicDiseases: _conditionsToString(json['patient_conditions']),
    gender: json['patient_gender']?.toString() ?? '',
    dateOfBirth: json['patient_date_of_birth']?.toString() ?? '',
  );

  /// Django uses `active/completed/cancelled`; the app model expects
  /// `open/fulfilled/cancelled/expired`.
  String _mapStatus(String? status) => switch (status) {
    'active' => 'open',
    'completed' => 'fulfilled',
    'cancelled' => 'cancelled',
    _ => 'open',
  };

  String _label(dynamic bloodType) => bloodType is Map<String, dynamic>
      ? (bloodType['label']?.toString() ?? '')
      : (bloodType?.toString() ?? '');

  String? _conditionsToString(dynamic conditions) {
    if (conditions is! List || conditions.isEmpty) return null;
    final names = conditions
        .whereType<Map<String, dynamic>>()
        .map((c) => c['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty);
    return names.isEmpty ? null : names.join('، ');
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }
}
