import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/book_search.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('search test', () async {
    var result = await searchBook(
      keyword: 'Java',
      rows: 10,
    );
    logger.d(jsonDecode(jsonEncode(result.toJson())));
  });
}
