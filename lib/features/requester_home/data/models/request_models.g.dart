// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HospitalModel _$HospitalModelFromJson(Map<String, dynamic> json) =>
    _HospitalModel(
      id: json['id'] as String,
      wilayaId: (json['wilaya_id'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      nameFr: json['name_fr'] as String?,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$HospitalModelToJson(_HospitalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wilaya_id': instance.wilayaId,
      'name_ar': instance.nameAr,
      'name_fr': instance.nameFr,
      'address': instance.address,
      'is_active': instance.isActive,
    };

_BloodRequestModel _$BloodRequestModelFromJson(Map<String, dynamic> json) =>
    _BloodRequestModel(
      id: json['id'] as String,
      requestedBy: json['requested_by'] as String,
      hospital: HospitalModel.fromJson(
        json['hospital'] as Map<String, dynamic>,
      ),
      bloodType: json['blood_type'] as String,
      urgency: json['urgency'] as String,
      unitsNeeded: (json['units_needed'] as num).toInt(),
      unitsFulfilled: (json['units_fulfilled'] as num).toInt(),
      status: json['status'] as String,
      neededBy: json['needed_by'] == null
          ? null
          : DateTime.parse(json['needed_by'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BloodRequestModelToJson(_BloodRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requested_by': instance.requestedBy,
      'hospital': instance.hospital,
      'blood_type': instance.bloodType,
      'urgency': instance.urgency,
      'units_needed': instance.unitsNeeded,
      'units_fulfilled': instance.unitsFulfilled,
      'status': instance.status,
      'needed_by': instance.neededBy?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
    };

_RequestDonorModel _$RequestDonorModelFromJson(Map<String, dynamic> json) =>
    _RequestDonorModel(
      donorId: json['donor_id'] as String,
      fullName: json['full_name'] as String,
      bloodType: json['blood_type'] as String,
      appointmentId: json['appointment_id'] as String,
      status: json['status'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$RequestDonorModelToJson(_RequestDonorModel instance) =>
    <String, dynamic>{
      'donor_id': instance.donorId,
      'full_name': instance.fullName,
      'blood_type': instance.bloodType,
      'appointment_id': instance.appointmentId,
      'status': instance.status,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };

_CompatibleDonorModel _$CompatibleDonorModelFromJson(
  Map<String, dynamic> json,
) => _CompatibleDonorModel(
  donorId: json['donor_id'] as String,
  fullName: json['full_name'] as String,
  bloodType: json['blood_type'] as String,
  wilayaId: (json['wilaya_id'] as num).toInt(),
  cooldownUntil: json['cooldown_until'] == null
      ? null
      : DateTime.parse(json['cooldown_until'] as String),
);

Map<String, dynamic> _$CompatibleDonorModelToJson(
  _CompatibleDonorModel instance,
) => <String, dynamic>{
  'donor_id': instance.donorId,
  'full_name': instance.fullName,
  'blood_type': instance.bloodType,
  'wilaya_id': instance.wilayaId,
  'cooldown_until': instance.cooldownUntil?.toIso8601String(),
};

_IssuedRequestQrModel _$IssuedRequestQrModelFromJson(
  Map<String, dynamic> json,
) => _IssuedRequestQrModel(
  token: json['token'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$IssuedRequestQrModelToJson(
  _IssuedRequestQrModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'expires_at': instance.expiresAt.toIso8601String(),
};

_DirectInvitationModel _$DirectInvitationModelFromJson(
  Map<String, dynamic> json,
) => _DirectInvitationModel(
  invitationId: json['invitation_id'] as String,
  donorId: json['donor_id'] as String,
  fullName: json['full_name'] as String,
  bloodType: json['blood_type'] as String,
  status: json['status'] as String,
  appointmentId: json['appointment_id'] as String?,
  expiresAt: DateTime.parse(json['expires_at'] as String),
  respondedAt: json['responded_at'] == null
      ? null
      : DateTime.parse(json['responded_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$DirectInvitationModelToJson(
  _DirectInvitationModel instance,
) => <String, dynamic>{
  'invitation_id': instance.invitationId,
  'donor_id': instance.donorId,
  'full_name': instance.fullName,
  'blood_type': instance.bloodType,
  'status': instance.status,
  'appointment_id': instance.appointmentId,
  'expires_at': instance.expiresAt.toIso8601String(),
  'responded_at': instance.respondedAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
};
