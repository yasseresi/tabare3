import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_request_entity.freezed.dart';

const supportedBloodTypes = <String>[
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

enum RequestPriority {
  normal,
  semiUrgent,
  urgent;

  String get databaseValue => switch (this) {
    RequestPriority.normal => 'normal',
    RequestPriority.semiUrgent => 'semi_urgent',
    RequestPriority.urgent => 'urgent',
  };

  static RequestPriority fromDatabase(String value) => switch (value) {
    'normal' => RequestPriority.normal,
    'semi_urgent' => RequestPriority.semiUrgent,
    'urgent' => RequestPriority.urgent,
    _ => throw ArgumentError.value(value, 'value', 'Unknown request priority'),
  };
}

enum BloodRequestStatus {
  open,
  fulfilled,
  cancelled,
  expired;

  static BloodRequestStatus fromDatabase(String value) =>
      BloodRequestStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () =>
            throw ArgumentError.value(value, 'value', 'Unknown request status'),
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

enum DirectInvitationStatus {
  sent,
  accepted,
  rejected,
  expired,
  cancelled;

  static DirectInvitationStatus fromDatabase(String value) =>
      DirectInvitationStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => throw ArgumentError.value(
          value,
          'value',
          'Unknown invitation status',
        ),
      );
}

@freezed
abstract class HospitalEntity with _$HospitalEntity {
  const factory HospitalEntity({
    required String id,
    required int wilayaId,
    required String nameAr,
    String? nameFr,
    String? address,
    required bool isActive,
  }) = _HospitalEntity;
}

@freezed
abstract class BloodRequestEntity with _$BloodRequestEntity {
  const BloodRequestEntity._();

  const factory BloodRequestEntity({
    required String id,
    required String requestedBy,
    required HospitalEntity hospital,
    required String bloodType,
    required RequestPriority priority,
    required int unitsNeeded,
    required int unitsFulfilled,
    required BloodRequestStatus status,
    DateTime? neededBy,
    DateTime? expiresAt,
    String? notes,
    required DateTime createdAt,
  }) = _BloodRequestEntity;

  int get remainingUnits {
    final remaining = unitsNeeded - unitsFulfilled;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isActive => status == BloodRequestStatus.open;
}

@freezed
abstract class RequestDraft with _$RequestDraft {
  const factory RequestDraft({
    required String hospitalId,
    required String bloodType,
    required RequestPriority priority,
    required int unitsNeeded,
    DateTime? neededBy,
    String? notes,
  }) = _RequestDraft;
}

@freezed
abstract class RequestDonorEntity with _$RequestDonorEntity {
  const factory RequestDonorEntity({
    required String donorId,
    required String fullName,
    required String bloodType,
    required String appointmentId,
    required DonationAppointmentStatus status,
    required DateTime scheduledAt,
    DateTime? completedAt,
  }) = _RequestDonorEntity;
}

@freezed
abstract class CompatibleDonorEntity with _$CompatibleDonorEntity {
  const factory CompatibleDonorEntity({
    required String donorId,
    required String fullName,
    required String bloodType,
    required int wilayaId,
    DateTime? cooldownUntil,
  }) = _CompatibleDonorEntity;
}

@freezed
abstract class IssuedRequestQrEntity with _$IssuedRequestQrEntity {
  const IssuedRequestQrEntity._();

  const factory IssuedRequestQrEntity({
    required String token,
    required DateTime expiresAt,
  }) = _IssuedRequestQrEntity;

  bool isExpiredAt(DateTime instant) => !instant.isBefore(expiresAt);
}

@freezed
abstract class DirectInvitationEntity with _$DirectInvitationEntity {
  const factory DirectInvitationEntity({
    required String invitationId,
    required String donorId,
    required String fullName,
    required String bloodType,
    required DirectInvitationStatus status,
    String? appointmentId,
    required DateTime expiresAt,
    DateTime? respondedAt,
    required DateTime createdAt,
  }) = _DirectInvitationEntity;
}
