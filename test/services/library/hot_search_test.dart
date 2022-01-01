import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';

void main() {
  test('should', () async {
    var s = await HotSearch.request();
    print(jsonEncode(s.toJson()));
  });
}
