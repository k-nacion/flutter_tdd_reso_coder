import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get isConnected async => _connectionChecker.hasConnection;

  const NetworkInfoImpl({
    required InternetConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;
}
