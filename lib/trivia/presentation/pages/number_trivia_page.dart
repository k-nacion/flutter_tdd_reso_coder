import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_reso_coder/injection_container.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/text_form/text_form_cubit.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/widgets/input_area.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/widgets/output_area.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Number Trivia Page'),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<NumberTriviaBloc>(create: (context) => sl<NumberTriviaBloc>()),
          BlocProvider<TextFormCubit>(create: (context) => TextFormCubit()),
        ],
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            OutputArea(),
            InputArea(),
          ],
        ),
      ),
    );
  }
}
