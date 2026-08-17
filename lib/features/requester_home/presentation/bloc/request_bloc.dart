import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/blood_request_entity.dart';
import '../../domain/usecases/request_usecases.dart';

enum RequestViewStatus {
  initial,
  loading,
  loaded,
  empty,
  submitting,
  success,
  failure,
}

class RequestState extends Equatable {
  final RequestViewStatus status;
  final List<BloodRequestEntity> requests;
  final List<HospitalEntity> hospitals;
  // Donors who responded, keyed by request id. Loaded lazily by the donors
  // tab so the other tabs don't pay for the extra per-request fetches.
  final Map<String, List<RequestDonorEntity>> donorsByRequestId;
  final bool donorsLoaded;
  final String? errorMessage;

  const RequestState({
    this.status = RequestViewStatus.initial,
    this.requests = const [],
    this.hospitals = const [],
    this.donorsByRequestId = const {},
    this.donorsLoaded = false,
    this.errorMessage,
  });

  RequestState copyWith({
    RequestViewStatus? status,
    List<BloodRequestEntity>? requests,
    List<HospitalEntity>? hospitals,
    Map<String, List<RequestDonorEntity>>? donorsByRequestId,
    bool? donorsLoaded,
    String? errorMessage,
    bool clearError = false,
  }) => RequestState(
    status: status ?? this.status,
    requests: requests ?? this.requests,
    hospitals: hospitals ?? this.hospitals,
    donorsByRequestId: donorsByRequestId ?? this.donorsByRequestId,
    donorsLoaded: donorsLoaded ?? this.donorsLoaded,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    requests,
    hospitals,
    donorsByRequestId,
    donorsLoaded,
    errorMessage,
  ];
}

sealed class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object?> get props => const [];
}

class RequestsLoadRequested extends RequestEvent {
  const RequestsLoadRequested();
}

/// Loads the donors who responded to each of the recipient's requests. Kept
/// separate from [RequestsLoadRequested] so only the donors tab triggers the
/// per-request fetches.
class RequestDonorsLoadRequested extends RequestEvent {
  const RequestDonorsLoadRequested();
}

class RequestCreateSubmitted extends RequestEvent {
  final RequestDraft draft;

  const RequestCreateSubmitted(this.draft);

  @override
  List<Object?> get props => [draft];
}

class RequestUpdateSubmitted extends RequestEvent {
  final String requestId;
  final RequestDraft draft;

  const RequestUpdateSubmitted({required this.requestId, required this.draft});

  @override
  List<Object?> get props => [requestId, draft];
}

class RequestCancelSubmitted extends RequestEvent {
  final String requestId;
  final String reason;

  const RequestCancelSubmitted({required this.requestId, required this.reason});

  @override
  List<Object?> get props => [requestId, reason];
}

class RequestReactivateSubmitted extends RequestEvent {
  final String requestId;

  const RequestReactivateSubmitted({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final GetRecipientRequests getRequests;
  final GetHospitals getHospitals;
  final CreateRecipientRequest createRequest;
  final UpdateRecipientRequest updateRequest;
  final CancelRecipientRequest cancelRequest;
  final ReactivateRecipientRequest reactivateRequest;
  final GetRequestDonors getDonors;

  RequestBloc({
    required this.getRequests,
    required this.getHospitals,
    required this.createRequest,
    required this.updateRequest,
    required this.cancelRequest,
    required this.getDonors,
  }) : super(const RequestState()) {
    on<RequestsLoadRequested>(_onLoad);
    on<RequestDonorsLoadRequested>(_onLoadDonors);
    on<RequestCreateSubmitted>(_onCreate);
    on<RequestUpdateSubmitted>(_onUpdate);
    on<RequestCancelSubmitted>(_onCancel);
  }

  Future<void> _onLoad(
    RequestsLoadRequested event,
    Emitter<RequestState> emit,
  ) async {
    emit(state.copyWith(status: RequestViewStatus.loading, clearError: true));

    final requestsResult = await getRequests(NoParams());
    final requestFailure = requestsResult.fold(
      (failure) => failure,
      (_) => null,
    );
    if (requestFailure != null) {
      emit(
        state.copyWith(
          status: RequestViewStatus.failure,
          errorMessage: requestFailure.message,
        ),
      );
      return;
    }

    final hospitalsResult = await getHospitals(NoParams());
    final hospitalFailure = hospitalsResult.fold(
      (failure) => failure,
      (_) => null,
    );
    if (hospitalFailure != null) {
      emit(
        state.copyWith(
          status: RequestViewStatus.failure,
          errorMessage: hospitalFailure.message,
        ),
      );
      return;
    }

    final requests = requestsResult.getOrElse(() => const []);
    final hospitals = hospitalsResult.getOrElse(() => const []);
    emit(
      RequestState(
        status: requests.isEmpty
            ? RequestViewStatus.empty
            : RequestViewStatus.loaded,
        requests: requests,
        hospitals: hospitals,
      ),
    );
  }

  Future<void> _onLoadDonors(
    RequestDonorsLoadRequested event,
    Emitter<RequestState> emit,
  ) async {
    // Fetch responders for every request in parallel; a per-request failure
    // degrades to an empty list rather than failing the whole tab.
    final entries = await Future.wait(
      state.requests.map((request) async {
        final result = await getDonors(request.id);
        return MapEntry(
          request.id,
          result.getOrElse(() => const <RequestDonorEntity>[]),
        );
      }),
    );
    emit(
      state.copyWith(
        donorsByRequestId: {for (final entry in entries) entry.key: entry.value},
        donorsLoaded: true,
      ),
    );
  }

  Future<void> _onCreate(
    RequestCreateSubmitted event,
    Emitter<RequestState> emit,
  ) async {
    emit(
      state.copyWith(status: RequestViewStatus.submitting, clearError: true),
    );
    final result = await createRequest(event.draft);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (request) => emit(
        state.copyWith(
          status: RequestViewStatus.success,
          requests: [request, ...state.requests],
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    RequestUpdateSubmitted event,
    Emitter<RequestState> emit,
  ) async {
    emit(
      state.copyWith(status: RequestViewStatus.submitting, clearError: true),
    );
    final result = await updateRequest(
      UpdateRequestParams(requestId: event.requestId, draft: event.draft),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: RequestViewStatus.success,
          requests: state.requests
              .map((request) => request.id == updated.id ? updated : request)
              .toList(),
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onCancel(
    RequestCancelSubmitted event,
    Emitter<RequestState> emit,
  ) async {
    emit(
      state.copyWith(status: RequestViewStatus.submitting, clearError: true),
    );
    final result = await cancelRequest(
      CancelRequestParams(requestId: event.requestId, reason: event.reason),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (cancelled) => emit(
        state.copyWith(
          status: RequestViewStatus.success,
          requests: state.requests
              .map(
                (request) => request.id == cancelled.id ? cancelled : request,
              )
              .toList(),
          clearError: true,
        ),
      ),
    );
  }
}
