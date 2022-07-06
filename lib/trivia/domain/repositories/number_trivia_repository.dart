import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  const NumberTriviaRepository();

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num);
}
