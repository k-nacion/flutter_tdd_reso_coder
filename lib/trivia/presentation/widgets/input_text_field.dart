import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/text_form/text_form_cubit.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(),
      onChanged: (value) => context.read<TextFormCubit>().updateState(value),
    );
  }
}
