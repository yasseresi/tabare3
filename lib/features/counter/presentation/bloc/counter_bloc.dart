import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;

  CounterBloc({required this.getCounter, required this.incrementCounter})
    : super(const CounterInitial()) {
    on<GetCounterEvent>((event, emit) async {
      emit(const CounterLoading());
      final failureOrCounter = await getCounter(NoParams());
      failureOrCounter.fold(
        (failure) => emit(const CounterError(message: 'Cache Failure')),
        (counter) => emit(CounterLoaded(value: counter.value)),
      );
    });

    on<IncrementCounterEvent>((event, emit) async {
      final failureOrCounter = await incrementCounter(NoParams());
      failureOrCounter.fold(
        (failure) => emit(const CounterError(message: 'Cache Failure')),
        (counter) => emit(CounterLoaded(value: counter.value)),
      );
    });
  }
}
