// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_feed_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DonorHospitalModel _$DonorHospitalModelFromJson(Map<String, dynamic> json) =>
    _DonorHospitalModel(
      id: json['id'] as String,
      wilayaId: (json['wilaya_id'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      nameFr: json['name_fr'] as String?,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$DonorHospitalModelToJson(_DonorHospitalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wilaya_id': instance.wilayaId,
      'name_ar': instance.nameAr,
      'name_fr': instance.nameFr,
      'address': instance.address,
      'is_active': instance.isActive,
    };

_DonorAvailabilityModel _$DonorAvailabilityModelFromJson(
  Map<String, dynamic> json,
) => _DonorAvailabilityModel(
  userId: json['id'] as String,
  isAccountActive: json['is_active'] as bool,
  isAvailableForDonation: json['is_available_for_donation'] as bool,
  isDonor: json['is_donor'] as bool,
  bloodType: json['blood_type'] as String,
  wilayaId: (json['wilaya_id'] as num).toInt(),
  cooldownUntil: json['cooldown_until'] == null
      ? null
      : DateTime.parse(json['cooldown_until'] as String),
  lastDonationDate: json['last_donation_date'] == null
      ? null
      : DateTime.parse(json['last_donation_date'] as String),
  totalDonationsCount: (json['total_donations_count'] as num).toInt(),
);

Map<String, dynamic> _$DonorAvailabilityModelToJson(
  _DonorAvailabilityModel instance,
) => <String, dynamic>{
  'id': instance.userId,
  'is_active': instance.isAccountActive,
  'is_available_for_donation': instance.isAvailableForDonation,
  'is_donor': instance.isDonor,
  'blood_type': instance.bloodType,
  'wilaya_id': instance.wilayaId,
  'cooldown_until': instance.cooldownUntil?.toIso8601String(),
  'last_donation_date': instance.lastDonationDate?.toIso8601String(),
  'total_donations_count': instance.totalDonationsCount,
};

_DonorBloodRequestModel _$DonorBloodRequestModelFromJson(
  Map<String, dynamic> json,
) => _DonorBloodRequestModel(
  id: json['id'] as String,
  requestedBy: json['requested_by'] as String,
  hospital: DonorHospitalModel.fromJson(
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

Map<String, dynamic> _$DonorBloodRequestModelToJson(
  _DonorBloodRequestModel instance,
) => <String, dynamic>{
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

_DonorCampaignModel _$DonorCampaignModelFromJson(Map<String, dynamic> json) =>
    _DonorCampaignModel(
      id: json['id'] as String,
      createdBy: json['created_by'] as String?,
      organizerName: json['organizer_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      venueName: json['venue_name'] as String,
      city: json['city'] as String,
      wilayaId: (json['wilaya_id'] as num).toInt(),
      hospitalId: json['hospital_id'] as String?,
      bloodTypesNeeded: (json['blood_types_needed'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DonorCampaignModelToJson(_DonorCampaignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_by': instance.createdBy,
      'organizer_name': instance.organizerName,
      'title': instance.title,
      'description': instance.description,
      'venue_name': instance.venueName,
      'city': instance.city,
      'wilaya_id': instance.wilayaId,
      'hospital_id': instance.hospitalId,
      'blood_types_needed': instance.bloodTypesNeeded,
      'status': instance.status,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_DonorAppointmentRequestRefModel _$DonorAppointmentRequestRefModelFromJson(
  Map<String, dynamic> json,
) => _DonorAppointmentRequestRefModel(
  id: json['id'] as String,
  hospital: DonorHospitalModel.fromJson(
    json['hospital'] as Map<String, dynamic>,
  ),
  bloodType: json['blood_type'] as String,
  urgency: json['urgency'] as String,
  neededBy: json['needed_by'] == null
      ? null
      : DateTime.parse(json['needed_by'] as String),
);

Map<String, dynamic> _$DonorAppointmentRequestRefModelToJson(
  _DonorAppointmentRequestRefModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'hospital': instance.hospital,
  'blood_type': instance.bloodType,
  'urgency': instance.urgency,
  'needed_by': instance.neededBy?.toIso8601String(),
};

_DonorAppointmentCampaignRefModel _$DonorAppointmentCampaignRefModelFromJson(
  Map<String, dynamic> json,
) => _DonorAppointmentCampaignRefModel(
  id: json['id'] as String,
  title: json['title'] as String,
  organizerName: json['organizer_name'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
);

Map<String, dynamic> _$DonorAppointmentCampaignRefModelToJson(
  _DonorAppointmentCampaignRefModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'organizer_name': instance.organizerName,
  'starts_at': instance.startsAt.toIso8601String(),
  'ends_at': instance.endsAt.toIso8601String(),
};

_DonorAppointmentModel _$DonorAppointmentModelFromJson(
  Map<String, dynamic> json,
) => _DonorAppointmentModel(
  id: json['id'] as String,
  donorId: json['donor_id'] as String,
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  status: json['status'] as String,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
  cancelReason: json['cancel_reason'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  bloodRequest: json['blood_request'] == null
      ? null
      : DonorAppointmentRequestRefModel.fromJson(
          json['blood_request'] as Map<String, dynamic>,
        ),
  campaign: json['campaign'] == null
      ? null
      : DonorAppointmentCampaignRefModel.fromJson(
          json['campaign'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$DonorAppointmentModelToJson(
  _DonorAppointmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'donor_id': instance.donorId,
  'scheduled_at': instance.scheduledAt.toIso8601String(),
  'status': instance.status,
  'completed_at': instance.completedAt?.toIso8601String(),
  'cancelled_at': instance.cancelledAt?.toIso8601String(),
  'cancel_reason': instance.cancelReason,
  'created_at': instance.createdAt.toIso8601String(),
  'blood_request': instance.bloodRequest,
  'campaign': instance.campaign,
};

_DonationRecordModel _$DonationRecordModelFromJson(Map<String, dynamic> json) =>
    _DonationRecordModel(
      id: json['id'] as String,
      donorId: json['donor_id'] as String,
      source: json['source'] as String,
      requestId: json['request_id'] as String?,
      campaignId: json['campaign_id'] as String?,
      appointmentId: json['appointment_id'] as String?,
      hospitalId: json['hospital_id'] as String?,
      donatedAt: DateTime.parse(json['donated_at'] as String),
      units: (json['units'] as num).toInt(),
    );

Map<String, dynamic> _$DonationRecordModelToJson(
  _DonationRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'donor_id': instance.donorId,
  'source': instance.source,
  'request_id': instance.requestId,
  'campaign_id': instance.campaignId,
  'appointment_id': instance.appointmentId,
  'hospital_id': instance.hospitalId,
  'donated_at': instance.donatedAt.toIso8601String(),
  'units': instance.units,
};
