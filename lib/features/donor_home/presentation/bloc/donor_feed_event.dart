import 'package:equatable/equatable.dart';

abstract class DonorFeedEvent extends Equatable {
  const DonorFeedEvent();

  @override
  List<Object?> get props => [];
}

class DonorFeedRequested extends DonorFeedEvent {
  const DonorFeedRequested();
}

class DonorAvailabilityChanged extends DonorFeedEvent {
  final bool isAvailable;

  const DonorAvailabilityChanged(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

class DonorRequestAccepted extends DonorFeedEvent {
  final String requestId;
  final DateTime scheduledAt;

  const DonorRequestAccepted({
    required this.requestId,
    required this.scheduledAt,
  });

  @override
  List<Object?> get props => [requestId, scheduledAt];
}

class DonorAppointmentCancelled extends DonorFeedEvent {
  final String appointmentId;
  final String reason;

  const DonorAppointmentCancelled({
    required this.appointmentId,
    required this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, reason];
}

class DonorRequestQrRedeemed extends DonorFeedEvent {
  final String token;

  const DonorRequestQrRedeemed(this.token);

  @override
  List<Object?> get props => [token];
}

class DonorCampaignQrRedeemed extends DonorFeedEvent {
  final String token;

  const DonorCampaignQrRedeemed(this.token);

  @override
  List<Object?> get props => [token];
}
