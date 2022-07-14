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

  final tNumberTriviaModel = NumberTriviaModel.fromMap(jsonDecode(fixture('response.json')));
  final Either<Failure, NumberTrivia> tNumberTriviaSuccess = Right(tNumberTriviaModel);
  const Either<Failure, NumberTrivia> tNumberTriviaServerFailure = Left(ServerFailure());
  const Either<Failure, NumberTrivia> tNumberTriviaCacheFailure = Left(CacheFailure());
  const tNumber = 1;

  void runOnline(void Function() body) {
    group('device is ONLINE', () {
      setUp(() {
        when(() => mockNetworkInfo.hasInternetConnection).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runOffline(void Function() body) {
    group('device is OFFLINE', () {
      setUp(() => when(() => mockNetworkInfo.hasInternetConnection).thenAnswer((_) async => false));

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

          expect(await mockNetworkInfo.hasInternetConnection, true);
          verify(() => mockNetworkInfo.hasInternetConnection);
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
          expect(await mockNetworkInfo.hasInternetConnection, true);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).called(1);
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

          expect(await mockNetworkInfo.hasInternetConnection, true);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
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

          expect(await mockNetworkInfo.hasInternetConnection, true);
          expect(actual, tNumberTriviaServerFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).called(1);
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

          expect(await mockNetworkInfo.hasInternetConnection, true);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).called(1);
          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockLocalDataSource.getLastTrivia());
          verifyNoMoreInteractions(mockRemoteDataSource);
          verifyNoMoreInteractions(mockNetworkInfo);
        },
      );
    });

    runOffline(() {
      test(
        'should return the latest cached NumberTriviaModel from the local datasource',
        () async {
          when(() => mockLocalDataSource.getLastTrivia())
              .thenAnswer((invocation) async => tNumberTriviaModel);

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.hasInternetConnection, false);
          expect(actual, tNumberTriviaSuccess);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastTrivia()).called(1);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
        },
      );

      test(
        'should throw a CachedException if was unsuccessful fetching data from cache',
        () async {
          when(() => mockLocalDataSource.getLastTrivia()).thenThrow(CachedException());

          final actual = await repositorySUT.getConcreteNumberTrivia(tNumber);

          expect(await mockNetworkInfo.hasInternetConnection, false);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockLocalDataSource.getLastTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
        },
      );
    });
  });

  group('getRandomNumberTrivia()', () {
    runOnline(() {
      test(
        'should verify that there is an internet connect',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(any())).thenAnswer((_) async {});

          repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, true);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
        },
      );

      test(
        'should receive the remote data from the server when successful.',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(any())).thenAnswer((_) async {});

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, true);
          expect(actual, tNumberTriviaSuccess);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
        },
      );

      test(
        'should cached the remote data before returning the value out of the method',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, true);
          expect(actual, tNumberTriviaSuccess);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
          verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          verifyNever(() => mockLocalDataSource.getLastTrivia());
        },
      );

      test(
        'should throw a ServerException when fetching data from repository and return a ServerFailure instead',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, true);
          expect(actual, tNumberTriviaServerFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
          verifyZeroInteractions(mockLocalDataSource);
        },
      );

      test(
        'should throw a $CachedException when an error occurred in local datasource',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(CachedException());

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect((await mockNetworkInfo.hasInternetConnection), true);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(any()));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });
    runOffline(() {
      test(
        'should verify that there is no internet connection',
        () async {
          when(
            () => mockLocalDataSource.getLastTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, false);
          verify(() => mockNetworkInfo.hasInternetConnection);
        },
      );

      test(
        'should return the last cached NumberTriviaModel when internet is not available',
        () async {
          when(() => mockLocalDataSource.getLastTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, false);
          expect(actual, tNumberTriviaSuccess);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockLocalDataSource.getLastTrivia()).called(1);
          verifyZeroInteractions(mockRemoteDataSource);
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
        },
      );

      test(
        'should throw a CachedException and return a CachedFailure when dealing with local datasource',
        () async {
          when(() => mockLocalDataSource.getLastTrivia()).thenThrow(CachedException());

          final actual = await repositorySUT.getRandomNumberTrivia();

          expect(await mockNetworkInfo.hasInternetConnection, false);
          expect(actual, tNumberTriviaCacheFailure);
          verify(() => mockNetworkInfo.hasInternetConnection);
          verify(() => mockLocalDataSource.getLastTrivia());
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(any()));
          verifyZeroInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}
