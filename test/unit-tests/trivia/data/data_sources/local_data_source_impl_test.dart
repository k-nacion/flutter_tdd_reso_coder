import 'dart:convert';

import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/local_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalDataSourceImpl', () {
    late MockSharedPreferences mockSharedPreferences;
    late LocalDataSourceImpl dataSourceImplSUT;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      dataSourceImplSUT =
          LocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
    });

    final tNumberTriviaModel =
        NumberTriviaModel.fromMap(jsonDecode(fixture('response.json')));
    final tStringConverted = jsonEncode(tNumberTriviaModel.toMap());

    group('cacheNumberTrivia', () {
      test(
        'should cached the NumberTriviaModel',
        () async {
          when(() => mockSharedPreferences.setString(
                  CACHED_NUMBER_TRIVIA, tStringConverted))
              .thenAnswer((_) async => true);

          await dataSourceImplSUT.cacheNumberTrivia(tNumberTriviaModel);

          verify(() => mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, tStringConverted));
        },
      );

      test(
        'should throw CachedException if was unsuccessful caching data',
        () async {
          when(() => mockSharedPreferences.setString(
                  CACHED_NUMBER_TRIVIA, tStringConverted))
              .thenAnswer((_) async => false);

          expect(
              () async =>
                  dataSourceImplSUT.cacheNumberTrivia(tNumberTriviaModel),
              throwsA(isA<CachedException>()));
        },
      );
    });

    group('getLastTrivia', () {
      test(
        'should be able to return the cached NumberTriviaModel successfully',
        () async {
          when(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
              .thenReturn(tStringConverted);

          final actual = await dataSourceImplSUT.getLastTrivia();

          expect(actual, tNumberTriviaModel);
          verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        },
      );

      test(
        'should throw a CachedException when the value stored in sharedpreference returned a null value.',
        () async {
          when(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
              .thenReturn(null);

          void functionCaller() => dataSourceImplSUT.getLastTrivia();

          expect(functionCaller, throwsA(isA<CachedException>()));
          verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        },
      );
    });
  });
}
