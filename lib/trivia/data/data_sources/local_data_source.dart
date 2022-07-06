import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';

abstract class LocalDataSource {
  Future<NumberTriviaModel> getLastTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}
