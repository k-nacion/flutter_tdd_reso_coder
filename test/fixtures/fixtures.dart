import 'dart:io';

String fixture(String fixture) =>
    File('test/fixtures/$fixture').readAsStringSync();
