import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/use_cases/usecase.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase extends UseCase<NumberTrivia, int> {
  final NumberTriviaRepository _repository;

  const GetConcreteNumberTriviaUseCase(this._repository);

  @override
  Future<Either<Failure, NumberTrivia>> call([int? param]) async {
    if (param != null) {
      return await _repository.getConcreteNumberTrivia(param);
    }

    return const Left(ServerFailure());
  }
}
