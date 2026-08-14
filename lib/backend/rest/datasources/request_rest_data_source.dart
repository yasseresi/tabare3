import 'package:dio/dio.dart';

import '../../../features/requester_home/data/datasources/request_remote_data_source.dart';
import '../../../features/requester_home/data/models/request_models.dart';
import '../../../features/requester_home/domain/entities/blood_request_entity.dart';
import '../constants/rest_paths.dart';

/// REST implementation of [RequestRemoteDataSource] against the Django backend.
///
/// The Django `Request` resource is shaped differently from the Supabase model
/// (`priority` vs `urgency`, `bags_required` vs `units_needed`, `request_for`
/// vs `beneficiary_type`, nested `blood_type`/`hospital` objects), and its
/// status vocabulary differs (`active/completed/cancelled` vs the app's
/// `open/fulfilled/cancelled/expired`), so responses are mapped field-by-field.
///
/// Read path (`listOwnRequests`, `getRequest`) is implemented; the write /
/// donor-matching / invitation / QR methods land in later migration slices and
/// still throw until then — the `requests` feature flag stays on Supabase until
/// the whole surface is done.
class RequestRestDataSource implements RequestRemoteDataSource {
  RequestRestDataSource(this.dio);

  final Dio dio;

  Never _todo(String endpoint) =>
      throw UnimplementedError('REST backend: $endpoint not implemented yet');

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
  Future<List<HospitalModel>> listHospitals() async =>
      _todo('GET /references/hospitals/ (paginated)');

  @override
  Future<BloodRequestModel> createRequest(RequestDraft draft) async =>
      _todo('POST /requests/');

  @override
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  }) async => _todo('PATCH /requests/{id}/');

  @override
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  }) async => _todo('POST /requests/{id}/cancel/');

  @override
  Future<List<RequestDonorModel>> listRequestDonors(String requestId) async =>
      _todo('GET /requests/{id}/ donors');

  @override
  Future<List<CompatibleDonorModel>> listCompatibleDonors(
    String requestId,
  ) async => _todo('GET /requests/{id}/matching-donors/');

  @override
  Future<List<DirectInvitationModel>> listInvitations(String requestId) async =>
      _todo('GET /invitations/');

  @override
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  }) async => _todo('POST /requests/{id}/invite/');

  @override
  Future<IssuedRequestQrModel> issueRequestQr(String requestId) async =>
      _todo('POST request QR');

  // --- mapping ---

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
