import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';
import 'package:flutter_tdd_reso_coder/core/presentation/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputConverter', () {
    late InputConverter inputConverterSUT;

    setUp(() => inputConverterSUT = InputConverter());

    group('stringToUnsignedInt(String numberString)', () {
      const tSuccessResult = Right(123);
      const tFailedResult = Left(InvalidInputFailure());

      test(
        'should return an integer when the argument passed is unsigned number',
        () async {
          const argument = '123';

          final actual = inputConverterSUT.stringToUnsignedInt(argument);

          expect(actual, tSuccessResult);
        },
      );

      test(
        'should return Failure (InvalidInputFailure) when the argument passed contains invalid characters',
        () async {
          const argument = 'abc';

          final actual = inputConverterSUT.stringToUnsignedInt(argument);

          expect(actual, tFailedResult);
        },
      );

      test(
        'should return failure (InvalidInputFailure) when the argument contains signed value (negative)',
        () async {
          const argument = '-123';

          final actual = inputConverterSUT.stringToUnsignedInt(argument);

          expect(actual, tFailedResult);
        },
      );
    });
  });
}
