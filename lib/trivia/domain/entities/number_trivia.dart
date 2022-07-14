import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String trivia;
  final int number;

  const NumberTrivia({
    required this.trivia,
    required this.number,
  });

  @override
  List<Object> get props => [trivia, number];
}
