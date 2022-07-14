import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/presentation/util/input_converter.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_random_number_trivia_use_case.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase _getConcreteNumberTrivia;
  final GetRandomNumberTriviaUseCase _getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase,
      required GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase,
      required this.inputConverter})
      : _getConcreteNumberTrivia = getConcreteNumberTriviaUseCase,
        _getRandomNumberTrivia = getRandomNumberTriviaUseCase,
        super(const NumberTriviaStateEmpty()) {
    on<NumberTriviaEventGetConcreteTrivia>(_mapGetConcreteTriviaToState);
    on<NumberTriviaEventGetRandomTrivia>(_mapGetRandomTriviaToState);
  }

  FutureOr<void> _mapGetConcreteTriviaToState(
    NumberTriviaEventGetConcreteTrivia event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final eventString = event.numberInput;

    final inputConverterResult = inputConverter.stringToUnsignedInt(eventString);

    await inputConverterResult.fold(
        (l) => Future(
              () {
                if (l is InvalidInputFailure)
                  emit(const NumberTriviaStateError(INVALID_INPUT_FAILURE_MESSAGE));
              },
            ),
        (r) async => Future(() async {
              emit(const NumberTriviaStateLoading());

              final triviaOrFailure = await _getConcreteNumberTrivia(r);

              triviaOrFailure.fold((l) {
                if (l is ServerFailure) emit(const NumberTriviaStateError(SERVER_FAILURE_MESSAGE));
                if (l is CacheFailure) emit(const NumberTriviaStateError(CACHE_FAILURE_MESSAGE));
              }, (r) async {
                emit(NumberTriviaStateLoaded(number: r.number.toString(), trivia: r.trivia));
              });
            }));
  }

  FutureOr<void> _mapGetRandomTriviaToState(
    NumberTriviaEventGetRandomTrivia event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(const NumberTriviaStateLoading());
    final triviaOrFailure = await _getRandomNumberTrivia();

    triviaOrFailure.fold((l) {
      if (l is ServerFailure) emit(const NumberTriviaStateError(SERVER_FAILURE_MESSAGE));
      if (l is CacheFailure) emit(const NumberTriviaStateError(CACHE_FAILURE_MESSAGE));
    }, (r) {
      emit(NumberTriviaStateLoaded(number: r.number.toString(), trivia: r.trivia));
    });
  }
}
