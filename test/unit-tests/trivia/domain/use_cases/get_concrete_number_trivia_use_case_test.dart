import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_reso_coder/trivia/domain/use_cases/get_concrete_number_trivia_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  group('GetConcreteNumberTriviaUseCase', () {
    late final MockNumberTriviaRepository mockNumberTriviaRepository;
    late final GetConcreteNumberTriviaUseCase useCaseSUT;

    setUp(() {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      useCaseSUT = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
    });

    const Either<Failure, NumberTrivia> tNumberTrivia =
        Right(NumberTrivia(trivia: 'sample', number: 1));
    const tNumber = 1;
    test(
      'should return NumberTrivia successfully from the repository',
      () async {
        when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
            .thenAnswer((invocation) async => tNumberTrivia);

        final actualResult = await useCaseSUT(tNumber);

        expect(actualResult, tNumberTrivia);
        verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)).called(1);
        verifyNever(() => mockNumberTriviaRepository.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRepository);
      },
    );
  });
}
