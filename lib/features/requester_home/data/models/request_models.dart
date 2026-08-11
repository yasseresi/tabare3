import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/blood_request_entity.dart';

part 'request_models.freezed.dart';
part 'request_models.g.dart';

@freezed
abstract class HospitalModel with _$HospitalModel {
  const HospitalModel._();

  const factory HospitalModel({
    required String id,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'name_fr') String? nameFr,
    String? address,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _HospitalModel;

  factory HospitalModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalModelFromJson(json);

  HospitalEntity toEntity() => HospitalEntity(
    id: id,
    wilayaId: wilayaId,
    nameAr: nameAr,
    nameFr: nameFr,
    address: address,
    isActive: isActive,
  );
}

@freezed
abstract class PatientModel with _$PatientModel {
  const PatientModel._();

  const factory PatientModel({
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'national_id') required String nationalId,
    @JsonKey(name: 'blood_type') required String bloodType,
    required double weight,
    @JsonKey(name: 'chronic_diseases') String? chronicDiseases,
    required String gender,
    @JsonKey(name: 'date_of_birth') required String dateOfBirth,
  }) = _PatientModel;

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  PatientEntity toEntity() => PatientEntity(
    fullName: fullName,
    nationalId: nationalId,
    bloodType: bloodType,
    weight: weight,
    chronicDiseases: chronicDiseases,
    gender: gender,
    dateOfBirth: dateOfBirth,
  );
}

@freezed
abstract class BloodRequestModel with _$BloodRequestModel {
  const BloodRequestModel._();

  const factory BloodRequestModel({
    required String id,
    @JsonKey(name: 'requested_by') required String requestedBy,
    // `blood_requests.hospital_id` is nullable, so PostgREST returns a null
    // hospital embed for requests that have no hospital attached.
    HospitalModel? hospital,
    @JsonKey(name: 'beneficiary_type') @Default('self') String beneficiaryType,
    PatientModel? patient,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String urgency,
    @JsonKey(name: 'units_needed') required int unitsNeeded,
    @JsonKey(name: 'units_fulfilled') required int unitsFulfilled,
    required String status,
    @JsonKey(name: 'needed_by') DateTime? neededBy,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BloodRequestModel;

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestModelFromJson(json);

  BloodRequestEntity toEntity() => BloodRequestEntity(
    id: id,
    requestedBy: requestedBy,
    hospital: hospital?.toEntity(),
    beneficiaryType: BeneficiaryType.fromDatabase(beneficiaryType),
    patient: patient?.toEntity(),
    bloodType: bloodType,
    priority: RequestPriority.fromDatabase(urgency),
    unitsNeeded: unitsNeeded,
    unitsFulfilled: unitsFulfilled,
    status: BloodRequestStatus.fromDatabase(status),
    neededBy: neededBy,
    expiresAt: expiresAt,
    notes: notes,
    createdAt: createdAt,
  );
}

@freezed
abstract class RequestDonorModel with _$RequestDonorModel {
  const RequestDonorModel._();

  const factory RequestDonorModel({
    @JsonKey(name: 'donor_id') required String donorId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'blood_type') required String bloodType,
    @JsonKey(name: 'appointment_id') required String appointmentId,
    required String status,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _RequestDonorModel;

  factory RequestDonorModel.fromJson(Map<String, dynamic> json) =>
      _$RequestDonorModelFromJson(json);

  RequestDonorEntity toEntity() => RequestDonorEntity(
    donorId: donorId,
    fullName: fullName,
    bloodType: bloodType,
    appointmentId: appointmentId,
    status: DonationAppointmentStatus.fromDatabase(status),
    scheduledAt: scheduledAt,
    completedAt: completedAt,
  );
}

@freezed
abstract class CompatibleDonorModel with _$CompatibleDonorModel {
  const CompatibleDonorModel._();

  const factory CompatibleDonorModel({
    @JsonKey(name: 'donor_id') required String donorId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'blood_type') required String bloodType,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'cooldown_until') DateTime? cooldownUntil,
  }) = _CompatibleDonorModel;

  factory CompatibleDonorModel.fromJson(Map<String, dynamic> json) =>
      _$CompatibleDonorModelFromJson(json);

  CompatibleDonorEntity toEntity() => CompatibleDonorEntity(
    donorId: donorId,
    fullName: fullName,
    bloodType: bloodType,
    wilayaId: wilayaId,
    cooldownUntil: cooldownUntil,
  );
}

@freezed
abstract class IssuedRequestQrModel with _$IssuedRequestQrModel {
  const IssuedRequestQrModel._();

  const factory IssuedRequestQrModel({
    required String token,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _IssuedRequestQrModel;

  factory IssuedRequestQrModel.fromJson(Map<String, dynamic> json) =>
      _$IssuedRequestQrModelFromJson(json);

  IssuedRequestQrEntity toEntity() =>
      IssuedRequestQrEntity(token: token, expiresAt: expiresAt);
}

@freezed
abstract class DirectInvitationModel with _$DirectInvitationModel {
  const DirectInvitationModel._();

  const factory DirectInvitationModel({
    @JsonKey(name: 'invitation_id') required String invitationId,
    @JsonKey(name: 'donor_id') required String donorId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String status,
    @JsonKey(name: 'appointment_id') String? appointmentId,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DirectInvitationModel;

  factory DirectInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$DirectInvitationModelFromJson(json);

  DirectInvitationEntity toEntity() => DirectInvitationEntity(
    invitationId: invitationId,
    donorId: donorId,
    fullName: fullName,
    bloodType: bloodType,
    status: DirectInvitationStatus.fromDatabase(status),
    appointmentId: appointmentId,
    expiresAt: expiresAt,
    respondedAt: respondedAt,
    createdAt: createdAt,
  );
}

Map<String, dynamic> buildRequestRpcPayload(RequestDraft draft) => {
  'p_hospital_id': draft.hospitalId,
  'p_beneficiary_type': draft.beneficiaryType.databaseValue,
  'p_patient_full_name': draft.patient?.fullName,
  'p_patient_national_id': draft.patient?.nationalId,
  'p_patient_blood_type': draft.patient?.bloodType,
  'p_patient_weight': draft.patient?.weight,
  'p_patient_chronic_diseases': draft.patient?.chronicDiseases,
  'p_patient_gender': draft.patient?.gender,
  'p_patient_date_of_birth': draft.patient?.dateOfBirth,
  'p_blood_type': draft.bloodType,
  'p_urgency': draft.priority.databaseValue,
  'p_units_needed': draft.unitsNeeded,
  'p_needed_by': draft.neededBy?.toUtc().toIso8601String(),
  'p_notes': draft.notes,
};
