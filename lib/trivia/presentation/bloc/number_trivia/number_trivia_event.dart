part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object?> get props => [];
}

class NumberTriviaEventGetRandomTrivia extends NumberTriviaEvent {
  const NumberTriviaEventGetRandomTrivia();
}

class NumberTriviaEventGetConcreteTrivia extends NumberTriviaEvent {
  final String numberInput;

  const NumberTriviaEventGetConcreteTrivia(this.numberInput);

  @override
  List<Object> get props => [numberInput];
}
