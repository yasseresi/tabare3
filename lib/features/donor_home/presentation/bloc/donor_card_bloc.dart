import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/donor_card_entity.dart';
import '../../domain/usecases/get_donor_card.dart';

class DonorCardBloc extends Bloc<DonorCardEvent, DonorCardState> {
  final GetDonorCard getDonorCard;

  DonorCardBloc({required this.getDonorCard})
    : super(const DonorCardInitial()) {
    on<DonorCardRequested>(_onRequested);
  }

  Future<void> _onRequested(
    DonorCardRequested event,
    Emitter<DonorCardState> emit,
  ) async {
    emit(const DonorCardLoading());
    final result = await getDonorCard(NoParams());
    result.fold(
      (failure) => emit(DonorCardError(failure)),
      (card) => emit(DonorCardLoaded(card)),
    );
  }
}

abstract class DonorCardEvent extends Equatable {
  const DonorCardEvent();

  @override
  List<Object?> get props => [];
}

class DonorCardRequested extends DonorCardEvent {
  const DonorCardRequested();
}

abstract class DonorCardState extends Equatable {
  const DonorCardState();

  @override
  List<Object?> get props => [];
}

class DonorCardInitial extends DonorCardState {
  const DonorCardInitial();
}

class DonorCardLoading extends DonorCardState {
  const DonorCardLoading();
}

class DonorCardLoaded extends DonorCardState {
  final DonorCardEntity card;

  const DonorCardLoaded(this.card);

  @override
  List<Object?> get props => [card];
}

class DonorCardError extends DonorCardState {
  final Failure failure;

  const DonorCardError(this.failure);

  @override
  List<Object?> get props => [failure];
}
