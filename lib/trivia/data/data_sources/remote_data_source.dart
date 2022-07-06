import 'package:flutter_tdd_reso_coder/trivia/data/models/number_trivia_model.dart';

abstract class RemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
