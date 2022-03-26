import 'package:flutter_test/flutter_test.dart';
import 'package:kite/feature/connectivity/service/network.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('network test', () async {
    var a = await Network.login('', '');
    logger.i(a.toJson());
  });
  test('network test', () async {
    var a = await Network.checkStatus();
    logger.i(a.toJson());
  });
}
