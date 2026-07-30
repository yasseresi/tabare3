import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/donor_feed_entity.dart';

enum DonorFeedMutation {
  requestAccepted,
  appointmentCancelled,
  donationRecorded,
  availabilityChanged,
}

abstract class DonorFeedState extends Equatable {
  const DonorFeedState();

  @override
  List<Object?> get props => [];
}

class DonorFeedInitial extends DonorFeedState {
  const DonorFeedInitial();
}

class DonorFeedLoading extends DonorFeedState {
  const DonorFeedLoading();
}

class DonorFeedLoaded extends DonorFeedState {
  final DonorFeedEntity feed;
  final List<DonationRecordEntity> records;
  final bool isMutating;
  final DonorFeedMutation? lastMutation;

  const DonorFeedLoaded({
    required this.feed,
    required this.records,
    this.isMutating = false,
    this.lastMutation,
  });

  DonorFeedLoaded copyWith({
    bool? isMutating,
    DonorFeedMutation? lastMutation,
  }) {
    return DonorFeedLoaded(
      feed: feed,
      records: records,
      isMutating: isMutating ?? this.isMutating,
      lastMutation: lastMutation,
    );
  }

  @override
  List<Object?> get props => [feed, records, isMutating, lastMutation];
}

class DonorFeedError extends DonorFeedState {
  final Failure failure;

  const DonorFeedError(this.failure);

  @override
  List<Object?> get props => [failure];
}
