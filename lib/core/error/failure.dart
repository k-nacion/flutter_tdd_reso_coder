import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class CachedFailure extends Failure {
  const CachedFailure([super.message]);

  @override
  String toString() {
    return 'CachedFailure{message: ${super.message}';
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);

  @override
  String toString() {
    return 'NetworkFailure{message: ${super.message}';
  }
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);

  @override
  String toString() {
    return 'ServerFailure{message: ${super.message}';
  }
}
