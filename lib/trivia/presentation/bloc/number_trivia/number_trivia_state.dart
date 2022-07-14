part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object?> get props => [];
}

class NumberTriviaStateEmpty extends NumberTriviaState {
  const NumberTriviaStateEmpty();
}

class NumberTriviaStateLoading extends NumberTriviaState {
  const NumberTriviaStateLoading();
}

class NumberTriviaStateLoaded extends NumberTriviaState {
  final String number;
  final String trivia;

  const NumberTriviaStateLoaded({
    required this.number,
    required this.trivia,
  });

  @override
  List<Object> get props => [number, trivia];
}

class NumberTriviaStateError extends NumberTriviaState {
  final String message;

  const NumberTriviaStateError(this.message);

  @override
  List<Object> get props => [message];
}
