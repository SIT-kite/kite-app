import 'package:flutter_test/flutter_test.dart';
import 'package:kite/services/library/holding.dart';
import 'package:kite/services/library/library_session.dart';
import 'package:logger/logger.dart';

void main() {
  var logger = Logger();
  var session = LibrarySession();
  test('holding test', () async {
    var a = await HoldingInfoService(session).queryByBookId('54387');
    logger.i(a.holdingList);
  });

  test('near book search', () async {
    var list = await HoldingInfoService(session).searchNearBookIdList('54387');
    logger.i(list);
  });
}
