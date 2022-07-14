import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get hasInternetConnection;

  Stream get stream;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  @override
  Future<bool> get hasInternetConnection async => _connectionChecker.hasConnection;

  NetworkInfoImpl({
    required InternetConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  @override
  Stream get stream => _connectionChecker.onStatusChange;
}
