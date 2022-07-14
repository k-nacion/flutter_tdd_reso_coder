import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/presentation/util/input_converter.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTriviaUseCase extends Mock implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTriviaUseCase extends Mock implements GetRandomNumberTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  group('NumberTriviaBloc', () {
    late MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTriviaUseCase;
    late MockGetRandomNumberTriviaUseCase mockGetRandomNumberTriviaUseCase;
    late MockInputConverter mockInputConverter;
    late NumberTriviaBloc numberTriviaBlocSUT;

    setUp(() {
      mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
      mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
      mockInputConverter = MockInputConverter();
      numberTriviaBlocSUT = NumberTriviaBloc(
          getConcreteNumberTriviaUseCase: mockGetConcreteNumberTriviaUseCase,
          getRandomNumberTriviaUseCase: mockGetRandomNumberTriviaUseCase,
          inputConverter: mockInputConverter);
    });

    test(
      'initial state should be empty ',
      () async {
        expect(numberTriviaBlocSUT.state, const NumberTriviaStateEmpty());
      },
    );

    group('events', () {
      const tValidNumber = '1';
      const tInvalidNumber = 'abc';
      const tInvalidNegativeNumber = '-123';
      const Either<Failure, int> tSuccessConvert = Right(1);
      const Either<Failure, NumberTrivia> tSuccessNumberTrivia =
          Right(NumberTrivia(trivia: 'test', number: 1));
      const Either<Failure, NumberTrivia> tServerFailure = Left(ServerFailure());
      const Either<Failure, NumberTrivia> tCacheFailure = Left(CacheFailure());
      group('getConcreteNumberTrivia', () {
        test(
          'should emit NumberTriviaStateError and return an error message when input is invalid',
          () async {
            when(() => mockInputConverter.stringToUnsignedInt(tInvalidNumber))
                .thenReturn(const Left(InvalidInputFailure()));

            const expected = [
              NumberTriviaStateError(INVALID_INPUT_FAILURE_MESSAGE),
            ];

            expectLater(numberTriviaBlocSUT.stream.asBroadcastStream(), emitsInOrder(expected));
            numberTriviaBlocSUT.add(const NumberTriviaEventGetConcreteTrivia(tInvalidNumber));
            await untilCalled(() => mockInputConverter.stringToUnsignedInt(tInvalidNumber));
            verify(() => mockInputConverter.stringToUnsignedInt(tInvalidNumber));
          },
        );

        test(
          'should emit NumberTriviaStateError and return an error message when input contains negative value',
          () async {
            when(() => mockInputConverter.stringToUnsignedInt(tInvalidNegativeNumber))
                .thenReturn(const Left(InvalidInputFailure()));

            const expected = [NumberTriviaStateError(INVALID_INPUT_FAILURE_MESSAGE)];

            expectLater(numberTriviaBlocSUT.stream.asBroadcastStream(), emitsInOrder(expected));
            numberTriviaBlocSUT
                .add(const NumberTriviaEventGetConcreteTrivia(tInvalidNegativeNumber));
            await untilCalled(() => mockInputConverter.stringToUnsignedInt(tInvalidNegativeNumber));
            verify(() => mockInputConverter.stringToUnsignedInt(tInvalidNegativeNumber));
            verifyZeroInteractions(mockGetRandomNumberTriviaUseCase);
          },
        );

        test(
          'should get the data from use case successfully.',
          () async {
            //arrange
            when(() => mockInputConverter.stringToUnsignedInt(any())).thenReturn(tSuccessConvert);
            when(() => mockGetConcreteNumberTriviaUseCase.call(any()))
                .thenAnswer((_) async => tSuccessNumberTrivia);

            //act
            numberTriviaBlocSUT.add(const NumberTriviaEventGetConcreteTrivia(tValidNumber));

            //assert
            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder(const [
                  NumberTriviaStateLoading(),
                  NumberTriviaStateLoaded(number: '1', trivia: 'test')
                ]));
            await untilCalled(() => mockInputConverter.stringToUnsignedInt(any()));
            verify(() => mockInputConverter.stringToUnsignedInt(any()));
            verify(() => mockGetConcreteNumberTriviaUseCase.call(any()));
            verifyZeroInteractions(mockGetRandomNumberTriviaUseCase);
          },
        );

        test(
          'should return server failure message if ServerFailure was returned from use case',
          () async {
            when(() => mockInputConverter.stringToUnsignedInt(tValidNumber))
                .thenReturn(tSuccessConvert);
            when(() => mockGetConcreteNumberTriviaUseCase.call(any()))
                .thenAnswer((_) async => tServerFailure);

            const expected = [
              NumberTriviaStateLoading(),
              NumberTriviaStateError(SERVER_FAILURE_MESSAGE)
            ];

            numberTriviaBlocSUT.add(const NumberTriviaEventGetConcreteTrivia(tValidNumber));
            expect(numberTriviaBlocSUT.stream.asBroadcastStream(), emitsInOrder(expected));
            await untilCalled(() => mockGetConcreteNumberTriviaUseCase.call(any()));
            verify(() => mockGetConcreteNumberTriviaUseCase.call(any()));
          },
        );

        test(
          'should emit [NumberTriviaStateLoading, NumberTriviaStateError] and produce a server error message',
          () async {
            when(() => mockInputConverter.stringToUnsignedInt(tValidNumber))
                .thenReturn(tSuccessConvert);
            when(() => mockGetConcreteNumberTriviaUseCase.call(1))
                .thenAnswer((_) async => tServerFailure);

            numberTriviaBlocSUT.add(const NumberTriviaEventGetConcreteTrivia(tValidNumber));

            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder(const [
                  NumberTriviaStateLoading(),
                  NumberTriviaStateError(SERVER_FAILURE_MESSAGE)
                ]));
            await untilCalled(
              () => mockInputConverter.stringToUnsignedInt(any()),
            );
            verify(() => mockInputConverter.stringToUnsignedInt(tValidNumber));
            await untilCalled(() => mockGetConcreteNumberTriviaUseCase.call(1));
            verify(() => mockGetConcreteNumberTriviaUseCase.call(1));
            verifyZeroInteractions(mockGetRandomNumberTriviaUseCase);
          },
        );

        test(
          'should emit [NumberTriviaStateLoading, NumberTriviaStateError] and produce cache error message',
          () async {
            when(() => mockInputConverter.stringToUnsignedInt(tValidNumber))
                .thenReturn(tSuccessConvert);
            when(() => mockGetConcreteNumberTriviaUseCase.call(1))
                .thenAnswer((invocation) async => tCacheFailure);

            numberTriviaBlocSUT.add(const NumberTriviaEventGetConcreteTrivia(tValidNumber));

            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder(const [
                  NumberTriviaStateLoading(),
                  NumberTriviaStateError(CACHE_FAILURE_MESSAGE)
                ]));
            await untilCalled(() => mockInputConverter.stringToUnsignedInt(tValidNumber));
            verify(() => mockInputConverter.stringToUnsignedInt(tValidNumber));
            verify(() => mockGetConcreteNumberTriviaUseCase.call(1));
            verifyZeroInteractions(mockGetRandomNumberTriviaUseCase);
          },
        );
      });
      group('getRandomNumberTrivia', () {
        test(
          'should emit [NumberTriviaLoading, NumberTriviaLoaded] when successful fetching data from repository',
          () async {
            when(() => mockGetRandomNumberTriviaUseCase.call())
                .thenAnswer((_) async => tSuccessNumberTrivia);

            numberTriviaBlocSUT.add(const NumberTriviaEventGetRandomTrivia());

            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder([
                  const NumberTriviaStateLoading(),
                  const NumberTriviaStateLoaded(number: '1', trivia: 'test')
                ]));
            await untilCalled(() => mockGetRandomNumberTriviaUseCase.call());
            verify(() => mockGetRandomNumberTriviaUseCase.call());
            verifyZeroInteractions(mockGetConcreteNumberTriviaUseCase);
          },
        );

        test(
          'should emit [NumberTriviaLoading, NumberTriviaError] and returns a ServerFailur if there is a problem with the server',
          () async {
            when(() => mockGetRandomNumberTriviaUseCase()).thenAnswer((_) async => tServerFailure);

            numberTriviaBlocSUT.add(const NumberTriviaEventGetRandomTrivia());

            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder(const [
                  NumberTriviaStateLoading(),
                  NumberTriviaStateError(SERVER_FAILURE_MESSAGE)
                ]));
            await untilCalled(() => mockGetRandomNumberTriviaUseCase.call());
            verify(() => mockGetRandomNumberTriviaUseCase.call());
            verifyZeroInteractions(mockGetConcreteNumberTriviaUseCase);
            verifyZeroInteractions(mockInputConverter);
          },
        );

        test(
          'should emit [NumberTriviaLoading, NumberTriviaError] and return a CacheFailure when there is a problem in caching',
          () async {
            when(() => mockGetRandomNumberTriviaUseCase()).thenAnswer((_) async => tCacheFailure);

            numberTriviaBlocSUT.add(const NumberTriviaEventGetRandomTrivia());

            expect(
                numberTriviaBlocSUT.stream.asBroadcastStream(),
                emitsInOrder(const [
                  NumberTriviaStateLoading(),
                  NumberTriviaStateError(CACHE_FAILURE_MESSAGE)
                ]));
            await untilCalled(() => mockGetRandomNumberTriviaUseCase());
            verify(() => mockGetRandomNumberTriviaUseCase());
            verifyZeroInteractions(mockGetConcreteNumberTriviaUseCase);
            verifyZeroInteractions(mockInputConverter);
          },
        );
      });
    });
  });
}
