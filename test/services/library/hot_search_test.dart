import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('should', () async {
    var s = await HotSearch.request();
    logger.i(jsonEncode(s.toJson()));
  });
}
