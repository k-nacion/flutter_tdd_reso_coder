import 'package:flutter/material.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/widgets/input_buttons.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/widgets/input_text_field.dart';

class InputArea extends StatelessWidget {
  const InputArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        SizedBox(height: 20),
        InputTextField(),
        SizedBox(height: 20),
        InputButtons(),
      ],
    );
  }
}
