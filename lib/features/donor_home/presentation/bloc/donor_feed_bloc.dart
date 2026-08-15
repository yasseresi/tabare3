import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/donor_feed_entity.dart';
import '../../domain/usecases/donor_feed_usecases.dart';
import 'donor_feed_event.dart';
import 'donor_feed_state.dart';

export 'donor_feed_event.dart';
export 'donor_feed_state.dart';

class DonorFeedBloc extends Bloc<DonorFeedEvent, DonorFeedState> {
  final GetDonorFeed getFeed;
  final GetDonationRecords getRecords;
  final AcceptBloodRequest acceptRequest;
  final CancelDonationAppointment cancelAppointment;
  final RedeemRequestDonation redeemRequestQr;
  final RedeemCampaignDonation redeemCampaignQr;
  final RedeemDonation redeemQr;
  final SetDonorAvailability setAvailability;

  DonorFeedBloc({
    required this.getFeed,
    required this.getRecords,
    required this.acceptRequest,
    required this.cancelAppointment,
    required this.redeemRequestQr,
    required this.redeemCampaignQr,
    required this.redeemQr,
    required this.setAvailability,
  }) : super(const DonorFeedInitial()) {
    on<DonorFeedRequested>(_onRequested);
    on<DonorAvailabilityChanged>(_onAvailabilityChanged);
    on<DonorRequestAccepted>(_onRequestAccepted);
    on<DonorAppointmentCancelled>(_onAppointmentCancelled);
    on<DonorRequestQrRedeemed>(_onRequestQrRedeemed);
    on<DonorCampaignQrRedeemed>(_onCampaignQrRedeemed);
    on<DonorQrRedeemed>(_onQrRedeemed);
  }

  Future<void> _onRequested(
    DonorFeedRequested event,
    Emitter<DonorFeedState> emit,
  ) {
    return _load(emit);
  }

  Future<void> _onAvailabilityChanged(
    DonorAvailabilityChanged event,
    Emitter<DonorFeedState> emit,
  ) async {
    if (!_startMutation(emit)) return;
    final result = await setAvailability(event.isAvailable);
    await result.fold(
      (failure) async => emit(DonorFeedError(failure)),
      (_) => _load(emit, mutation: DonorFeedMutation.availabilityChanged),
    );
  }

  Future<void> _onRequestAccepted(
    DonorRequestAccepted event,
    Emitter<DonorFeedState> emit,
  ) async {
    if (!_startMutation(emit)) return;
    final result = await acceptRequest(
      AcceptBloodRequestParams(
        requestId: event.requestId,
        scheduledAt: event.scheduledAt,
      ),
    );
    await result.fold(
      (failure) async => emit(DonorFeedError(failure)),
      (_) => _load(emit, mutation: DonorFeedMutation.requestAccepted),
    );
  }

  Future<void> _onAppointmentCancelled(
    DonorAppointmentCancelled event,
    Emitter<DonorFeedState> emit,
  ) async {
    if (!_startMutation(emit)) return;
    final result = await cancelAppointment(
      CancelDonationAppointmentParams(
        appointmentId: event.appointmentId,
        reason: event.reason,
      ),
    );
    await result.fold(
      (failure) async => emit(DonorFeedError(failure)),
      (_) => _load(emit, mutation: DonorFeedMutation.appointmentCancelled),
    );
  }

  Future<void> _onRequestQrRedeemed(
    DonorRequestQrRedeemed event,
    Emitter<DonorFeedState> emit,
  ) {
    return _redeem(emit, () => redeemRequestQr(event.token));
  }

  Future<void> _onCampaignQrRedeemed(
    DonorCampaignQrRedeemed event,
    Emitter<DonorFeedState> emit,
  ) {
    return _redeem(emit, () => redeemCampaignQr(event.token));
  }

  Future<void> _onQrRedeemed(
    DonorQrRedeemed event,
    Emitter<DonorFeedState> emit,
  ) {
    return _redeem(emit, () => redeemQr(event.token));
  }

  Future<void> _redeem(
    Emitter<DonorFeedState> emit,
    Future<Either<Failure, DonationRecordEntity>> Function() redeem,
  ) async {
    if (!_startMutation(emit)) return;
    final result = await redeem();
    await result.fold(
      (Failure failure) async => emit(DonorFeedError(failure)),
      (_) => _load(emit, mutation: DonorFeedMutation.donationRecorded),
    );
  }

  bool _startMutation(Emitter<DonorFeedState> emit) {
    final current = state;
    if (current is! DonorFeedLoaded || current.isMutating) return false;
    emit(current.copyWith(isMutating: true));
    return true;
  }

  Future<void> _load(
    Emitter<DonorFeedState> emit, {
    DonorFeedMutation? mutation,
  }) async {
    emit(const DonorFeedLoading());
    final feedResult = await getFeed(NoParams());
    final feed = feedResult.fold((failure) {
      emit(DonorFeedError(failure));
      return null;
    }, (value) => value);
    if (feed == null) return;

    final recordsResult = await getRecords(NoParams());
    recordsResult.fold(
      (failure) => emit(DonorFeedError(failure)),
      (records) => emit(
        DonorFeedLoaded(feed: feed, records: records, lastMutation: mutation),
      ),
    );
  }
}
