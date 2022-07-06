import 'package:flutter_tdd_reso_coder/trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required super.text, required super.number});

  NumberTriviaModel copyWith({
    String? text,
    int? number,
  }) {
    return NumberTriviaModel(
      text: text ?? super.text,
      number: number ?? super.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': super.text,
      'number': super.number,
    };
  }

  factory NumberTriviaModel.fromMap(Map<String, dynamic> map) {
    return NumberTriviaModel(
      text: map['text'] as String,
      number: (map['number'] as num).toInt(),
    );
  }

  @override
  String toString() {
    return 'NumberTriviaModel{text: ${super.text}, number: ${super.number}}';
  }
}
