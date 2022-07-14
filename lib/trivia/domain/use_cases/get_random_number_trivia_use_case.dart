import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/use_cases/usecase.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase extends UseCase<NumberTrivia, void> {
  final NumberTriviaRepository _repository;

  const GetRandomNumberTriviaUseCase(this._repository);

  ///Fetches a random trivia.
  ///
  /// Returns [ServerFailure] if connection in the internet failed.
  ///
  /// Returns [CacheFailure] if unsuccessful on caching or retrieving cached data.
  ///
  /// Returns [NumberTrivia] if successful.
  @override
  Future<Either<Failure, NumberTrivia>> call([void param]) async {
    return await _repository.getRandomNumberTrivia();
  }
}
