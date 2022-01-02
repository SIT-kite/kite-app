import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/library.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  test('holding test', () async {
    var a = await HoldingInfo.queryByBookId('54387');
    logger.i(a.holdingList);
  });

  test('near book search', () async {
    var list = await searchNearBookIdList('54387');
    logger.i(list);
  });
}
