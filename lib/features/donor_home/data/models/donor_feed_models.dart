import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/donor_feed_entity.dart';

part 'donor_feed_models.freezed.dart';
part 'donor_feed_models.g.dart';

@freezed
abstract class DonorHospitalModel with _$DonorHospitalModel {
  const DonorHospitalModel._();

  const factory DonorHospitalModel({
    required String id,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'name_fr') String? nameFr,
    String? address,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _DonorHospitalModel;

  factory DonorHospitalModel.fromJson(Map<String, dynamic> json) =>
      _$DonorHospitalModelFromJson(json);

  DonorHospitalEntity toEntity() => DonorHospitalEntity(
    id: id,
    wilayaId: wilayaId,
    nameAr: nameAr,
    nameFr: nameFr,
    address: address,
    isActive: isActive,
  );
}

@freezed
abstract class DonorAvailabilityModel with _$DonorAvailabilityModel {
  const DonorAvailabilityModel._();

  const factory DonorAvailabilityModel({
    @JsonKey(name: 'id') required String userId,
    @JsonKey(name: 'is_active') required bool isAccountActive,
    @JsonKey(name: 'is_available_for_donation')
    required bool isAvailableForDonation,
    @JsonKey(name: 'is_donor') required bool isDonor,
    @JsonKey(name: 'blood_type') required String bloodType,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'cooldown_until') DateTime? cooldownUntil,
    @JsonKey(name: 'last_donation_date') DateTime? lastDonationDate,
    @JsonKey(name: 'total_donations_count') required int totalDonationsCount,
  }) = _DonorAvailabilityModel;

  factory DonorAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$DonorAvailabilityModelFromJson(json);

  DonorAvailabilityEntity toEntity() => DonorAvailabilityEntity(
    userId: userId,
    isAccountActive: isAccountActive,
    isAvailableForDonation: isAvailableForDonation,
    isDonor: isDonor,
    bloodType: bloodType,
    wilayaId: wilayaId,
    cooldownUntil: cooldownUntil,
    lastDonationDate: lastDonationDate,
    totalDonationsCount: totalDonationsCount,
  );
}

@freezed
abstract class DonorBloodRequestModel with _$DonorBloodRequestModel {
  const DonorBloodRequestModel._();

  const factory DonorBloodRequestModel({
    required String id,
    @JsonKey(name: 'requested_by') required String requestedBy,
    @JsonKey(name: 'patient_name') String? patientName,
    required DonorHospitalModel hospital,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String urgency,
    @JsonKey(name: 'units_needed') required int unitsNeeded,
    @JsonKey(name: 'units_fulfilled') required int unitsFulfilled,
    required String status,
    @JsonKey(name: 'needed_by') DateTime? neededBy,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DonorBloodRequestModel;

  factory DonorBloodRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DonorBloodRequestModelFromJson(json);

  DonorBloodRequestEntity toEntity() => DonorBloodRequestEntity(
    id: id,
    requestedBy: requestedBy,
    patientName: patientName,
    hospital: hospital.toEntity(),
    bloodType: bloodType,
    priority: DonorRequestPriority.fromDatabase(urgency),
    unitsNeeded: unitsNeeded,
    unitsFulfilled: unitsFulfilled,
    status: DonorBloodRequestStatus.fromDatabase(status),
    neededBy: neededBy,
    expiresAt: expiresAt,
    notes: notes,
    createdAt: createdAt,
  );
}

@freezed
abstract class DonorCampaignModel with _$DonorCampaignModel {
  const DonorCampaignModel._();

  const factory DonorCampaignModel({
    required String id,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'organizer_name') required String organizerName,
    required String title,
    String? description,
    @JsonKey(name: 'venue_name') required String venueName,
    required String city,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'hospital_id') String? hospitalId,
    @JsonKey(name: 'blood_types_needed') List<String>? bloodTypesNeeded,
    required String status,
    @JsonKey(name: 'starts_at') required DateTime startsAt,
    @JsonKey(name: 'ends_at') required DateTime endsAt,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DonorCampaignModel;

  factory DonorCampaignModel.fromJson(Map<String, dynamic> json) =>
      _$DonorCampaignModelFromJson(json);

  DonorCampaignEntity toEntity() => DonorCampaignEntity(
    id: id,
    createdBy: createdBy,
    organizerName: organizerName,
    title: title,
    description: description,
    venueName: venueName,
    city: city,
    wilayaId: wilayaId,
    hospitalId: hospitalId,
    bloodTypesNeeded: bloodTypesNeeded,
    status: DonorCampaignStatus.fromDatabase(status),
    startsAt: startsAt,
    endsAt: endsAt,
    publishedAt: publishedAt,
    createdAt: createdAt,
  );
}

@freezed
abstract class DonorAppointmentRequestRefModel
    with _$DonorAppointmentRequestRefModel {
  const DonorAppointmentRequestRefModel._();

  const factory DonorAppointmentRequestRefModel({
    required String id,
    required DonorHospitalModel hospital,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String urgency,
    @JsonKey(name: 'needed_by') DateTime? neededBy,
  }) = _DonorAppointmentRequestRefModel;

  factory DonorAppointmentRequestRefModel.fromJson(Map<String, dynamic> json) =>
      _$DonorAppointmentRequestRefModelFromJson(json);

  DonorAppointmentRequestRef toEntity() => DonorAppointmentRequestRef(
    id: id,
    hospital: hospital.toEntity(),
    bloodType: bloodType,
    priority: DonorRequestPriority.fromDatabase(urgency),
    neededBy: neededBy,
  );
}

@freezed
abstract class DonorAppointmentCampaignRefModel
    with _$DonorAppointmentCampaignRefModel {
  const DonorAppointmentCampaignRefModel._();

  const factory DonorAppointmentCampaignRefModel({
    required String id,
    required String title,
    @JsonKey(name: 'organizer_name') required String organizerName,
    @JsonKey(name: 'starts_at') required DateTime startsAt,
    @JsonKey(name: 'ends_at') required DateTime endsAt,
  }) = _DonorAppointmentCampaignRefModel;

  factory DonorAppointmentCampaignRefModel.fromJson(
    Map<String, dynamic> json,
  ) => _$DonorAppointmentCampaignRefModelFromJson(json);

  DonorAppointmentCampaignRef toEntity() => DonorAppointmentCampaignRef(
    id: id,
    title: title,
    organizerName: organizerName,
    startsAt: startsAt,
    endsAt: endsAt,
  );
}

@freezed
abstract class DonorAppointmentModel with _$DonorAppointmentModel {
  const DonorAppointmentModel._();

  const factory DonorAppointmentModel({
    required String id,
    @JsonKey(name: 'donor_id') required String donorId,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    required String status,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'cancel_reason') String? cancelReason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'blood_request')
    DonorAppointmentRequestRefModel? bloodRequest,
    DonorAppointmentCampaignRefModel? campaign,
  }) = _DonorAppointmentModel;

