import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blood_request_entity.dart';
import '../../domain/usecases/request_usecases.dart';

enum RequestDetailStatus { initial, loading, loaded, actionLoading, failure }

class RequestDetailState extends Equatable {
  final RequestDetailStatus status;
  final List<RequestDonorEntity> donors;
  final List<CompatibleDonorEntity> compatibleDonors;
  final List<DirectInvitationEntity> invitations;
  final IssuedRequestQrEntity? issuedQr;
  final String? errorMessage;

  const RequestDetailState({
    this.status = RequestDetailStatus.initial,
    this.donors = const [],
    this.compatibleDonors = const [],
    this.invitations = const [],
    this.issuedQr,
    this.errorMessage,
  });

  RequestDetailState copyWith({
    RequestDetailStatus? status,
    List<RequestDonorEntity>? donors,
    List<CompatibleDonorEntity>? compatibleDonors,
    List<DirectInvitationEntity>? invitations,
    IssuedRequestQrEntity? issuedQr,
    String? errorMessage,
    bool clearError = false,
  }) => RequestDetailState(
    status: status ?? this.status,
    donors: donors ?? this.donors,
    compatibleDonors: compatibleDonors ?? this.compatibleDonors,
    invitations: invitations ?? this.invitations,
    issuedQr: issuedQr ?? this.issuedQr,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    donors,
    compatibleDonors,
    invitations,
    issuedQr,
    errorMessage,
  ];
}

sealed class RequestDetailEvent extends Equatable {
  const RequestDetailEvent();

  @override
  List<Object?> get props => const [];
}

class RequestDetailLoadRequested extends RequestDetailEvent {
  final String requestId;
  final bool includeCompatibleDonors;

  const RequestDetailLoadRequested({
    required this.requestId,
    required this.includeCompatibleDonors,
  });

  @override
  List<Object?> get props => [requestId, includeCompatibleDonors];
}

class RequestQrIssueRequested extends RequestDetailEvent {
  final String requestId;

  const RequestQrIssueRequested({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class CompatibleDonorInviteRequested extends RequestDetailEvent {
  final String requestId;
  final String donorId;

  const CompatibleDonorInviteRequested({
    required this.requestId,
    required this.donorId,
  });

  @override
  List<Object?> get props => [requestId, donorId];
}

class RequestDetailBloc extends Bloc<RequestDetailEvent, RequestDetailState> {
  final GetRequestDonors getDonors;
  final GetCompatibleDonors getCompatibleDonors;
  final GetRequestInvitations getInvitations;
  final InviteCompatibleDonor inviteDonor;
  final IssueRequestQr issueQr;

  RequestDetailBloc({
    required this.getDonors,
    required this.getCompatibleDonors,
    required this.getInvitations,
    required this.inviteDonor,
    required this.issueQr,
  }) : super(const RequestDetailState()) {
    on<RequestDetailLoadRequested>(_onLoad);
    on<RequestQrIssueRequested>(_onIssueQr);
    on<CompatibleDonorInviteRequested>(_onInvite);
  }

  Future<void> _onLoad(
    RequestDetailLoadRequested event,
    Emitter<RequestDetailState> emit,
  ) async {
    emit(state.copyWith(status: RequestDetailStatus.loading, clearError: true));
    final donorsResult = await getDonors(event.requestId);
    final donorFailure = donorsResult.fold((failure) => failure, (_) => null);
    if (donorFailure != null) {
      emit(
        state.copyWith(
          status: RequestDetailStatus.failure,
          errorMessage: donorFailure.message,
        ),
      );
      return;
    }

    var candidates = const <CompatibleDonorEntity>[];
    var invitations = const <DirectInvitationEntity>[];
    if (event.includeCompatibleDonors) {
      final candidatesResult = await getCompatibleDonors(event.requestId);
      final candidateFailure = candidatesResult.fold(
        (failure) => failure,
        (_) => null,
      );
      if (candidateFailure != null) {
        emit(
          state.copyWith(
            status: RequestDetailStatus.failure,
            errorMessage: candidateFailure.message,
          ),
        );
        return;
      }
      candidates = candidatesResult.getOrElse(() => const []);

      final invitationsResult = await getInvitations(event.requestId);
      final invitationFailure = invitationsResult.fold(
        (failure) => failure,
        (_) => null,
      );
      if (invitationFailure != null) {
        emit(
          state.copyWith(
            status: RequestDetailStatus.failure,
            errorMessage: invitationFailure.message,
          ),
        );
        return;
      }
      invitations = invitationsResult.getOrElse(() => const []);
    }

    emit(
      RequestDetailState(
        status: RequestDetailStatus.loaded,
        donors: donorsResult.getOrElse(() => const []),
        compatibleDonors: candidates,
        invitations: invitations,
      ),
    );
  }

  Future<void> _onIssueQr(
    RequestQrIssueRequested event,
    Emitter<RequestDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RequestDetailStatus.actionLoading,
        clearError: true,
      ),
    );
    final result = await issueQr(event.requestId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (qr) => emit(
        state.copyWith(
          status: RequestDetailStatus.loaded,
          issuedQr: qr,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onInvite(
    CompatibleDonorInviteRequested event,
    Emitter<RequestDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RequestDetailStatus.actionLoading,
        clearError: true,
      ),
    );
    final result = await inviteDonor(
      InviteDonorParams(requestId: event.requestId, donorId: event.donorId),
    );
    await result.fold<Future<void>>(
      (failure) async {
        emit(
          state.copyWith(
            status: RequestDetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) async {
        final invitationsResult = await getInvitations(event.requestId);
        invitationsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: RequestDetailStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (invitations) => emit(
            state.copyWith(
              status: RequestDetailStatus.loaded,
              compatibleDonors: state.compatibleDonors
                  .where((donor) => donor.donorId != event.donorId)
                  .toList(),
              invitations: invitations,
              clearError: true,
            ),
          ),
        );
      },
    );
  }
}
