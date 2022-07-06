import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_reso_coder/core/error/failure.dart';

abstract class UseCase<ReturnedType, Parameter> {
  const UseCase();

  Future<Either<Failure, ReturnedType>> call([Parameter? param]);
}