  factory DonorAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$DonorAppointmentModelFromJson(json);

  DonorAppointmentEntity toEntity() => DonorAppointmentEntity(
    id: id,
    donorId: donorId,
    scheduledAt: scheduledAt,
    status: DonationAppointmentStatus.fromDatabase(status),
    completedAt: completedAt,
    cancelledAt: cancelledAt,
    cancelReason: cancelReason,
    createdAt: createdAt,
    bloodRequest: bloodRequest?.toEntity(),
    campaign: campaign?.toEntity(),
  );
}

@freezed
abstract class DonationRecordRecipientModel
    with _$DonationRecordRecipientModel {
  const factory DonationRecordRecipientModel({
    @JsonKey(name: 'full_name') required String fullName,
  }) = _DonationRecordRecipientModel;

  factory DonationRecordRecipientModel.fromJson(Map<String, dynamic> json) =>
      _$DonationRecordRecipientModelFromJson(json);
}

@freezed
abstract class DonationRecordRequestRefModel
    with _$DonationRecordRequestRefModel {
  const DonationRecordRequestRefModel._();

  const factory DonationRecordRequestRefModel({
    required String id,
    required DonationRecordRecipientModel recipient,
    required DonorHospitalModel hospital,
  }) = _DonationRecordRequestRefModel;

  factory DonationRecordRequestRefModel.fromJson(Map<String, dynamic> json) =>
      _$DonationRecordRequestRefModelFromJson(json);

  DonationRecordRequestRef toEntity() => DonationRecordRequestRef(
    id: id,
    recipientName: recipient.fullName,
    hospital: hospital.toEntity(),
  );
}

@freezed
abstract class DonationRecordCampaignRefModel
    with _$DonationRecordCampaignRefModel {
  const DonationRecordCampaignRefModel._();

  const factory DonationRecordCampaignRefModel({
    required String id,
    required String title,
    @JsonKey(name: 'venue_name') required String venueName,
    required String city,
  }) = _DonationRecordCampaignRefModel;

  factory DonationRecordCampaignRefModel.fromJson(Map<String, dynamic> json) =>
      _$DonationRecordCampaignRefModelFromJson(json);

  DonationRecordCampaignRef toEntity() => DonationRecordCampaignRef(
    id: id,
    title: title,
    venueName: venueName,
    city: city,
  );
}

@freezed
abstract class DonationRecordModel with _$DonationRecordModel {
  const DonationRecordModel._();

  const factory DonationRecordModel({
    required String id,
    @JsonKey(name: 'donor_id') required String donorId,
    required String source,
    @JsonKey(name: 'request_id') String? requestId,
    @JsonKey(name: 'campaign_id') String? campaignId,
    @JsonKey(name: 'appointment_id') String? appointmentId,
    @JsonKey(name: 'hospital_id') String? hospitalId,
    @JsonKey(name: 'donated_at') required DateTime donatedAt,
    required int units,
    @JsonKey(name: 'blood_request') DonationRecordRequestRefModel? bloodRequest,
    DonationRecordCampaignRefModel? campaign,
  }) = _DonationRecordModel;

  factory DonationRecordModel.fromJson(Map<String, dynamic> json) =>
      _$DonationRecordModelFromJson(json);

  DonationRecordEntity toEntity() => DonationRecordEntity(
    id: id,
    donorId: donorId,
    source: DonationSource.fromDatabase(source),
    requestId: requestId,
    campaignId: campaignId,
    appointmentId: appointmentId,
    hospitalId: hospitalId,
    donatedAt: donatedAt,
    units: units,
    bloodRequest: bloodRequest?.toEntity(),
    campaign: campaign?.toEntity(),
  );
}

Map<String, dynamic> buildAcceptBloodRequestRpcPayload({
  required String requestId,
  required DateTime scheduledAt,
}) => {
  'p_request_id': requestId,
  'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
};

Map<String, dynamic> buildCancelAppointmentRpcPayload({
  required String appointmentId,
  required String reason,
}) => {'p_appointment_id': appointmentId, 'p_reason': reason};

Map<String, dynamic> buildRedeemDonationQrRpcPayload(String token) => {
  'p_token': token,
};
