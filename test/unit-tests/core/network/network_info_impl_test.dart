import 'dart:async';

import 'package:flutter_tdd_reso_coder/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  group('NetworkInfoImplTest.dart', () {
    late MockInternetConnectionChecker mockInternetConnectionChecker;
    late NetworkInfoImpl networkInfoImplSUT;

    setUp(() {
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      networkInfoImplSUT = NetworkInfoImpl(connectionChecker: mockInternetConnectionChecker);
    });

    group('isConnected', () {
      test(
        'should delegates the checking of internet connection to InternetConnectionChecker package',
        () async {
          when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_) async => true);

          final actual = await networkInfoImplSUT.hasInternetConnection;

          expect(actual, isTrue);
          verify(() => mockInternetConnectionChecker.hasConnection);
        },
      );
    });

    group('listenToConnectionStatus', () {
      test(
        skip: true,
        'should delegate the listening/subscribing to internet connection status to InternetConnectionChecker',
        () async {
          when(() => mockInternetConnectionChecker.onStatusChange).thenAnswer(
            (invocation) => StreamController<InternetConnectionStatus>().stream,
          );

          final actual = networkInfoImplSUT.stream;

          expect(actual, StreamController<InternetConnectionStatus>().stream);
        },
      );
    });
  });
}
