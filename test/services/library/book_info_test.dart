import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('book_info test', () async {
    var bookInfo = await BookInfo.queryBookInfo('631021');
    logger.i(bookInfo);
  });
}
