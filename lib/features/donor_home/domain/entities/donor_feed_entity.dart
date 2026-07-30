import 'package:freezed_annotation/freezed_annotation.dart';

part 'donor_feed_entity.freezed.dart';

enum DonorRequestPriority {
  normal,
  semiUrgent,
  urgent;

  String get databaseValue => switch (this) {
    DonorRequestPriority.normal => 'normal',
    DonorRequestPriority.semiUrgent => 'semi_urgent',
    DonorRequestPriority.urgent => 'urgent',
  };

  static DonorRequestPriority fromDatabase(String value) => switch (value) {
    'normal' => DonorRequestPriority.normal,
    'semi_urgent' => DonorRequestPriority.semiUrgent,
    'urgent' => DonorRequestPriority.urgent,
    _ => throw ArgumentError.value(
      value,
      'value',
      'Unknown donor request priority',
    ),
  };
}

enum DonorBloodRequestStatus {
  open,
  fulfilled,
  cancelled,
  expired;

  static DonorBloodRequestStatus fromDatabase(String value) =>
      DonorBloodRequestStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => throw ArgumentError.value(
          value,
          'value',
          'Unknown donor request status',
        ),
      );
}

enum DonorCampaignStatus {
  upcoming,
  active,
  completed,
  cancelled;

  static DonorCampaignStatus fromDatabase(String value) =>
      DonorCampaignStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => throw ArgumentError.value(
          value,
          'value',
          'Unknown campaign status',
        ),
      );
}

enum DonationAppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  static DonationAppointmentStatus fromDatabase(String value) =>
      switch (value) {
        'pending' => DonationAppointmentStatus.pending,
        'confirmed' => DonationAppointmentStatus.confirmed,
        'completed' => DonationAppointmentStatus.completed,
        'cancelled' => DonationAppointmentStatus.cancelled,
        _ => throw ArgumentError.value(
          value,
          'value',
          'Unknown appointment status',
        ),
      };
}

enum DonationSource {
  request,
  campaign;

  static DonationSource fromDatabase(String value) =>
      DonationSource.values.firstWhere(
        (source) => source.name == value,
        orElse: () => throw ArgumentError.value(
          value,
          'value',
          'Unknown donation source',
        ),
      );
}

@freezed
abstract class DonorHospitalEntity with _$DonorHospitalEntity {
  const factory DonorHospitalEntity({
    required String id,
    required int wilayaId,
    required String nameAr,
    String? nameFr,
    String? address,
    required bool isActive,
  }) = _DonorHospitalEntity;
}

@freezed
abstract class DonorAvailabilityEntity with _$DonorAvailabilityEntity {
  const DonorAvailabilityEntity._();

  const factory DonorAvailabilityEntity({
    required String userId,
    required bool isAccountActive,
    required bool isAvailableForDonation,
    required bool isDonor,
    required String bloodType,
    required int wilayaId,
    DateTime? cooldownUntil,
    DateTime? lastDonationDate,
    required int totalDonationsCount,
  }) = _DonorAvailabilityEntity;

  bool isEligibleAt(DateTime instant) {
    if (!isAccountActive || !isAvailableForDonation || !isDonor) {
      return false;
    }
    return cooldownUntil == null || !cooldownUntil!.isAfter(instant);
  }

  DateTime? nextEligibilityAt() {
    if (cooldownUntil == null) return null;
    return cooldownUntil!.add(const Duration(days: 1));
  }
}

@freezed
abstract class DonorBloodRequestEntity with _$DonorBloodRequestEntity {
  const DonorBloodRequestEntity._();

  const factory DonorBloodRequestEntity({
    required String id,
    required String requestedBy,
    required DonorHospitalEntity hospital,
    required String bloodType,
    required DonorRequestPriority priority,
    required int unitsNeeded,
    required int unitsFulfilled,
    required DonorBloodRequestStatus status,
    DateTime? neededBy,
    DateTime? expiresAt,
    String? notes,
    required DateTime createdAt,
  }) = _DonorBloodRequestEntity;

  int get remainingUnits {
    final remaining = unitsNeeded - unitsFulfilled;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isAcceptingDonors => status == DonorBloodRequestStatus.open;
}

@freezed
abstract class DonorCampaignEntity with _$DonorCampaignEntity {
  const DonorCampaignEntity._();

  const factory DonorCampaignEntity({
    required String id,
    String? createdBy,
    required String organizerName,
    required String title,
    String? description,
    required String venueName,
    required String city,
    required int wilayaId,
    String? hospitalId,
    List<String>? bloodTypesNeeded,
    required DonorCampaignStatus status,
    required DateTime startsAt,
    required DateTime endsAt,
    DateTime? publishedAt,
    required DateTime createdAt,
  }) = _DonorCampaignEntity;

  bool acceptsBloodType(String bloodType) =>
      bloodTypesNeeded == null || bloodTypesNeeded!.contains(bloodType);

  bool isVisibleAt(DateTime instant) =>
      publishedAt != null &&
      endsAt.isAfter(instant) &&
      (status == DonorCampaignStatus.upcoming ||
          status == DonorCampaignStatus.active);
}

@freezed
abstract class DonorAppointmentRequestRef with _$DonorAppointmentRequestRef {
  const factory DonorAppointmentRequestRef({
    required String id,
    required DonorHospitalEntity hospital,
    required String bloodType,
    required DonorRequestPriority priority,
    DateTime? neededBy,
  }) = _DonorAppointmentRequestRef;
}

@freezed
abstract class DonorAppointmentCampaignRef with _$DonorAppointmentCampaignRef {
  const factory DonorAppointmentCampaignRef({
    required String id,
    required String title,
    required String organizerName,
    required DateTime startsAt,
    required DateTime endsAt,
  }) = _DonorAppointmentCampaignRef;
}

@freezed
abstract class DonorAppointmentEntity with _$DonorAppointmentEntity {
  const factory DonorAppointmentEntity({
    required String id,
    required String donorId,
    required DateTime scheduledAt,
    required DonationAppointmentStatus status,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancelReason,
    required DateTime createdAt,
    DonorAppointmentRequestRef? bloodRequest,
    DonorAppointmentCampaignRef? campaign,
  }) = _DonorAppointmentEntity;
}

@freezed
abstract class DonationRecordEntity with _$DonationRecordEntity {
  const factory DonationRecordEntity({
    required String id,
    required String donorId,
    required DonationSource source,
    String? requestId,
    String? campaignId,
    String? appointmentId,
    String? hospitalId,
    required DateTime donatedAt,
    required int units,
  }) = _DonationRecordEntity;
}

@freezed
abstract class DonorFeedEntity with _$DonorFeedEntity {
  const DonorFeedEntity._();

  const factory DonorFeedEntity({
    required DonorAvailabilityEntity availability,
    required List<DonorBloodRequestEntity> compatibleRequests,
    required List<DonorCampaignEntity> availableCampaigns,
    required List<DonorAppointmentEntity> appointments,
  }) = _DonorFeedEntity;

  DonorAppointmentEntity? get activeAppointment {
    for (final appointment in appointments) {
      if (appointment.status == DonationAppointmentStatus.pending ||
          appointment.status == DonationAppointmentStatus.confirmed) {
        return appointment;
      }
    }
    return null;
  }

  bool get hasBlockingAppointment => activeAppointment != null;
}
