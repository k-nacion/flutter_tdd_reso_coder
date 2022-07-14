import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/text_form/text_form_cubit.dart';

class InputButtons extends StatelessWidget {
  const InputButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final numberInputString = context.read<TextFormCubit>().state.value;
              context
                  .read<NumberTriviaBloc>()
                  .add(NumberTriviaEventGetConcreteTrivia(numberInputString));
            },
            child: const Text('Search'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                context.read<NumberTriviaBloc>().add(const NumberTriviaEventGetRandomTrivia()),
            child: const Text('Random Trivia'),
          ),
        )
      ],
    );
  }
}
