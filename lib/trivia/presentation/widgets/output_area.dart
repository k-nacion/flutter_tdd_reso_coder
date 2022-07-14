import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class OutputArea extends StatelessWidget {
  const OutputArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
            if (state is NumberTriviaStateEmpty)
              return _buildEmptyStateView(context);
            else if (state is NumberTriviaStateLoading)
              return _buildLoadingView();
            else if (state is NumberTriviaStateLoaded)
              return _buildLoadedView(context, state);
            else
              return _buildErrorView(context, state as NumberTriviaStateError);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyStateView(BuildContext context) => Center(
        child: Text(
          'Start searching numbers...',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );

  Widget _buildLoadingView() => const Center(
        child: CircularProgressIndicator.adaptive(),
      );

  Widget _buildErrorView(BuildContext context, NumberTriviaStateError state) => Center(
        child: Text(
          state.message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );

  Widget _buildLoadedView(BuildContext context, NumberTriviaStateLoaded state) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.number,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.trivia,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
}
