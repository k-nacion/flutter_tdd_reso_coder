import 'dart:convert';

import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart';

const NUMBERS_API_URI_AUTHORITY = 'numbersapi.com';
const NUMBERS_API_URI_RANDOM_TRIVIA = 'random/trivia';
const NUMBERS_API_HEADER = {'Content-Type': 'application/json'};

abstract class RemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Client _client;

  const RemoteDataSourceImpl({
    required Client client,
  }) : _client = client;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num) async =>
      _getRemoteTrivia(num.toString());

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async =>
      _getRemoteTrivia(NUMBERS_API_URI_RANDOM_TRIVIA);

  Future<NumberTriviaModel> _getRemoteTrivia(String unencodedPath) async {
    final uri = Uri.http(NUMBERS_API_URI_AUTHORITY, unencodedPath);

    try {
      final parsedResult = await _client.read(uri, headers: NUMBERS_API_HEADER);

      return NumberTriviaModel.fromMap(jsonDecode(parsedResult));
    } on ClientException {
      throw ServerException();
    }
  }
}
