import 'dart:convert';

import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/data_sources/remote_data_source.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixtures.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('RemoteDataSourceImpl', () {
    late MockHttpClient mockHttpClient;
    late RemoteDataSourceImpl remoteDataSourceImplSUT;

    setUp(() {
      mockHttpClient = MockHttpClient();
      remoteDataSourceImplSUT = RemoteDataSourceImpl(client: mockHttpClient);
    });

    setUpAll(() => registerFallbackValue(FakeUri()));

    const tNumber = 1;
    final tHttpSuccessResult = fixture('response.json');
    final tNumberTriviaModel =
        NumberTriviaModel.fromMap(jsonDecode(tHttpSuccessResult));
    Uri generateFakeUri(String Function() unencodedPath) =>
        Uri.http(NUMBERS_API_URI_AUTHORITY, unencodedPath());

    group('getConcreteNumberTrivia', () {
      test(
        'should be able to successfully return a NumberTriviaModel without errors',
        () async {
          when(() => mockHttpClient.read(
                generateFakeUri(() => tNumber.toString()),
                headers: NUMBERS_API_HEADER,
              )).thenAnswer((_) async => tHttpSuccessResult);

          final actual =
              await remoteDataSourceImplSUT.getConcreteNumberTrivia(tNumber);

          expect(actual, tNumberTriviaModel);
          verify(() => mockHttpClient.read(
              generateFakeUri(() => tNumber.toString()),
              headers: NUMBERS_API_HEADER));
        },
      );

      test(
        'should throw a ServerException when client.read() throws ClientException',
        () async {
          when(() => mockHttpClient.read(
              generateFakeUri(() => tNumber.toString()),
              headers: NUMBERS_API_HEADER)).thenThrow(http.ClientException(''));

          void functionToTest() async =>
              await remoteDataSourceImplSUT.getConcreteNumberTrivia(tNumber);

          expect(functionToTest, throwsA(isA<ServerException>()));
        },
      );
    });

    group('getRandomNumberTrivia', () {
      test(
        'should return a random number trivia successfully.',
        () async {
          when(() => mockHttpClient.read(
                  generateFakeUri(() => NUMBERS_API_URI_RANDOM_TRIVIA),
                  headers: NUMBERS_API_HEADER))
              .thenAnswer((invocation) async => tHttpSuccessResult);

          final actual = await remoteDataSourceImplSUT.getRandomNumberTrivia();

          expect(actual, tNumberTriviaModel);
          verify(() => mockHttpClient.read(
              generateFakeUri(() => NUMBERS_API_URI_RANDOM_TRIVIA),
              headers: NUMBERS_API_HEADER));
        },
      );

      test(
        'should throw ServerException when client throws ClientException',
        () async {
          when(() => mockHttpClient.read(
              generateFakeUri(() => NUMBERS_API_URI_RANDOM_TRIVIA),
              headers: NUMBERS_API_HEADER)).thenThrow(http.ClientException(''));

          void functionToTest() async =>
              await remoteDataSourceImplSUT.getRandomNumberTrivia();

          expect(functionToTest, throwsA(isA<ServerException>()));
          verify(() => mockHttpClient.read(
              generateFakeUri(() => NUMBERS_API_URI_RANDOM_TRIVIA),
              headers: NUMBERS_API_HEADER));
          ;
        },
      );
    });
  });
}
