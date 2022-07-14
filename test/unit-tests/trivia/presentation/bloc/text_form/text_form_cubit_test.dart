import 'package:flutter_tdd_reso_coder/trivia/presentation/bloc/text_form/text_form_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextFormCubit', () {
    late TextFormCubit textFormCubitSUT;

    setUp(() {
      textFormCubitSUT = TextFormCubit();
    });

    test(
      'should test the initial value of TextFormState as an empty string',
      () async {
        expect(textFormCubitSUT.state, const TextFormState(value: ''));
      },
    );

    group('updateState', () {
      test(
        'should update the state\'s value to new one',
        () async {
          const newValue = '123';

          textFormCubitSUT.updateState(newValue);

          expect(textFormCubitSUT.state, const TextFormState(value: '123'));
        },
      );
    });
  });
}
