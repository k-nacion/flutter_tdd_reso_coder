import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.trivia, required super.number});

  NumberTriviaModel copyWith({
    String? trivia,
    int? number,
  }) {
    return NumberTriviaModel(
      trivia: trivia ?? super.trivia,
      number: number ?? super.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': super.trivia,
      'number': super.number,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      trivia: map['text'] as String,
      number: (map['number'] as num).toInt(),
    );
  }

  @override
  String toString() {
    return 'NumberTriviaModel{text: ${super.trivia}, number: ${super.number}}';
  }
}
