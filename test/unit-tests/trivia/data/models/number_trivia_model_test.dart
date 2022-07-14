import 'dart:convert';

import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockNumberTriviaModel extends Mock implements NumberTriviaModel {}

void main() {
  const tNumberTriviaModel = NumberTriviaModel(trivia: 'sample', number: 1);

  group('NumberTriviaModel', () {
    test(
      'should be a subclass of NumberTrivia',
      () async {
        expect(tNumberTriviaModel, isA<NumberTriviaModel>());
      },
    );

    group('NumberTriviaModel.fromMap', () {
      test(
        'should return a valid model when the number in response is integer',
        () async {
          final fixtureResult = fixture('response.json');
          final jsonMap = jsonDecode(fixtureResult);

          final actual = NumberTriviaModel.fromMap(jsonMap);

          expect(actual, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the number in response is double',
        () async {
          final fixtureResult = fixture('response_double.json');
          final jsonMap = jsonDecode(fixtureResult);

          final actual = NumberTriviaModel.fromMap(jsonMap);

          expect(actual, tNumberTriviaModel);
        },
      );
    });

    group('toMap()', () {
      test(
        'should convert the current object into a json map object',
        () async {
          final expectation = {'number': 1, 'text': 'sample'};

          final actualResult = tNumberTriviaModel.toMap();

          expect(actualResult, expectation);
        },
      );
    });

    group('copyWith', () {
      test(
        'should return a copy of the current NumberTriviaModel object when new number parameter is provided',
        () async {
          const expectation = NumberTriviaModel(trivia: 'sample', number: 2);

          final actual = tNumberTriviaModel.copyWith(number: 2);

          expect(actual, expectation);
          expect(identical(actual, expectation), false);
        },
      );

      test(
        'should return a copy of the current NumberTriviaModel object when new text parameter is provided.',
        () async {
          const expectation = NumberTriviaModel(trivia: 'test', number: 1);

          final actual = tNumberTriviaModel.copyWith(trivia: 'test');

          expect(actual, expectation);
          expect(identical(actual, expectation), false);
        },
      );
    });

    test(
      'should return a toString equivalent',
      () async {
        const expectation = 'NumberTriviaModel{text: sample, number: 1}';

        final actual = tNumberTriviaModel.toString();

        expect(actual, expectation);
      },
    );
  });
}
