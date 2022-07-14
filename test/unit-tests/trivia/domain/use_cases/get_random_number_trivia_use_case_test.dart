import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_random_number_trivia_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  group('GetRandomNumberTriviaUseCase', () {
    late final MockNumberTriviaRepository mockNumberTriviaRepository;
    late final GetRandomNumberTriviaUseCase useCaseSUT;

    setUp(() {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      useCaseSUT = GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
    });

    const Either<Failure, NumberTrivia> tNumberTrivia =
        Right(NumberTrivia(number: 1, trivia: 'sample'));

    test(
      'should return a NumberTrivia object after successful fetch of data',
      () async {
        when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNumberTrivia);

        final actualResult = await useCaseSUT();

        expect(actualResult, tNumberTrivia);
        verify(() => mockNumberTriviaRepository.getRandomNumberTrivia()).called(1);
        verifyNever(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()));
        verifyNoMoreInteractions(mockNumberTriviaRepository);
      },
    );
  });
}
