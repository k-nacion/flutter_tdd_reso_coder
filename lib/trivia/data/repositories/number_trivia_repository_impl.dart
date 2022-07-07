import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/network/network_info.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/local_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/remote_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NetworkInfo _networkInfo;
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;

  const NumberTriviaRepositoryImpl({
    required NetworkInfo networkInfo,
    required LocalDataSource localDataSource,
    required RemoteDataSource remoteDataSource,
  })  : _networkInfo = networkInfo,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
          int num) async =>
      await _delegateRepositoryCaller(
          () => _remoteDataSource.getConcreteNumberTrivia(num));

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async =>
      await _delegateRepositoryCaller(
          () => _remoteDataSource.getRandomNumberTrivia());

  Future<Either<Failure, NumberTrivia>> _delegateRepositoryCaller(
      Future<NumberTriviaModel> Function() body) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Right(await _localDataSource.getLastTrivia());
      }

      try {
        final remoteData = await body();
        _localDataSource.cacheNumberTrivia(remoteData);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } on CachedException {
      return const Left(CachedFailure());
    }
  }
}
