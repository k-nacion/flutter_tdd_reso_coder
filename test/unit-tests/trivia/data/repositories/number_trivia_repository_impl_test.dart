import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/network/network_info.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/local_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/remote_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class FakeNumberTriviaModel extends Fake implements NumberTriviaModel {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late NumberTriviaRepositoryImpl repositorySUT;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repositorySUT = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() => registerFallbackValue(FakeNumberTriviaModel()));

  final tNumberTriviaModel =
      NumberTriviaModel.fromMap(jsonDecode(fixture('response.json')));
  final Either<Failure, NumberTrivia> tNumberTriviaSuccess =
      Right(tNumberTriviaModel);
  const Either<Failure, NumberTrivia> tNumberTriviaServerFailure =
      Left(ServerFailure());
  const Either<Failure, NumberTrivia> tNumberTriviaCacheFailure =
      Left(CachedFailure());
  const tNumber = 1;

  void runOnline(void Function() body) {
    group('device is ONLINE', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runOffline(void Function() body) {
    group('device is OFFLINE', () {
      setUp(() => when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false));

      body();
    });
  }

  group('getConcreteNumberTrivia(int num)', () {
    runOnline(() {
      test(
        'should verify if there is an internet connection first',
        () async {
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, true);
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      test(
        'should return a NumberTrivia object when response.statusCode = 200',
        () async {
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(actual, tNumberTriviaSuccess);
          expect(await mockNetworkInfo.isConnected, true);
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .called(1);
          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
        },
      );

      test(
        'should cache the data after fetching the NumberTriviaModel and before returning the value',
        () async {
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any<int>()),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, true);
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(
              () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          expect(actual, tNumberTriviaSuccess);
          verifyNever(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );
        },
      );

      test(
        'should throw a ServerException if unsuccessful fetching data from the server',
        () async {
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, true);
          expect(actual, tNumberTriviaServerFailure);
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .called(1);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should throw a CachedException if unsuccessful caching if NumberTriviaModel',
        () async {
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((invocation) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenThrow(CachedException());

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, true);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .called(1);
          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockLocalDataSource.getLastTrivia());
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockNetworkInfo);
        },
      );
    });

    runOffline(() {
      test(
        'should verify if there is no internet connection',
        () async {
          when(() => mockLocalDataSource.getLastTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);

          await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, false);
          verify(() => mockNetworkInfo.isConnected);
        },
      );

      test(
        'should return the latest cached NumberTriviaModel from the local datasource',
        () async {
          when(() => mockLocalDataSource.getLastTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, false);
          expect(actual, tNumberTriviaSuccess);
          verify(() => mockNetworkInfo.isConnected);
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastTrivia()).called(1);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
        },
      );

      test(
        'should throw a CachedException if was unsuccessful fetching data from cache',
        () async {
          when(() => mockLocalDataSource.getLastTrivia())
              .thenThrow(CachedException());

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.isConnected, false);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.isConnected);
          verify(() => mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
        },
      );
    });
  });
}
