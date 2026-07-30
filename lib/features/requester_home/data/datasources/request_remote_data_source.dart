import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/blood_request_entity.dart';
import '../models/request_models.dart';

const requestSelectColumns =
    'id,requested_by,blood_type,urgency,units_needed,units_fulfilled,status,'
    'needed_by,expires_at,notes,created_at,'
    'hospital:hospitals!blood_requests_hospital_id_fkey('
    'id,wilaya_id,name_ar,name_fr,address,is_active)';

abstract class RequestRemoteDataSource {
  Future<List<BloodRequestModel>> listOwnRequests();
  Future<BloodRequestModel> getRequest(String requestId);
  Future<List<HospitalModel>> listHospitals();
  Future<BloodRequestModel> createRequest(RequestDraft draft);
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  });
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  });
  Future<List<RequestDonorModel>> listRequestDonors(String requestId);
  Future<List<CompatibleDonorModel>> listCompatibleDonors(String requestId);
  Future<List<DirectInvitationModel>> listInvitations(String requestId);
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  });
  Future<IssuedRequestQrModel> issueRequestQr(String requestId);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final SupabaseClient client;

  RequestRemoteDataSourceImpl({required this.client});

  String get _userId => client.auth.currentUser!.id;

  @override
  Future<List<BloodRequestModel>> listOwnRequests() async {
    final rows = await client
        .from('blood_requests')
        .select(requestSelectColumns)
        .eq('requested_by', _userId)
        .order('created_at', ascending: false);

    return rows.map(BloodRequestModel.fromJson).toList();
  }

  @override
  Future<BloodRequestModel> getRequest(String requestId) async {
    final row = await client
        .from('blood_requests')
        .select(requestSelectColumns)
        .eq('id', requestId)
        .eq('requested_by', _userId)
        .single();

    return BloodRequestModel.fromJson(row);
  }

  @override
  Future<List<HospitalModel>> listHospitals() async {
    final rows = await client
        .from('hospitals')
        .select('id,wilaya_id,name_ar,name_fr,address,is_active')
        .eq('is_active', true)
        .order('name_ar');

    return rows.map(HospitalModel.fromJson).toList();
  }

  @override
  Future<BloodRequestModel> createRequest(RequestDraft draft) async {
    final response = await client.rpc(
      'create_blood_request',
      params: buildRequestRpcPayload(draft),
    );
    return getRequest(_extractRequestId(response));
  }

  @override
  Future<BloodRequestModel> updateRequest({
    required String requestId,
    required RequestDraft draft,
  }) async {
    final response = await client.rpc(
      'update_blood_request',
      params: {'p_request_id': requestId, ...buildRequestRpcPayload(draft)},
    );
    return getRequest(_extractRequestId(response));
  }

  @override
  Future<BloodRequestModel> cancelRequest({
    required String requestId,
    required String reason,
  }) async {
    final response = await client.rpc(
      'cancel_blood_request',
      params: {'p_request_id': requestId, 'p_reason': reason},
    );
    return getRequest(_extractRequestId(response));
  }

  @override
  Future<List<RequestDonorModel>> listRequestDonors(String requestId) async {
    final response = await client.rpc(
      'request_donors_for_recipient',
      params: {'p_request_id': requestId},
    );
    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(RequestDonorModel.fromJson)
        .toList();
  }

  @override
  Future<List<CompatibleDonorModel>> listCompatibleDonors(
    String requestId,
  ) async {
    final response = await client.rpc(
      'compatible_donors_for_request',
      params: {'p_request_id': requestId},
    );
    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(CompatibleDonorModel.fromJson)
        .toList();
  }

  @override
  Future<List<DirectInvitationModel>> listInvitations(String requestId) async {
    final response = await client.rpc(
      'request_invitations_for_recipient',
      params: {'p_request_id': requestId},
    );
    return (response as List)
        .cast<Map<String, dynamic>>()
        .map(DirectInvitationModel.fromJson)
        .toList();
  }

  @override
  Future<void> inviteDonor({
    required String requestId,
    required String donorId,
  }) async {
    await client.rpc(
      'send_direct_invitation',
      params: {'p_request_id': requestId, 'p_donor_id': donorId},
    );
  }

  @override
  Future<IssuedRequestQrModel> issueRequestQr(String requestId) async {
    final response = await client.rpc(
      'issue_request_qr',
      params: {'p_request_id': requestId},
    );
    final row = response is List
        ? response.first as Map<String, dynamic>
        : response as Map<String, dynamic>;
    return IssuedRequestQrModel.fromJson(row);
  }
}

String _extractRequestId(dynamic response) {
  if (response is Map<String, dynamic>) {
    return response['id'] as String;
  }
  if (response is List && response.isNotEmpty) {
    return (response.first as Map<String, dynamic>)['id'] as String;
  }
  throw const FormatException('Request RPC returned no row');
}
