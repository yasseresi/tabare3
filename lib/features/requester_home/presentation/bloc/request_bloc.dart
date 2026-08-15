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
  final String? errorMessage;

  const RequestState({
    this.status = RequestViewStatus.initial,
    this.requests = const [],
    this.hospitals = const [],
    this.errorMessage,
  });

  RequestState copyWith({
    RequestViewStatus? status,
    List<BloodRequestEntity>? requests,
    List<HospitalEntity>? hospitals,
    String? errorMessage,
    bool clearError = false,
  }) => RequestState(
    status: status ?? this.status,
    requests: requests ?? this.requests,
    hospitals: hospitals ?? this.hospitals,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, requests, hospitals, errorMessage];
}

sealed class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object?> get props => const [];
}

class RequestsLoadRequested extends RequestEvent {
  const RequestsLoadRequested();
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

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final GetRecipientRequests getRequests;
  final GetHospitals getHospitals;
  final CreateRecipientRequest createRequest;
  final UpdateRecipientRequest updateRequest;
  final CancelRecipientRequest cancelRequest;

  RequestBloc({
    required this.getRequests,
    required this.getHospitals,
    required this.createRequest,
    required this.updateRequest,
    required this.cancelRequest,
  }) : super(const RequestState()) {
    on<RequestsLoadRequested>(_onLoad);
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
