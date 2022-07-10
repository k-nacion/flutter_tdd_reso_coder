import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';

class InputConverter {
  ///Util method that converts number string to [int] or [Failure]
  ///
  /// Returns [int] if successful.
  ///
  /// Returns [InvalidInputFailure] when the argument contains invalid characters.
  ///
  /// Retruns [InvalidInputFailure] when the argument contains signed value.
  Either<Failure, int> stringToUnsignedInt(String numberString) {
    try {
      final parsedValue = int.parse(numberString);

      if (parsedValue.isNegative) {
        throw const FormatException();
      }

      return Right(parsedValue);
    } on FormatException {
      return const Left(InvalidInputFailure());
    }
  }
}
