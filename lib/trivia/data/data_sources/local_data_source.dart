import 'dart:convert';

import 'package:flutter_tdd_reso_coder/core/error/exception.dart';
import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<NumberTriviaModel> getLastTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _sharedPreferences;

  const LocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel model) async {
    final isSuccess = await _sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, jsonEncode(model.toMap()));

    if (!isSuccess) {
      throw CachedException();
    }
  }

  @override
  Future<NumberTriviaModel> getLastTrivia() async {
    final lastTrivia = _sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (lastTrivia == null) {
      throw CachedException();
    }

    final decodedString = jsonDecode(lastTrivia);
    return NumberTriviaModel.fromMap(decodedString);
  }
}
