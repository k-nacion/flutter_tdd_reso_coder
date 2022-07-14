import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  const NumberTriviaRepository();

  ///Fetches a random trivia.
  ///
  /// Returns [ServerFailure] if connection in the internet failed.
  ///
  /// Returns [CacheFailure] if unsuccessful on caching or retrieving cached data.
  ///
  /// Returns [NumberTrivia] if successful.
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

  ///Fetches a random trivia.
  ///
  /// Returns [ServerFailure] if connection in the internet failed.
  ///
  /// Returns [CacheFailure] if unsuccessful on caching or retrieving cached data.
  ///
  /// Returns [NumberTrivia] if successful.
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num);
}
